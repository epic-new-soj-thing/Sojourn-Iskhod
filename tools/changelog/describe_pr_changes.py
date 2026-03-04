#!/usr/bin/env python3
"""
Iterate merged PRs in epic-new-soj-thing/Sojourn-Iskhod, fetch each PR's file changes and diff,
generate changelog yml from :cl: blocks (same as generate_cl), and optionally use AI to describe changes.

Usage:
  Set BOT_TOKEN, then:
    python tools/changelog/describe_pr_changes.py              # list files, write reports, generate yml + HTML
    python tools/changelog/describe_pr_changes.py --no-yml    # skip yml generation and HTML compile
    python tools/changelog/describe_pr_changes.py --describe   # also run AI descriptions (needs OPENAI_API_KEY)
    python tools/changelog/describe_pr_changes.py --limit 5    # only last 5 merged PRs

Output:
  - Generates html/changelogs/autochangelogs/AutoChangeLog-pr-N.yml for each PR that has a :cl: block (via generate_cl logic).
  - Runs ss13_genchangelog to build html/changelog.html (unless --no-yml).
  - Writes markdown reports to tools/changelog/pr_reports/ (one per PR) with full diff.
  - With --describe: adds an AI-generated short description (GitHub Copilot-style).
"""
import argparse
import os
import re
import subprocess
import sys
from pathlib import Path
from typing import Optional

import requests
from github import Github, Auth
from ruamel import yaml as ruamel_yaml

CANONICAL_REPO = "epic-new-soj-thing/Sojourn-Iskhod"
SCRIPT_DIR = Path(__file__).resolve().parent
REPORTS_DIR = SCRIPT_DIR / "pr_reports"

# Changelog yml: same format and :cl: parsing as generate_cl / ss13_genchangelog
CL_BODY = re.compile(r"(:cl:|🆑)(.+)?\r?\n((.|\n|\r)+?)\r?\n\/(:cl:|🆑)", re.MULTILINE)
CL_SPLIT = re.compile(r"(^\w+):\s+(\w.+)", re.MULTILINE)
TAGS_PATH = SCRIPT_DIR / "tags.yml"
CHANGELOGS_DIR = Path.cwd() / "html" / "changelogs" / "autochangelogs"

# Extract "About The Pull Request" details content (between <details> and </details> or between ## About and ## Changelog)
ABOUT_DETAILS = re.compile(
    r"##\s*About\s+The\s+Pull\s+Request\s*[\r\n]+<details>[\r\n]+.*?<summary>[\r\n]+.*?</summary>[\r\n]+<hr>[\r\n]+(.*?)<hr>[\r\n]+</details>",
    re.DOTALL | re.IGNORECASE,
)
ABOUT_TO_CHANGELOG = re.compile(
    r"##\s*About\s+The\s+Pull\s+Request\s*(.*?)##\s*Changelog",
    re.DOTALL | re.IGNORECASE,
)


def load_tags():
    with open(TAGS_PATH, encoding="utf-8") as f:
        return ruamel_yaml.YAML(typ="safe", pure=True).load(f)


def extract_cl_block_raw(pr_body: str) -> Optional[str]:
    """Return the full :cl: ... /:cl: block from PR body, or None if missing."""
    if not pr_body:
        return None
    m = CL_BODY.search(pr_body)
    return m.group(0).strip() if m else None


def extract_cl_inner(block: str) -> str:
    """Return the inner content of a :cl: ... /:cl: block (lines between the tags)."""
    if not block:
        return ""
    m = re.search(r"(:cl:|🆑)(?:\s.*?)?\r?\n(.*?)\r?\n\s*/(:cl:|🆑)", block, re.DOTALL | re.IGNORECASE)
    return m.group(2).strip() if m else ""


def extract_about_section(pr_body: str) -> str:
    """Extract the About The Pull Request section content for the report."""
    if not pr_body:
        return ""
    m = ABOUT_DETAILS.search(pr_body)
    if m:
        return m.group(1).strip()
    m = ABOUT_TO_CHANGELOG.search(pr_body)
    if m:
        return m.group(1).strip()
    return ""


