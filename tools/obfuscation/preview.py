#!/usr/bin/env python3
"""
Parse a DM file for a GLOBAL_VAR_INIT(var_name, "base64..."), decode, and write a sample render
(e.g. HTML) for recordkeeping. Generic for any obfuscated content stored as base64 in a .dm file.

Usage:
  python -m tools.obfuscation.preview [--dm PATH] [--var NAME] [--out PATH]

Defaults: --dm code/modules/blood_magic/data.dm, --var dat_b64, --out ~/Downloads/obfuscated_preview.html
"""

import argparse
import re
import sys
from pathlib import Path

_THIS_DIR = Path(__file__).resolve().parent
_REPO_ROOT = _THIS_DIR.parent.parent if _THIS_DIR.name == "obfuscation" else _THIS_DIR.parent
if str(_REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(_REPO_ROOT))

from tools.obfuscation import b64_decode

# Optional: inject no-copy style into HTML content (same as in-game anti-cheat)
NOCOPY_STYLE = (
    "<style>body,*{user-select:none !important;-webkit-user-select:none !important;"
    "-moz-user-select:none !important;-ms-user-select:none !important;}</style>"
)


def _extract_b64(dm_path: Path, var_name: str) -> str:
    text = dm_path.read_text(encoding="utf-8")
    # GLOBAL_VAR_INIT(var_name, "..." )  — allow optional whitespace/newlines in the string for very long content
    pattern = re.compile(
        r"GLOBAL_VAR_INIT\s*\(\s*"
        + re.escape(var_name)
        + r'\s*,\s*"((?:[^"\\]|\\.)*)"\s*\)',
        re.DOTALL,
    )
    m = pattern.search(text)
    if not m:
        raise SystemExit(f'Could not find GLOBAL_VAR_INIT({var_name}, "...") in {dm_path}')
    # Unescape any \" inside the string
    raw = m.group(1).replace('\\"', '"').strip()
    return raw


def main() -> None:
    ap = argparse.ArgumentParser(description="Decode base64 from a DM file and write a sample render.")
    ap.add_argument(
        "--dm",
        type=Path,
        default=_REPO_ROOT / "code" / "modules" / "blood_magic" / "data.dm",
        help="Path to .dm file containing GLOBAL_VAR_INIT(var, \"base64...\")",
    )
    ap.add_argument(
        "--var",
        default="dat_b64",
        help="Global variable name in GLOBAL_VAR_INIT",
    )
    ap.add_argument(
        "--out",
        type=Path,
        default=Path.home() / "Downloads" / "obfuscated_preview.html",
        help="Output path for decoded content (e.g. .html)",
    )
    args = ap.parse_args()

    dm_path = args.dm if args.dm.is_absolute() else _REPO_ROOT / args.dm
    if not dm_path.is_file():
        raise SystemExit(f"Not a file: {dm_path}")

    b64 = _extract_b64(dm_path, args.var)
    content = b64_decode(b64)
    # Fix missing leading "<" so document starts with "<html>" not "html>"
    if content.startswith("html>"):
        content = "<" + content

    # If content looks like HTML, optionally inject no-copy style and add a comment
    if "</style></head>" in content:
        content = content.replace("</style></head>", "</style>" + NOCOPY_STYLE + "</head>")
    comment = "<!-- Sample render: decoded from obfuscated base64 in DM; content may be non-copyable. -->\n"
    out = comment + content

    out_path = args.out if args.out.is_absolute() else _REPO_ROOT / args.out
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(out, encoding="utf-8")
    print("Wrote", out_path)


if __name__ == "__main__":
    main()
