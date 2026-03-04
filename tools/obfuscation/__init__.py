# Obfuscation helpers: encode/decode text (e.g. base64) for use in DM source.
# Use for content that should not be readable in repo source but is decoded at runtime.

import base64


def b64_encode(text: str, encoding: str = "utf-8") -> str:
    """Encode text to base64. Generic for any string content."""
    return base64.b64encode(text.encode(encoding)).decode("ascii")


def b64_decode(b64: str, encoding: str = "utf-8") -> str:
    """Decode base64 to text."""
    return base64.b64decode(b64).decode(encoding)