def write_yml_from_pr(pr, tags: dict, yaml_dumper) -> bool:
    """Parse PR body for :cl: block and write html/changelogs/autochangelogs/AutoChangeLog-pr-{number}.yml. Returns True if written."""
    pr_body = pr.body or ""
    try:
        cl = CL_BODY.search(pr_body)
        cl_list = CL_SPLIT.findall(cl.group(3))
    except (AttributeError, TypeError):
        return False
    write_cl = {}
    author_from_cl = (cl.group(2) or "").strip()
    write_cl["author"] = author_from_cl if author_from_cl else pr.user.login
    write_cl["delete-after"] = False
    write_cl["changes"] = []
    for k, v in cl_list:
        if k in tags.get("tags", {}):
            v = v.rstrip()
            if v not in list(tags.get("defaults", {}).values()):
                write_cl["changes"].append({tags["tags"][k]: v})
    if not write_cl["changes"]:
        return False
    if not CHANGELOGS_DIR.is_dir():
        try:
            CHANGELOGS_DIR.mkdir(parents=True, exist_ok=True)
        except (FileExistsError, OSError):
            if not CHANGELOGS_DIR.is_dir():
                raise
    cl_path = CHANGELOGS_DIR / f"AutoChangeLog-pr-{pr.number}.yml"
    if cl_path.exists():
        # Do not overwrite existing yml; only backfill date if missing
        try:
            merged_at = getattr(pr, "merged_at", None)
            if merged_at:
                existing = ruamel_yaml.YAML(typ="safe", pure=True).load(cl_path.read_text(encoding="utf-8"))
                if existing is not None and not existing.get("date"):
                    existing["date"] = merged_at.strftime("%Y-%m-%d")
                    with open(cl_path, "w", encoding="utf-8") as f:
                        yaml_dumper.indent(sequence=4, offset=2)
                        yaml_dumper.default_flow_style = False
                        yaml_dumper.dump(existing, f)
        except Exception:
            pass
        return True
    with open(cl_path, "w", encoding="utf-8") as f:
        yaml_dumper.indent(sequence=4, offset=2)
        yaml_dumper.default_flow_style = False
        yaml_dumper.dump(write_cl, f)
    return True

# Valid changelog prefixes from PR template (for AI fallback)
CHANGELOG_PREFIXES = (
    "add", "del", "tweak", "balance", "fix", "soundadd", "sounddel",
    "imageadd", "imagedel", "spellcheck", "code", "refactor", "config", "admin", "server",
)


def get_pr_diff(owner: str, repo: str, pr_number: int, token: str) -> Optional[str]:
    """Fetch the full diff for a PR via GitHub API."""
    url = f"https://api.github.com/repos/{owner}/{repo}/pulls/{pr_number}"
    r = requests.get(
        url,
        headers={
            "Accept": "application/vnd.github.v3.diff",
            "Authorization": f"token {token}",
        },
        timeout=60,
    )
    if r.status_code != 200:
        return None
    return r.text


CHANGELOG_PREFIX_LIST = "add, del, tweak, balance, fix, soundadd, sounddel, imageadd, imagedel, spellcheck, code, refactor, config, admin, server"


def generate_cl_block_with_openai(diff: str, pr_title: str, file_list: str, max_tokens: int = 400) -> Optional[str]:
    """Use OpenAI to generate a :cl: block from the diff. Returns the inner content (lines of 'prefix: description') or None."""
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        return None
    diff_sample = diff[:8000] if len(diff) > 8000 else diff
    if len(diff) > 8000:
        diff_sample += "\n\n... (diff truncated)"
    try:
        import openai
    except ImportError:
        print("  [OpenAI not installed. Run: pip install openai]", file=sys.stderr)
        return None
    try:
        client = openai.OpenAI(api_key=api_key)
        resp = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {
                    "role": "system",
                    "content": f"""You generate a changelog block for a game (Space Station 13 style). Based on the PR title and unified diff, output ONLY changelog lines. No other text.

Valid prefixes (use exactly these): {CHANGELOG_PREFIX_LIST}

Format: one line per change, "prefix: Short description" (e.g. "add: Added X" or "fix: Fixed Y"). Use 1-8 lines. Describe how a player is affected, not technical details. Ignore trivial/typo-only changes. Use add for new features, fix for bugfixes, tweak for small changes, balance for balance changes, etc.""",
                },
                {
                    "role": "user",
                    "content": f"PR title: {pr_title}\n\nFiles changed: {file_list}\n\nUnified diff:\n{diff_sample}",
                },
            ],
            max_tokens=max_tokens,
        )
        text = (resp.choices[0].message.content or "").strip()
        if not text:
            return None
        return text
    except Exception as e:
        print(f"  [OpenAI error: {e}]", file=sys.stderr)
        return None


