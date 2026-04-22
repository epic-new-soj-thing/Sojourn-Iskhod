@echo off
rem Iterate PRs for :cl: and add changelogs, then regenerate HTML.
rem Set BOT_TOKEN (and optionally GITHUB_REPOSITORY) before running.
cd /d "%~dp0..\.."
python tools\changelog\sync_pr_changelogs.py %*
pause
