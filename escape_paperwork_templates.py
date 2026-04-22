#!/usr/bin/env python3
"""Escape [ and ] in template block strings in requests_console_paperwork.dm
so DM doesn't treat them as variable interpolation. Only touches content
between "content" = {" and "})), and only above req_console_paperwork_to_pencode.
"""
import re

path = "code/game/machinery/requests_console_paperwork.dm"

with open(path, "r", encoding="utf-8") as f:
    text = f.read()

# Only process the part before the to_pencode proc (don't touch replacetext calls)
marker = "\n/proc/req_console_paperwork_to_pencode"
if marker not in text:
    raise SystemExit("Could not find /proc/req_console_paperwork_to_pencode")
before, after = text.split(marker, 1)
work = before
rest = marker + after

def escape_brackets(s: str) -> str:
    # Only escape [ and ] not already escaped (avoid double-escaping)
    s = re.sub(r"(?<!\\)\[", r"\\[", s)
    s = re.sub(r"(?<!\\)\]", r"\\]", s)
    return s

# Match each "content" = {" ... "})) block (content can span lines)
# Use non-greedy .*? with DOTALL so we stop at the first "}))
pattern = re.compile(
    r'("content" = \{")(.*?)("\}\)\))',
    re.DOTALL
)

def repl(m):
    prefix, content, suffix = m.group(1), m.group(2), m.group(3)
    return prefix + escape_brackets(content) + suffix

work = pattern.sub(repl, work)

with open(path, "w", encoding="utf-8") as f:
    f.write(work + rest)

print("Escaped brackets in template block strings.")
