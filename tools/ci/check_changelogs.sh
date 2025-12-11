#!/bin/bash
set -euo pipefail

md5sum -c - <<< "4bb630000df21db3cd50bec865d7d792 *html/changelogs/example.yml"
python3 tools/changelog/ss13_genchangelog.py html/changelogs
