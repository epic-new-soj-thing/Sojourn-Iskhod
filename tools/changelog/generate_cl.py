"""
DO NOT MANUALLY RUN THIS SCRIPT.
---------------------------------

This script is designed to generate and push a CL file that can be later compiled.
The body of the changelog is determined by the description of the PR that was merged.

If a commit is pushed without being associated with a PR, or if a PR is missing a CL,
the script is designed to exit as a failure. This is to help keep track of PRs without
CLs and direct commits. See the relating comments in the below source to disable this function.

Single-commit mode (default): set GITHUB_SHA to the merge commit; generates one yml.
All-PRs mode: run with --all to process every merged PR in the repo and write a yml for each.

This script depends on the tags.yml file located in the same directory.

Expected environmental variables (single-commit mode):
------------------------------------------------------
GITHUB_REPOSITORY, GITHUB_TOKEN, GITHUB_SHA; optional: GIT_NAME, GIT_EMAIL

Expected environmental variables (--all mode):
----------------------------------------------
GITHUB_REPOSITORY (or pass repo as owner/name), GITHUB_TOKEN
"""
import argparse
import os
import io
import re
import sys
from pathlib import Path
from ruamel import yaml
from github import Github, Auth

CL_BODY = re.compile(r"(:cl:|🆑)(.+)?\r\n((.|\n|\r)+?)\r\n\/(:cl:|🆑)", re.MULTILINE)
# Flexible newline for reading from pr_reports (md files use \n)
CL_BODY_FLEX = re.compile(r"(:cl:|🆑)(.+)?\r?\n((.|\n|\r)+?)\r?\n\s*/(:cl:|🆑)", re.MULTILINE)
CL_SPLIT = re.compile(r"(^\w+):\s+(\w.+)", re.MULTILINE)
# Fallback: "Changelog entries (included in build):" then "- **tag:** text"
CL_ENTRIES_HEADER = re.compile(r"\*\*Changelog entries \(included in build\):\*\*\s*\n", re.IGNORECASE)
CL_ENTRIES_LINE = re.compile(r"^\s*-\s+\*\*(\w+)\*\*:\s*(.+)$", re.MULTILINE)
# Code fence that may wrap :cl: block in pr_reports (DOTALL so .*? matches newlines)
CODE_FENCE_CL = re.compile(r"```\s*\n(.*?:cl:.*?/:cl:.*?)\n\s*```", re.IGNORECASE | re.DOTALL)

SCRIPT_DIR = Path(__file__).resolve().parent
TAGS_PATH = SCRIPT_DIR / "tags.yml"
CHANGELOGS_DIR = Path.cwd() / "html" / "changelogs" / "autochangelogs"
REPORTS_DIR = SCRIPT_DIR / "pr_reports"


def load_tags():
    with open(TAGS_PATH, encoding="utf-8") as f:
        return yaml.YAML(typ="safe", pure=True).load(f)


def process_pr(pr, tags, yaml_dumper):
    """Parse PR body for :cl: block and write html/changelogs/autochangelogs/AutoChangeLog-pr-{number}.yml. Returns True if written."""
    pr_body = pr.body or ""
    pr_number = pr.number
    pr_author = pr.user.login

    try:
        cl = CL_BODY.search(pr_body)
        cl_list = CL_SPLIT.findall(cl.group(3))
    except (AttributeError, TypeError):
        return False

    write_cl = {}
    author_from_cl = (cl.group(2) or "").strip()
    write_cl["author"] = author_from_cl if author_from_cl else pr_author
    merged_at = getattr(pr, "merged_at", None)
    if merged_at:
        write_cl["date"] = merged_at.strftime("%Y-%m-%d")
    write_cl["delete-after"] = False  # Keep AutoChangeLog ymls so changelog can be regenerated without re-fetching PRs
    write_cl["changes"] = []

    for k, v in cl_list:
        if k in tags["tags"]:
            v = v.rstrip()
            if v not in list(tags["defaults"].values()):
                write_cl["changes"].append({tags["tags"][k]: v})

    if not write_cl["changes"]:
        return False

    if not CHANGELOGS_DIR.is_dir():
        try:
            CHANGELOGS_DIR.mkdir(parents=True, exist_ok=True)
        except (FileExistsError, OSError):
            if not CHANGELOGS_DIR.is_dir():
                raise
    cl_path = CHANGELOGS_DIR / f"AutoChangeLog-pr-{pr_number}.yml"
    if cl_path.exists():
        # Backfill date from API if missing (so PR dates transfer to changelog)
        try:
            existing = yaml.YAML(typ="safe", pure=True).load(cl_path.read_text(encoding="utf-8"))
            if existing is not None and not existing.get("date") and getattr(pr, "merged_at", None):
                existing["date"] = pr.merged_at.strftime("%Y-%m-%d")
                with io.StringIO() as out:
                    yaml_dumper.indent(sequence=4, offset=2)
                    yaml_dumper.default_flow_style = False
                    yaml_dumper.dump(existing, out)
                    out.seek(0)
                    cl_path.write_text(out.read(), encoding="utf-8")
        except Exception:
            pass
        return True  # Already have a file; don't redo a properly formatted :cl:
    with io.StringIO() as cl_contents:
        yaml_dumper.indent(sequence=4, offset=2)
        yaml_dumper.default_flow_style = False
        yaml_dumper.dump(write_cl, cl_contents)
        cl_contents.seek(0)
        cl_path.write_text(cl_contents.read(), encoding="utf-8")
    return True


