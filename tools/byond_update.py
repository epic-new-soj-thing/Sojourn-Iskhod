#!/usr/bin/env python3
"""
Server update script for BYOND: check/pull from GitHub and run byond-update.
Used by the game server to apply updates only on next restart.

Commands:
  check_and_pull     Fetch and pull from GitHub (current branch). Notify that updates will apply on next restart.
  run_update         Run byond-update (main | testmerge PR [PR ...] | sync) with optional flags. Run before shutdown.
  run_update_auto    Read testmerges from file; if file exists with PR numbers run testmerge, else run main. For restart.

Environment:
  BYOND_UPDATE_REMOTE_URL  If set, use this URL for origin before fetch/pull (e.g. https://github.com/owner/repo.git).
                           Use when the server process has no SSH key; avoids "Permission denied (publickey)".
"""

import argparse
import os
import subprocess
import sys
from typing import Optional

# Default paths (override with env BYOND_UPDATE_PATH, REPO_PATH, TESTMERGES_FILE)
BYOND_UPDATE_PATH = os.environ.get("BYOND_UPDATE_PATH", "/home/server/bin/byond-update")
REPO_PATH = os.environ.get("REPO_PATH", ".")
TESTMERGES_FILE = os.environ.get("TESTMERGES_FILE", "/home/server/start/tmp/testmerges.txt")
BYOND_UPDATE_REMOTE_URL = os.environ.get("BYOND_UPDATE_REMOTE_URL", "https://github.com/epic-new-soj-thing/Sojourn-Iskhod.git")


# Exit codes for check_and_pull (so DM can notify only when there are new changes)
EXIT_ALREADY_UP_TO_DATE = 0
EXIT_ERROR = 1
EXIT_CHANGES_PULLED = 2


def _git_rev_list_count(repo_path: str, older: str, newer: str, timeout: int = 10) -> int:
    """Return number of commits in newer that are not in older (commits reachable from newer but not from older)."""
    r = subprocess.run(
        ["git", "rev-list", "--count", older + ".." + newer],
        cwd=repo_path,
        capture_output=True,
        text=True,
        timeout=timeout,
    )
    if r.returncode != 0:
        return 0
    try:
        return int(r.stdout.strip() or 0)
    except ValueError:
        return 0


