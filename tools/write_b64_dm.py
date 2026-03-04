#!/usr/bin/env python3
# Write code/modules/blood_magic/data.dm from a base64 string (file or stdin).
# Generate the base64 with: python -m tools.obfuscation.b64_encode content.html
#
# Automatically normalizes content to ASCII (non-ASCII -> &#code;) so BYOND
# displays the book text correctly (single-byte Latin-1); no separate fix step.

import base64
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
DATA_DM = REPO_ROOT / "code" / "modules" / "blood_magic" / "data.dm"


def normalize_to_ascii_html(html: str) -> str:
    """Replace every non-ASCII character with &#decimal; so BYOND renders correctly."""
    parts = []
    for c in html:
        if ord(c) <= 127:
            parts.append(c)
        else:
            parts.append(f"&#{ord(c)};")
    return "".join(parts)


def main() -> None:
    if len(sys.argv) > 1:
        path = Path(sys.argv[1])
        b64 = path.read_text(encoding="utf-8").strip()
    else:
        b64 = sys.stdin.read().strip()

    # Decode base64 -> UTF-8 HTML, normalize to ASCII-only, re-encode to base64
    raw_bytes = base64.b64decode(b64)
    html = raw_bytes.decode("utf-8")
    ascii_html = normalize_to_ascii_html(html)
    b64 = base64.b64encode(ascii_html.encode("ascii")).decode("ascii")

    out = (
        "// Data for blood_magic/demonomicon. Content is obfuscated (base64-encoded HTML);\n"
        "// decode at runtime in demonomicon.dm so source is not readable. Regenerate via tools/obfuscation.\n"
        'GLOBAL_VAR_INIT(dat_b64, "' + b64 + '")\n'
    )
    DATA_DM.write_text(out, encoding="utf-8")
    print("Wrote", DATA_DM)


if __name__ == "__main__":
    main()