def _parse_cl_from_report_text(text, tags):
    """Parse :cl: block or 'Changelog entries (included in build)' list from report text.
    Returns (author_str or None, list of (tag, text)) or (None, None) if nothing found."""
    # 1) If :cl: is inside a code fence (```...```), extract that block first
    search_text = text
    code_match = CODE_FENCE_CL.search(text)
    if code_match:
        search_text = code_match.group(1)
    m = CL_BODY_FLEX.search(search_text)
    if m:
        author_str = (m.group(2) or "").strip()
        cl_list = CL_SPLIT.findall(m.group(3))
        return (author_str if author_str else None, cl_list)
    # 2) Fallback: parse "**Changelog entries (included in build):**" section
    head = CL_ENTRIES_HEADER.search(text)
    if head:
        rest = text[head.end() :]
        # Stop at next ## or <details or empty line that starts a new section
        end = rest.find("\n\n<details")
        if end == -1:
            end = rest.find("\n## ")
        if end != -1:
            rest = rest[: end]
        cl_list = CL_ENTRIES_LINE.findall(rest)
        if cl_list:
            return (None, cl_list)
    return (None, None)


def process_pr_report(pr_number, author, tags, yaml_dumper, merge_date=None):
    """If PR has no :cl: in body, try to load :cl: from tools/changelog/pr_reports/PR-{number}.md and write yml. Returns True if written.
    merge_date: optional YYYY-MM-DD string from PR.merged_at (fetch from API in caller)."""
    report_path = REPORTS_DIR / f"PR-{pr_number}.md"
    if not report_path.is_file():
        return False
    try:
        text = report_path.read_text(encoding="utf-8")
    except Exception:
        return False
    author_from_report, cl_list = _parse_cl_from_report_text(text, tags)
    if not cl_list:
        return False
    write_cl = {}
    write_cl["author"] = author_from_report if author_from_report else author
    if merge_date:
        write_cl["date"] = merge_date
    write_cl["delete-after"] = False
    write_cl["changes"] = []
    for k, v in cl_list:
        if k in tags["tags"]:
            v = v.rstrip()
            if v not in list(tags["defaults"].values()):
                write_cl["changes"].append({tags["tags"][k]: v})
    if not write_cl["changes"]:
        return False
    if not CHANGELOGS_DIR.is_dir():
        try:
            CHANGELOGS_DIR.mkdir(parents=True, exist_ok=True)
        except (FileExistsError, OSError):
            if not CHANGELOGS_DIR.is_dir():
                raise
    cl_path = CHANGELOGS_DIR / f"AutoChangeLog-pr-{pr_number}.yml"
    if cl_path.exists():
        # Do not overwrite existing yml; only backfill date if missing
        if merge_date:
            try:
                existing = yaml.YAML(typ="safe", pure=True).load(cl_path.read_text(encoding="utf-8"))
                if existing is not None and not existing.get("date"):
                    existing["date"] = merge_date
                    with io.StringIO() as out:
                        yaml_dumper.indent(sequence=4, offset=2)
                        yaml_dumper.default_flow_style = False
                        yaml_dumper.dump(existing, out)
                        out.seek(0)
                        cl_path.write_text(out.read(), encoding="utf-8")
            except Exception:
                pass
        return True
    with io.StringIO() as cl_contents:
        yaml_dumper.indent(sequence=4, offset=2)
        yaml_dumper.default_flow_style = False
        yaml_dumper.dump(write_cl, cl_contents)
        cl_contents.seek(0)
        cl_path.write_text(cl_contents.read(), encoding="utf-8")
    return True


