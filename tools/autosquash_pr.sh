#!/bin/bash
# Squash all commits on the current branch (since BASE) into a single commit.
# Run again (with --push) whenever you merge master into your PR branch so the PR shows 1 commit.
# On a PR branch, run with no args to squash onto the remote target (origin/master etc).
# Usage: tools/autosquash_pr.sh [base-branch] [commit-message]
#   base-branch: default is origin/master, then origin/main, then local main/master
#   commit-message: optional; default is the first commit's subject
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

# Require clean working tree unless --allow-dirty
ALLOW_DIRTY=false
for arg in "$@"; do
  if [[ "$arg" == "--allow-dirty" ]]; then
    ALLOW_DIRTY=true
    break
  fi
done

if [[ "$ALLOW_DIRTY" == "false" ]] && ! git diff-index --quiet HEAD -- 2>/dev/null; then
  echo "fatal: Working tree has uncommitted changes. Commit or stash them, or use --allow-dirty."
  exit 1
fi

# Resolve base: explicit arg (branch name, origin/branch, or SHA), then main, then master
BASE_BRANCH=""
COMMIT_MSG=""
for arg in "$@"; do
  [[ "$arg" == "--allow-dirty" ]] && continue
  if [[ -z "$BASE_BRANCH" ]] && git rev-parse -q --verify "$arg" >/dev/null 2>&1; then
    BASE_BRANCH="$arg"
  elif [[ -z "$COMMIT_MSG" ]]; then
    COMMIT_MSG="$arg"
  fi
done

if [[ -z "$BASE_BRANCH" ]]; then
  for candidate in origin/master origin/main master main; do
    if git rev-parse -q --verify "$candidate" >/dev/null 2>&1; then
      BASE_BRANCH="$candidate"
      break
    fi
  done
  if [[ -z "$BASE_BRANCH" ]]; then
    echo "fatal: No base branch given and no main/master (local or origin) found."
    exit 1
  fi
fi

if ! git rev-parse -q --verify "$BASE_BRANCH" >/dev/null 2>&1; then
  echo "fatal: Base ref '$BASE_BRANCH' does not exist. Use a branch name or e.g. origin/master."
  exit 1
fi

BASE_SHA="$(git rev-parse "$BASE_BRANCH")"
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$CURRENT_BRANCH" == "$BASE_BRANCH" ]] || [[ "$(git rev-parse HEAD)" == "$BASE_SHA" ]]; then
  echo "fatal: Current branch is at base $BASE_BRANCH. Check out your PR branch first."
  exit 1
fi
NCOMMITS="$(git rev-list --count "$BASE_SHA..HEAD")"

if [[ "$NCOMMITS" -le 1 ]]; then
  echo "Nothing to squash: branch has $NCOMMITS commit(s) since $BASE_BRANCH."
  exit 0
fi

if [[ -z "$COMMIT_MSG" ]]; then
  COMMIT_MSG="$(git log -1 --format=%s "$BASE_SHA..HEAD")"
fi

echo "Squashing $NCOMMITS commit(s) on '$CURRENT_BRANCH' (since $BASE_BRANCH) into one..."
git reset --soft "$BASE_SHA"
git commit -m "$COMMIT_MSG"

echo "Done. One commit created. To update the PR, run: git push --force-with-lease"