def check_and_pull(
    repo_path: str,
    testmerges_file: Optional[str] = None,
    output_file: Optional[str] = None,
) -> int:
    """Fetch and pull from origin master; check for differences on main and testmerge PRs.
    Compares local HEAD with origin/master and with each testmerge PR ref (from testmerges_file).
    If testmerges_file is set, read it after pull and write next-restart mode to output_file:
    one line: "testmerge 123 456" or "main". Actual testmerge is done by run_update_auto (byond-update testmerge).
    Returns EXIT_ALREADY_UP_TO_DATE (0), EXIT_ERROR (1), or EXIT_CHANGES_PULLED (2) when new commits were pulled
    or when main or any testmerge PR has new commits on the remote.
    """
    repo_path = os.path.abspath(repo_path)
    if not os.path.isdir(os.path.join(repo_path, ".git")):
        print(f"Not a git repo: {repo_path}", file=sys.stderr)
        return EXIT_ERROR

    # Use this URL for origin so fetch/pull use HTTPS instead of SSH (avoids "Permission denied (publickey)" when the process has no SSH key).
    remote_url = BYOND_UPDATE_REMOTE_URL
    if remote_url:
        r = subprocess.run(
            ["git", "remote", "set-url", "origin", remote_url],
            cwd=repo_path,
            capture_output=True,
            text=True,
            timeout=5,
        )
        if r.returncode != 0:
            print(f"git remote set-url failed: {r.stderr}", file=sys.stderr)
            return EXIT_ERROR

    try:
        r = subprocess.run(
            ["git", "rev-parse", "HEAD"],
            cwd=repo_path,
            capture_output=True,
            text=True,
            timeout=5,
        )
        if r.returncode != 0:
            return EXIT_ERROR
        head_before = r.stdout.strip()

        r = subprocess.run(
            ["git", "fetch", "origin"],
            cwd=repo_path,
            capture_output=True,
            text=True,
            timeout=60,
        )
        if r.returncode != 0:
            print(f"git fetch failed: {r.stderr}", file=sys.stderr)
            return EXIT_ERROR

        # Read testmerge PRs early so we can fetch their refs and check for updates
        prs = read_testmerges_file(testmerges_file) if testmerges_file else []
        # Fetch each PR ref (GitHub: pull/ID/head)
        for pr_num in prs:
            refspec = f"pull/{pr_num}/head:refs/remotes/origin/pr/{pr_num}"
            subprocess.run(
                ["git", "fetch", "origin", refspec],
                cwd=repo_path,
                capture_output=True,
                text=True,
                timeout=30,
            )

        # Check for new commits on main (origin/master ahead of local HEAD)
        main_has_updates = _git_rev_list_count(repo_path, "HEAD", "origin/master") > 0

        # Check for new commits on any testmerge PR (remote PR ref ahead of local HEAD)
        pr_has_updates = False
        for pr_num in prs:
            ref = f"refs/remotes/origin/pr/{pr_num}"
            if _git_rev_list_count(repo_path, "HEAD", ref) > 0:
                pr_has_updates = True
                break

        # Pull master (may fail when on testmerge branch; we still report based on checks above)
        r = subprocess.run(
            ["git", "pull", "--ff-only", "origin", "master"],
            cwd=repo_path,
            capture_output=True,
            text=True,
            timeout=120,
        )
        pulled_new = False
        if r.returncode == 0:
            r2 = subprocess.run(
                ["git", "rev-parse", "HEAD"],
                cwd=repo_path,
                capture_output=True,
                text=True,
                timeout=5,
            )
            head_after = r2.stdout.strip() if r2.returncode == 0 else head_before
            pulled_new = head_before != head_after
            if pulled_new:
                print("New changes pulled from GitHub.", file=sys.stderr)
        else:
            # On testmerge branch pull often fails (not ff); don't treat as fatal
            if not main_has_updates and not pr_has_updates:
                print(f"git pull failed: {r.stderr}", file=sys.stderr)
                return EXIT_ERROR

        has_updates = pulled_new or main_has_updates or pr_has_updates
        result = EXIT_CHANGES_PULLED if has_updates else EXIT_ALREADY_UP_TO_DATE

        # Periodic check: write what the next restart will do (testmerge PRs or main) for notifications
        if testmerges_file and output_file:
            line = f"testmerge {' '.join(str(p) for p in prs)}" if prs else "main"
            try:
                with open(output_file, "w") as f:
                    f.write(line + "\n")
            except OSError:
                pass
        return result

    except subprocess.TimeoutExpired:
        print("git command timed out", file=sys.stderr)
        return EXIT_ERROR
    except FileNotFoundError:
        print("git not found", file=sys.stderr)
        return EXIT_ERROR


def read_testmerges_file(path: str) -> list[int]:
    """Read space-separated PR numbers from file. Returns empty list if file missing or empty or invalid."""
    if not path or not os.path.isfile(path):
        return []
    try:
        with open(path, "r") as f:
            raw = f.read()
    except OSError:
        return []
    prs: list[int] = []
    for part in raw.split():
        try:
            n = int(part)
            if n > 0:
                prs.append(n)
        except ValueError:
            continue
    return prs


def run_update_auto(
    testmerges_file: str,
    byond_update_path: str,
    conflict: str = "abort",
    no_sync: bool = False,
    no_backup: bool = False,
) -> int:
    """If testmerges file exists and has PR numbers, run testmerge; otherwise run main."""
    prs = read_testmerges_file(testmerges_file)
    if prs:
        return run_update(
            mode="testmerge",
            prs=prs,
            conflict=conflict,
            no_sync=no_sync,
            no_backup=no_backup,
            byond_update_path=byond_update_path,
        )
    return run_update(
        mode="main",
        prs=[],
        conflict=conflict,
        no_sync=no_sync,
        no_backup=no_backup,
        byond_update_path=byond_update_path,
    )