def main():
    parser = argparse.ArgumentParser(description="Generate changelog yml from PR :cl: blocks.")
    parser.add_argument("--all", action="store_true", help="Process every merged PR in the repo.")
    parser.add_argument("--pr", type=int, nargs="+", metavar="PR", dest="pr_numbers", help="Process only these PR numbers (open or merged). Uses epic-new-soj-thing/Sojourn-Iskhod.")
    parser.add_argument("--limit", type=int, default=0, metavar="N", help="With --all, stop after N PRs (0 = no limit).")
    parser.add_argument("--base", default="master", metavar="BRANCH", help="With --all, only PRs merged into this branch (default: master).")
    parser.add_argument("--repo", default=None, metavar="OWNER/REPO", help="GitHub repo for single-commit mode (ignored with --all; --all always uses epic-new-soj-thing/Sojourn-Iskhod).")
    parser.add_argument("-v", "--verbose", action="store_true", help="With --all, print every PR considered.")
    args = parser.parse_args()

    token = os.getenv("GITHUB_TOKEN")
    if not token or not isinstance(token, str):
        print("Error: GITHUB_TOKEN environment variable is not set.", file=sys.stderr)
        sys.exit(1)

    # --all and --pr always use the canonical repo
    canonical_repo = "epic-new-soj-thing/Sojourn-Iskhod"
    repo_name = canonical_repo if (args.all or args.pr_numbers) else (args.repo or os.getenv("GITHUB_REPOSITORY"))
    if not repo_name:
        print("Error: GITHUB_REPOSITORY environment variable is not set (or use --repo OWNER/REPO).", file=sys.stderr)
        sys.exit(1)

    auth = Auth.Token(token)
    git = Github(auth=auth)
    repo = git.get_repo(repo_name)

    ruamel_yaml = yaml.YAML(typ="safe", pure=True)
    tags = load_tags()

    if args.pr_numbers:
        # Process only the specified PR numbers (open or merged)
        written = 0
        for num in args.pr_numbers:
            try:
                pr = repo.get_pull(num)
            except Exception as e:
                print(f"  PR #{num}: not found or not a PR ({e})", file=sys.stderr)
                continue
            if process_pr(pr, tags, ruamel_yaml):
                written += 1
                print(f"  PR #{num}: {pr.title[:50]}... -> AutoChangeLog-pr-{num}.yml")
            else:
                merge_date = pr.merged_at.strftime("%Y-%m-%d") if getattr(pr, "merged_at", None) else None
                if process_pr_report(num, pr.user.login, tags, ruamel_yaml, merge_date=merge_date):
                    written += 1
                    print(f"  PR #{num}: {pr.title[:50]}... -> AutoChangeLog-pr-{num}.yml (from pr_reports)")
                else:
                    print(f"  PR #{num}: no :cl: or no valid entries")
        print(f"Processed {len(args.pr_numbers)} PR(s), wrote {written} changelog file(s).")
        return

    if args.all:
        # Fetch only MERGED PRs via Search API (get_pulls(state="closed") includes closed-without-merge)
        full_name = repo.full_name
        query = f"is:pr is:merged repo:{full_name}"
        merged_issues = git.search_issues(query, sort="created", order="desc")
        total_found = merged_issues.totalCount
        print(f"Found {total_found} merged PR(s) in {full_name}, filtering for base '{args.base}'...")
        if args.verbose:
            print(f"Query: {query}")
        count = written = 0
        for issue in merged_issues:
            if args.limit and count >= args.limit:
                break
            pr = repo.get_pull(issue.number)
            base_ref = getattr(pr.base, "ref", None)
            if base_ref != args.base:
                if args.verbose:
                    print(f"  Skip PR #{pr.number} (base: {base_ref}, want {args.base})")
                continue
            count += 1
            if process_pr(pr, tags, ruamel_yaml):
                written += 1
                print(f"  PR #{pr.number}: {pr.title[:50]}... -> AutoChangeLog-pr-{pr.number}.yml")
            else:
                merge_date = pr.merged_at.strftime("%Y-%m-%d") if getattr(pr, "merged_at", None) else None
                if process_pr_report(pr.number, pr.user.login, tags, ruamel_yaml, merge_date=merge_date):
                    written += 1
                    print(f"  PR #{pr.number}: {pr.title[:50]}... -> AutoChangeLog-pr-{pr.number}.yml (from pr_reports)")
                elif args.verbose:
                    print(f"  PR #{pr.number}: no :cl: or no valid entries")
        print(f"Processed {count} merged PR(s) into {args.base}, wrote {written} changelog file(s).")
        return

    # Single-commit mode (original behavior)
    sha = os.getenv("GITHUB_SHA")
    if not sha:
        print("Error: GITHUB_SHA environment variable is not set (required when not using --all).", file=sys.stderr)
        sys.exit(1)

    commit = repo.get_commit(sha)
    pr_list = commit.get_pulls()
    if not pr_list.totalCount:
        print("Direct commit detected")
        sys.exit(0)

    pr = pr_list[0]
    if process_pr(pr, tags, ruamel_yaml):
        print("Done!")
    else:
        print("No CL found or no CL changes detected!")
        sys.exit(0)


if __name__ == "__main__":
    main()
