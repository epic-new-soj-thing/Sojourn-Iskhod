#!/usr/bin/env python3
"""
Iterate through each merged PR, check for :cl: block, and add changelog yml.
Then regenerate the HTML changelog.

Usage:
  Set BOT_TOKEN and optionally GITHUB_REPOSITORY, then:
    python tools/changelog/sync_pr_changelogs.py
    python tools/changelog/sync_pr_changelogs.py --no-html   # only write ymls, skip HTML
    python tools/changelog/sync_pr_changelogs.py --limit 20 # process at most 20 merged PRs

Requires: BOT_TOKEN (and GITHUB_REPOSITORY for non-default repo).
"""
import os
import subprocess
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parent.parent


def main():
    if not os.getenv("BOT_TOKEN"):
        print("Error: Set BOT_TOKEN environment variable.", file=sys.stderr)
        sys.exit(1)

    # Build args for generate_cl.py --all
    args = [sys.executable, str(SCRIPT_DIR / "generate_cl.py"), "--all"]
    if "--limit" in sys.argv:
        i = sys.argv.index("--limit")
        if i + 1 < len(sys.argv):
            args.extend(["--limit", sys.argv[i + 1]])
    if "--no-html" in sys.argv:
        skip_html = True
    else:
        skip_html = False

    print("Step 1: Scanning merged PRs for :cl: and writing changelog yml files...")
    result = subprocess.run(args, cwd=REPO_ROOT)
    if result.returncode != 0:
        sys.exit(result.returncode)

    if skip_html:
        print("Skipping HTML regeneration (--no-html).")
        return

    print("\nStep 2: Regenerating html/changelog.html from yml files...")
    html_result = subprocess.run(
        [
            sys.executable,
            str(SCRIPT_DIR / "ss13_genchangelog.py"),
            "html/changelog.html",
            "html/changelogs",
        ],
        cwd=REPO_ROOT,
    )
    if html_result.returncode != 0:
        sys.exit(html_result.returncode)

    print("Done. Changelog ymls and html/changelog.html are up to date.")


if __name__ == "__main__":
    main()