def run_update(
    mode: str,
    prs: list[int],
    conflict: str,
    no_sync: bool,
    no_backup: bool,
    byond_update_path: str,
) -> int:
    """Run the byond-update binary with the given arguments."""
    args = [byond_update_path]
    if mode == "main":
        args.append("main")
    elif mode == "testmerge":
        if not prs:
            print("testmerge requires at least one PR number", file=sys.stderr)
            return 1
        args.append("testmerge")
        args.extend(str(p) for p in prs)
    elif mode == "sync":
        args.append("sync")
    else:
        print(f"Unknown mode: {mode}", file=sys.stderr)
        return 1

    if conflict == "incoming":
        args.append("--incoming")
    elif conflict == "current":
        args.append("--current")
    # abort = default, no flag

    if no_sync and mode != "sync":
        args.append("--no-sync")
    if no_backup and mode != "sync":
        args.append("--no-backup")

    try:
        r = subprocess.run(args, timeout=600)
        return r.returncode
    except FileNotFoundError:
        print(f"byond-update not found: {byond_update_path}", file=sys.stderr)
        return 1
    except subprocess.TimeoutExpired:
        print("byond-update timed out", file=sys.stderr)
        return 1


def main() -> int:
    parser = argparse.ArgumentParser(description="BYOND server update helper")
    sub = parser.add_subparsers(dest="command", required=True)

    # check_and_pull
    p_pull = sub.add_parser("check_and_pull", help="Fetch and pull from GitHub")
    p_pull.add_argument("--repo", default=REPO_PATH, help="Repo path (default: REPO_PATH or .)")
    p_pull.add_argument("--testmerges-file", help="If set, read after pull and write next-restart mode to --output-file")
    p_pull.add_argument("--output-file", help="Write one line: 'testmerge N N...' or 'main' for periodic check notifications")

    # run_update_auto: read testmerges from file, run testmerge or main
    p_auto = sub.add_parser("run_update_auto", help="Run testmerge from file or main (for restart)")
    p_auto.add_argument("--testmerges-file", default=TESTMERGES_FILE, help="Path to file with space-separated PR numbers")
    p_auto.add_argument("--incoming", dest="conflict", action="store_const", const="incoming")
    p_auto.add_argument("--current", dest="conflict", action="store_const", const="current")
    p_auto.add_argument("--abort", dest="conflict", action="store_const", const="abort")
    p_auto.add_argument("--no-sync", action="store_true", help="Skip syncing saves/config/data")
    p_auto.add_argument("--no-backup", action="store_true", help="Do not create backup")
    p_auto.add_argument("--byond-update-path", default=BYOND_UPDATE_PATH, help="Path to byond-update binary")

    # run_update
    p_run = sub.add_parser("run_update", help="Run byond-update before restart")
    p_run.add_argument("mode", choices=["main", "testmerge", "sync"], help="Update mode")
    p_run.add_argument("prs", nargs="*", type=int, help="PR numbers (for testmerge only)")
    p_run.add_argument("--incoming", dest="conflict", action="store_const", const="incoming")
    p_run.add_argument("--current", dest="conflict", action="store_const", const="current")
    p_run.add_argument("--abort", dest="conflict", action="store_const", const="abort")
    p_run.add_argument("--no-sync", action="store_true", help="Skip syncing saves/config/data")
    p_run.add_argument("--no-backup", action="store_true", help="Do not create backup")
    p_run.add_argument("--byond-update-path", default=BYOND_UPDATE_PATH, help="Path to byond-update binary")

    args = parser.parse_args()

    if args.command == "check_and_pull":
        return check_and_pull(
            args.repo,
            testmerges_file=getattr(args, "testmerges_file", None),
            output_file=getattr(args, "output_file", None),
        )

    if args.command == "run_update_auto":
        conflict = getattr(args, "conflict", None) or "abort"
        return run_update_auto(
            testmerges_file=args.testmerges_file,
            byond_update_path=args.byond_update_path,
            conflict=conflict,
            no_sync=getattr(args, "no_sync", False),
            no_backup=getattr(args, "no_backup", False),
        )

    if args.command == "run_update":
        conflict = getattr(args, "conflict", None) or "abort"
        return run_update(
            mode=args.mode,
            prs=args.prs or [],
            conflict=conflict,
            no_sync=getattr(args, "no_sync", False),
            no_backup=getattr(args, "no_backup", False),
            byond_update_path=args.byond_update_path,
        )

    return 0


if __name__ == "__main__":
    sys.exit(main() or 0)
