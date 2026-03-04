# Obfuscation tools

Encode text (e.g. base64) so it can be stored in DM source in non-readable form and decoded at runtime. Use for in-game content you want to hide from casual source inspection (e.g. guide text, HTML).

## Module

- **`tools.obfuscation`** — `b64_encode(text)` and `b64_decode(b64)` for any string content (encoding defaults to UTF-8).

## CLI: `b64_encode`

Encode any text to base64 from a file or stdin:

```bash
# From repo root
python -m tools.obfuscation.b64_encode [input_file]

# Examples
python -m tools.obfuscation.b64_encode content.html
echo "hello" | python -m tools.obfuscation.b64_encode
python -m tools.obfuscation.b64_encode < raw.txt
```

Output is the base64 string to stdout. Redirect or pipe into a writer script that writes a `.dm` file.

## Generating obfuscated data (e.g. Demonomicon)

### 1. Prepare the source content

Have the raw content in a file (e.g. HTML in `demonomicon_raw.html`). This is the text that will be stored obfuscated in the repo.

### 2. Encode to base64

**Important (Demonomicon / BYOND):** The game displays book HTML as a single-byte (Latin-1) string. If the source contains UTF-8 multi-byte characters (e.g. en-dash, curly quotes), they will render as garbage in-game. Use **ASCII-only** content: in your HTML use entities like `&mdash;`, `&rsquo;`, `&#8217;` instead of raw Unicode.

```bash
python -m tools.obfuscation.b64_encode demonomicon_raw.html
```

Copy the printed base64 string (or redirect to a file).

### 3. Write the DM data file

Use a small script or the existing writer to put that base64 into a DM file as a global. For the blood-magic demonomicon we use:

- **Input:** base64 string (e.g. from step 2 or from a temp file).
- **Output:** `code/modules/blood_magic/data.dm` with something like:
  ```dm
  // Data for blood_magic/demonomicon. Content is obfuscated (base64-encoded HTML);
  // decode at runtime in demonomicon.dm so source is not readable.
  GLOBAL_VAR_INIT(dat_b64, "<paste base64 here>")
  ```

The repo includes **`tools/write_b64_dm.py`**, which reads a base64 string from a file or stdin and writes `data.dm`:

```bash
# From file
python -m tools.obfuscation.b64_encode demonomicon_raw.html > b64_out.txt
python tools/write_b64_dm.py b64_out.txt

# Or pipe directly (from repo root)
python -m tools.obfuscation.b64_encode demonomicon_raw.html | python tools/write_b64_dm.py
```

### 4. Decode at runtime in DM

In the game code (e.g. `demonomicon.dm`), decode the global only when needed (e.g. in `Initialize()` or when opening the book) using a pure-DM base64 decoder, and assign the result to the book’s `dat` (or equivalent). The decoder is in `demonomicon.dm`; the data lives in `data.dm` and is included before the book in the `.dme`.

### Summary

| Step | Action |
|------|--------|
| 1 | Put raw content (HTML, etc.) in a file. |
| 2 | Run `python -m tools.obfuscation.b64_encode <file>` to get base64. |
| 3 | Write that base64 into a DM file (e.g. via `write_b64_dm.py` for demonomicon). |
| 4 | In DM, decode the global at runtime and use the result. |
| 5 | (Optional) Run `python -m tools.obfuscation.preview` to parse the DM and generate a sample render (e.g. `~/Downloads/obfuscated_preview.html`). |

### 5. Preview (sample render)

To **preview** decoded content without running the game, use the generic preview script. It parses a `.dm` file for `GLOBAL_VAR_INIT(var_name, "base64...")`, decodes the string, and writes a sample render (e.g. HTML) for recordkeeping:

```bash
python -m tools.obfuscation.preview [--dm PATH] [--var NAME] [--out PATH]
```

Defaults: `--dm code/modules/blood_magic/data.dm`, `--var dat_b64`, `--out ~/Downloads/obfuscated_preview.html`. Use `--dm`/`--var`/`--out` for other obfuscated data files.
