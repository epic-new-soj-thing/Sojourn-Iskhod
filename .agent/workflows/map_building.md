---
description: Build the map and run tests, ensuring correct DM environment
---

1. Set the DM_EXE environment variable to your BYOND installation if not auto-detected.
   - For Windows (typical): `$env:DM_EXE="C:\Program Files (x86)\BYOND\bin\dm.exe"`
   - For Git Bash: `export DM_EXE="/c/Program Files (x86)/BYOND/bin/dm.exe"`

// turbo
2. Run the build command
   cmd: tools/build/build dm
