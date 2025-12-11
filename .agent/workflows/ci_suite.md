---
description: Run the CI suite locally (Linters, Tests, Build)
---

1. Set the DM_EXE environment variable to your BYOND installation.
   - For Windows (typical): `$env:DM_EXE="C:\Program Files (x86)\BYOND\bin\dm.exe"`
   - For Git Bash: `export DM_EXE="/c/Program Files (x86)/BYOND/bin/dm.exe"`

// turbo
2. Run Linters
   cmd: bash tools/ci/check_filedirs.sh sojourn-iskhod.dme
   cmd: bash tools/ci/check_changelogs.sh
   cmd: bash tools/ci/check_grep.sh
   cmd: bash tools/ci/check_misc.sh
   cmd: tools/bootstrap/python tools/ticked_file_enforcement/ticked_file_enforcement.py < tools/ticked_file_enforcement/schemas/sojourn_dme.json
   cmd: tools/bootstrap/python tools/ticked_file_enforcement/ticked_file_enforcement.py < tools/ticked_file_enforcement/schemas/unit_tests.json

// turbo
3. Run Build and Tests
   cmd: tools/build/build --ci lint tgui-test
   cmd: tools/bootstrap/python -m dmi.test
   cmd: tools/bootstrap/python -m mapmerge2.dmm_test
