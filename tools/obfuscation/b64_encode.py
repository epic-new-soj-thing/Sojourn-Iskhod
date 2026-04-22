#!/usr/bin/env python3
"""
Generic CLI: encode text to base64. Use for obfuscating any content (HTML, JSON, etc.).

Usage:
  python -m tools.obfuscation.b64_encode [input_file]
  python -m tools.obfuscation.b64_encode < input.txt
  echo "text" | python -m tools.obfuscation.b64_encode

If no file is given, reads from stdin. Output is the base64 string to stdout.
"""

import sys
from pathlib import Path

# Ensure repo root on path when run as __main__ or as script
_THIS_DIR = Path(__file__).resolve().parent
_REPO_ROOT = _THIS_DIR.parent.parent if _THIS_DIR.name == "obfuscation" else _THIS_DIR.parent
if str(_REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(_REPO_ROOT))

from tools.obfuscation import b64_encode as encode_text


def main() -> None:
    if len(sys.argv) > 1:
        path = Path(sys.argv[1])
        if not path.is_file():
            sys.exit(f"Not a file: {path}")
        text = path.read_text(encoding="utf-8")
    else:
        text = sys.stdin.read()
    print(encode_text(text))


if __name__ == "__main__":
    main()
