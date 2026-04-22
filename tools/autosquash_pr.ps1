# Squash all commits on the current branch (since BASE) into a single commit.
# Run again whenever you merge master into your PR branch so the PR shows 1 commit before merge.
# On a PR branch, run with no args to squash onto the remote target (origin/master etc).
# Usage: .\tools\autosquash_pr.ps1 [-BaseBranch <name>] [-Message <msg>] [-AllowDirty]
#   -BaseBranch: default is origin/master, then origin/main, then local main/master
#   -Message: optional; default is the first commit's subject
#   -AllowDirty: allow uncommitted changes in working tree
#   -Push: after squash, force-push current branch to origin (updates the PR)

param(
    [string]$BaseBranch = "",
    [string]$Message = "",
    [switch]$AllowDirty,
    [switch]$Push
)

$ErrorActionPreference = "Stop"

$RepoRoot = (Get-Item $PSScriptRoot).Parent.FullName
Set-Location $RepoRoot

if (-not $AllowDirty) {
    $status = git diff-index --quiet HEAD -- 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Working tree has uncommitted changes. Commit or stash them, or use -AllowDirty."
    }
}

# Resolve base: any ref (local branch, origin/master, or SHA)
if (-not $BaseBranch) {
    foreach ($candidate in @("origin/master", "origin/main", "master", "main")) {
        $null = git rev-parse -q --verify $candidate 2>$null
        if ($LASTEXITCODE -eq 0) {
            $BaseBranch = $candidate
            break
        }
    }
    if (-not $BaseBranch) {
        Write-Error "No base branch given and no main/master (local or origin) found."
    }
}
$null = git rev-parse -q --verify $BaseBranch 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Error "Base ref '$BaseBranch' does not exist. Use a branch name or e.g. origin/master."
}

$BaseSha = git rev-parse $BaseBranch
$CurrentBranch = git rev-parse --abbrev-ref HEAD
# Avoid accidental squash of the base branch (compare ref names, not SHA)
$currentRef = git rev-parse --abbrev-ref HEAD
if ($currentRef -eq $BaseBranch -or ($currentRef -eq "HEAD" -and (git rev-parse HEAD) -eq $BaseSha)) {
    Write-Error "Current branch is at base $BaseBranch. Check out your PR branch first."
}

$NCommits = [int](git rev-list --count "${BaseSha}..HEAD")

if ($NCommits -le 1) {
    Write-Host "Nothing to squash: branch has $NCommits commit(s) since $BaseBranch."
    exit 0
}

if (-not $Message) {
    $Message = git log -1 --format=%s "${BaseSha}..HEAD"
}

Write-Host "Squashing $NCommits commit(s) on '$CurrentBranch' (since $BaseBranch) into one..."
git reset --soft $BaseSha
git commit -m $Message

if ($Push) {
    Write-Host "Pushing to origin/$CurrentBranch (--force-with-lease)..."
    git push --force-with-lease origin $CurrentBranch
    Write-Host "Done. PR should now show 1 commit."
} else {
    Write-Host "Done. One commit created. To update the PR, run: git push --force-with-lease origin $CurrentBranch"
}
