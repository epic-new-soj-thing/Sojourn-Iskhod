#!/usr/bin/env python3
# Write code/modules/blood_magic/data.dm from a base64 string (file or stdin).
# Generate the base64 with: python -m tools.obfuscation.b64_encode content.html

import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
DATA_DM = REPO_ROOT / "code" / "modules" / "blood_magic" / "data.dm"


def main() -> None:
    if len(sys.argv) > 1:
        path = Path(sys.argv[1])
        b64 = path.read_text(encoding="utf-8").strip()
    else:
        b64 = sys.stdin.read().strip()

    out = (
        "// Data for blood_magic/demonomicon. Content is obfuscated (base64-encoded HTML);\n"
        "// decode at runtime in demonomicon.dm so source is not readable. Regenerate via tools/obfuscation.\n"
        'GLOBAL_VAR_INIT(dat_b64, "' + b64 + '")\n'
    )
    DATA_DM.write_text(out, encoding="utf-8")
    print("Wrote", DATA_DM)


if __name__ == "__main__":
    main()