def parse_cl_block_to_yml_entries(cl_inner: str, tags: dict) -> list:
    """Parse 'prefix: description' lines (e.g. from AI or :cl: block) into list of {tag: desc} for yml."""
    entries = []
    tag_map = tags.get("tags", {})
    for line in cl_inner.splitlines():
        line = line.strip()
        if not line or line.startswith("#") or line.startswith("<"):
            continue
        # Strip common list markers so "- fix: X" or "* add: Y" still parse
        line = re.sub(r"^[-*•]\s+", "", line)
        line = re.sub(r"^\d+\.\s+", "", line)
        m = re.match(r"^(\w+):\s+(.+)$", line)
        if not m:
            continue
        prefix, desc = m.group(1).lower(), m.group(2).strip()
        if prefix in tag_map and desc:
            entries.append({tag_map[prefix]: desc})
    return entries


def main():
    parser = argparse.ArgumentParser(
        description="List merged PRs' file changes and optionally describe them with AI (Copilot-style)."
    )
    parser.add_argument("--base", default="master", metavar="BRANCH", help="Only PRs merged into this branch.")
    parser.add_argument("--limit", type=int, default=0, metavar="N", help="Max number of merged PRs to process (0 = all).")
    parser.add_argument("--no-yml", action="store_true", help="Skip generating changelog yml and compiling html/changelog.html.")
    parser.add_argument("--describe", action="store_true", help="Use OpenAI to describe each PR's changes (set OPENAI_API_KEY).")
    parser.add_argument("-v", "--verbose", action="store_true", help="Print more detail.")
    args = parser.parse_args()

    token = os.getenv("BOT_TOKEN")
    if not token or not isinstance(token, str):
        print("Error: BOT_TOKEN environment variable is not set.", file=sys.stderr)
        sys.exit(1)

    owner, repo = CANONICAL_REPO.split("/", 1)
    auth = Auth.Token(token)
    git = Github(auth=auth)
    repo_obj = git.get_repo(CANONICAL_REPO)

    query = f"is:pr is:merged repo:{CANONICAL_REPO}"
    merged_issues = git.search_issues(query, sort="created", order="desc")
    total = merged_issues.totalCount
    print(f"Found {total} merged PR(s) in {CANONICAL_REPO}, filtering for base '{args.base}'...")

    if not REPORTS_DIR.is_dir():
        try:
            REPORTS_DIR.mkdir(parents=True, exist_ok=True)
        except (FileExistsError, OSError):
            if not REPORTS_DIR.is_dir():
                raise

    tags = None
    yaml_dumper = None
    if not args.no_yml:
        tags = load_tags()
        yaml_dumper = ruamel_yaml.YAML(typ="safe", pure=True)

    count = 0
    yml_written = 0
    for issue in merged_issues:
        if args.limit and count >= args.limit:
            break
        pr = repo_obj.get_pull(issue.number)
        base_ref = getattr(pr.base, "ref", None)
        if base_ref != args.base:
            if args.verbose:
                print(f"  Skip PR #{pr.number} (base: {base_ref})")
            continue

        count += 1
        try:
            files = list(pr.get_files())  # PaginatedList has no len(); materialize to list
        except Exception as e:
            print(f"  PR #{pr.number}: failed to get files: {e}", file=sys.stderr)
            continue

        diff = get_pr_diff(owner, repo, pr.number, token)
        additions = sum(f.additions for f in files)
        deletions = sum(f.deletions for f in files)
        file_list = ", ".join(f.filename for f in files[:10])
        if len(files) > 10:
            file_list += f" (+{len(files) - 10} more)"

        print(f"\n  PR #{pr.number}: {pr.title}")
        print(f"    Files: {len(files)} | +{additions} / -{deletions} | {file_list}")
        print(f"    Link: https://github.com/{CANONICAL_REPO}/pull/{pr.number}")

        if not args.no_yml and tags and yaml_dumper and write_yml_from_pr(pr, tags, yaml_dumper):
            yml_written += 1
            print(f"    -> AutoChangeLog-pr-{pr.number}.yml")

        pr_body = pr.body or ""
        existing_cl = extract_cl_block_raw(pr_body)
        # Only run AI when --describe and PR has NO existing :cl: block
        ai_cl_block = None
        if args.describe and not existing_cl and diff and tags:
            file_list_str = ", ".join(pf.filename for pf in files[:15])
            if len(files) > 15:
                file_list_str += f" (+{len(files) - 15} more)"
            inner = generate_cl_block_with_openai(diff, pr.title, file_list_str)
            if inner:
                ai_cl_block = f":cl:\n{inner}\n/:cl:"
                print(f"    Generated :cl: block (no :cl: in PR)")
                # Write yml from AI-generated block so it gets into the compiled changelog
                entries = parse_cl_block_to_yml_entries(inner, tags)
                if entries and not args.no_yml and yaml_dumper:
                    if not CHANGELOGS_DIR.is_dir():
                        try:
                            CHANGELOGS_DIR.mkdir(parents=True, exist_ok=True)
                        except (FileExistsError, OSError):
                            if not CHANGELOGS_DIR.is_dir():
                                raise
                    cl_path = CHANGELOGS_DIR / f"AutoChangeLog-pr-{pr.number}.yml"
                    if cl_path.exists():
                        pass  # Do not overwrite existing yml
                    else:
                        write_cl = {"author": pr.user.login, "delete-after": False, "changes": entries}
                        merged_at = getattr(pr, "merged_at", None)
                        if merged_at:
                            write_cl["date"] = merged_at.strftime("%Y-%m-%d")
                        with open(cl_path, "w", encoding="utf-8") as f:
                            yaml_dumper.indent(sequence=4, offset=2)
                            yaml_dumper.default_flow_style = False
                            yaml_dumper.dump(write_cl, f)
                        yml_written += 1
                        print(f"    -> AutoChangeLog-pr-{pr.number}.yml (from AI)")

        about_content = extract_about_section(pr_body)
        changelog_block = existing_cl if existing_cl else (ai_cl_block or "")

        # Parsed entries (what goes into the yml / build) for the report
        report_entries = []
        if changelog_block and tags:
            inner = extract_cl_inner(changelog_block)
            if inner:
                report_entries = parse_cl_block_to_yml_entries(inner, tags)

        report_path = REPORTS_DIR / f"PR-{pr.number}.md"
        with open(report_path, "w", encoding="utf-8") as out:
            out.write(f"# PR #{pr.number}: {pr.title}\n\n")
            out.write(f"- **Author:** {pr.user.login}\n")
            out.write(f"- **Link:** https://github.com/{CANONICAL_REPO}/pull/{pr.number}\n\n")
            out.write("## About The Pull Request\n")
            out.write("<details>\n<summary>About The Pull Request</summary>\n<hr>\n\n")
            out.write(about_content or "<!-- Describe The Pull Request. -->\n")
            out.write("\n<hr>\n</details>\n\n")
            out.write("## Changelog\n")
            if changelog_block:
                out.write("```\n")
                out.write(changelog_block)
                out.write("\n```\n")
            else:
                out.write("```\n:cl:\n<!-- add: ... -->\n/:cl:\n```\n")
            if report_entries:
                out.write("\n**Changelog entries (included in build):**\n\n")
                for entry in report_entries:
                    for tag, desc in entry.items():
                        out.write(f"- **{tag}:** {desc}\n")
                out.write("\n")
            out.write("<details>\n<summary>Files changed</summary>\n\n")
            for pf in files:
                out.write(f"- `{pf.filename}` (+{pf.additions} / -{pf.deletions}) {getattr(pf, 'status', '')}\n")
            out.write("\n</details>\n\n<details>\n<summary>Diff</summary>\n\n```diff\n")
            out.write((diff or "(no diff)").replace("```", "` ` `"))
            out.write("\n```\n</details>\n")
        if args.verbose:
            print(f"    Wrote {report_path}")

    print(f"\nProcessed {count} merged PR(s), wrote {yml_written} changelog yml(s). Reports in {REPORTS_DIR}")

    if not args.no_yml:
        repo_root = Path.cwd() if (Path.cwd() / "html" / "changelog.html").exists() else SCRIPT_DIR.parent.parent
        print("\nCompiling html/changelog.html from yml files...")
        r = subprocess.run(
            [sys.executable, str(SCRIPT_DIR / "ss13_genchangelog.py"), "html/changelog.html", "html/changelogs"],
            cwd=repo_root,
        )
        if r.returncode != 0:
            print("Warning: ss13_genchangelog.py exited with code", r.returncode, file=sys.stderr)
        else:
            print("Done. html/changelog.html updated.")

    if args.describe and not os.getenv("OPENAI_API_KEY"):
        print("Tip: Set OPENAI_API_KEY for --describe to get AI summaries (GitHub Copilot-style).")


if __name__ == "__main__":
    main()
