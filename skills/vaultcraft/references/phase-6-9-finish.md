# vaultcraft: phases 6 to 9 (embed, visualize, MOC, quality pass)

## Phase 6 - Embed source materials (DEFAULT - run automatically)

**When to run:** automatically at the end of Phase 5, for ALL vault types, whenever source files (PDFs, PPTX) are available. Do not wait for the user to ask. If no source files were provided, skip silently.

**Why this matters:** Obsidian renders `![[file.pdf]]` as an inline scrollable PDF viewer. Students can see the original presentation inside the note while reading their summary. Native support for `.pdf` and images only — `.pptx` and `.docx` show as file-link cards without inline preview.

**Required conversion:** if source materials are `.pptx` or `.docx`, convert to PDF first using LibreOffice headless.

```bash
# Check / install LibreOffice (one-time, ~600 MB on macOS)
which soffice || echo "LibreOffice missing: ask the user before running brew install --cask libreoffice"
# Path on macOS: /Applications/LibreOffice.app/Contents/MacOS/soffice

# Convert pptx/docx → pdf (preserves layout, tables, images)
soffice --headless --convert-to pdf --outdir <output_dir> <input.pptx>
```

For Chrome-headless fallback (no LibreOffice install): `textutil -convert html` then Chrome `--headless --print-to-pdf` — works for docx, fails for pptx.

**Workflow:**

1. Locate source files (ask user where they live: typical paths are `~/Desktop/<Course>/`, `~/Downloads/`, OneDrive folders).
2. Identify lecture-to-file mapping by content peek (`pdftotext "$f" - | head -10` or `unzip -p file.pptx 'ppt/slides/slide1.xml' | sed 's/<[^>]*>/ /g'`). Course materials usually number L01–LXX or S01–SXX but original filenames vary wildly (`session1.pdf`, `2026-NLP-session-04.pdf`, `Lecture 6 - Intro ARIMA - F26.pdf`).
3. Create `<vault>/<Course>/Slides/` directory if missing.
4. Copy each file with a stable normalized name: `L01_slides.pdf`, `L02_slides.pdf`, ..., `S00_slides.pdf` (DPD uses S## for sessions). For Examples / problem sets: `<vault>/<Course>/Examples/Slides/PS01_solutions.pdf`.
5. Convert any `.pptx` / `.docx` to `.pdf` via LibreOffice. Delete the source pptx/docx from the vault after a successful conversion (the PDF carries identical content; keeping both wastes 100–500 MB across a course).
6. For each lecture note, insert this callout immediately after the frontmatter closing `---`:

   ```markdown
   > [!example]+ 🎞️ Course slides (auto-embedded)
   > ![[L01_slides.pdf]]
   ```

   - The `+` after `[!example]` means expanded by default. Use `-` (collapsed) if the user prefers slides hidden until clicked.
   - Add bonus material as a nested entry: `> \n> **Bonus**: ![[L04_bonus.pdf]]`.
7. If the note already contains the marker `Course slides (auto-embedded)`, skip it (idempotent).
8. Add `source-file: <original filename>` to the lecture note frontmatter so the original mapping is preserved.

**Reference Python embedding script:**

```python
import re
from pathlib import Path

def insert_slide_callout(note_path: Path, slide_filename: str, bonus: list[str] = None):
    txt = note_path.read_text(encoding='utf-8')
    if "Course slides (auto-embedded)" in txt or f"![[{slide_filename}]]" in txt:
        return False  # idempotent
    if txt.startswith("---\n"):
        end = txt.find("\n---\n", 4)
        insert_at = end + 5 if end != -1 else 0
    else:
        insert_at = 0
    callout = f"\n> [!example]+ 🎞️ Course slides (auto-embedded)\n> ![[{slide_filename}]]\n"
    for b in (bonus or []):
        callout += f"> \n> **Bonus**: ![[{b}]]\n"
    callout += "\n"
    note_path.write_text(txt[:insert_at] + callout + txt[insert_at:], encoding='utf-8')
    return True

# Walk lectures and embed matching slides
for note in sorted((VAULT / "ML" / "Lectures").glob("*.md")):
    m = re.match(r'L(\d+)', note.stem)
    if not m: continue
    n = int(m.group(1))
    slide = VAULT / "ML" / "Slides" / f"L{n:02d}_slides.pdf"
    if slide.exists():
        insert_slide_callout(note, slide.name)
```

**Same pattern for Examples / Problem Sets** (PS01 ↔ L01, PS02 ↔ L02, etc.):

```markdown
> [!example]+ 📄 Solution PDF
> ![[PS01_solutions.pdf]]
```

**Same pattern for Readings** — embed full paper PDF in the reading summary note:

```markdown
> [!example]+ 📄 Full paper (PDF)
> ![[BrynjolfssonMcAfee_AI_For_Real.pdf]]
```

**File naming hygiene after the import:**

- Drop generic names (`EBSCO-FullText-04_24_2026 (1).pdf`) — rename PDFs by content (`pdftotext "$f" - | head -10` reveals title/author).
- Delete duplicate PDFs (compare with `md5 -q`).
- After conversion, delete `.pptx` / `.docx` sources from `<vault>/<Course>/Slides/` — the PDF replaces them, embeds work, and you save 50–80% disk space.

**Cleanup of source folders:**
After confirming all files are copied into vault and embeds render correctly (open Obsidian, verify a sample lecture shows the PDF inline), the original course folders on Desktop / Downloads can be moved to Trash via Finder AppleScript:

```bash
osascript -e 'tell application "Finder" to delete (POSIX file "/path/to/source" as alias)'
```

Always copy first (`cp`), never move (`mv`) — vault must have an independent copy.

**Audit after embedding:**
Run the broken-embed check from Phase 9 — `![[L01_slides.pdf]]` should resolve in every lecture note. Slide files become "orphan" in some naive audits because the same filename (`L01_slides.pdf`) exists in multiple courses; a path-aware resolver (Phase 9) avoids that false positive.

---

## Phase 7 - Visualize (Low Priority)

**Canvas is nice-to-have, not core.** Do not burn generation budget on elaborate visual layouts. Priority: concept-note depth (Phase 4) → lecture notes (Phase 5) → MOC (Phase 8). Build Canvas only if budget allows.

Two layers, in priority order:

1. **Per-note Mermaid** - inline diagrams inside concept notes where the concept is inherently structural. Skip where a diagram would be decorative.
2. **Vault-wide JSON Canvas** (`01 - Course Map.canvas`) - *optional*. If built, keep minimal: one central MOC node, one node per lecture, one node per main concept cluster (~30–40 total). Simple radial layout. If it would take significant time, skip and note: "Canvas skipped - MOC provides sufficient navigation."

Do NOT build taxonomy canvases, sub-canvases, or multiple canvas views.

## Phase 8 - Map of Content + Tables

**`00 - Start Here.md` (MOC):**

- Course title, exam date.
- "Quick start" section: pointer to `Tables.md` for oral-exam prep, then lecture list.
- Lecture-by-lecture section: each `### [[L0X - Title]]` followed by a one-paragraph summary + inline wikilinks to every concept introduced.
- Optional "A–Z Concept Index" as a sorted bulleted list of all concept wikilinks.

**`Tables.md` (STRONGLY RECOMMENDED for oral exams):**
One root-level file with comparison tables covering the major dimensions of the course. Each table has an "Say this" or "Elevator pitch" column with a one-sentence recitation for oral exams. Typical tables for an NLP/ML course:

- Classifiers: Naive Bayes vs Logistic Regression vs SVM vs Neural Networks
- Text representations: BoW vs TF-IDF vs Word2Vec vs GloVe vs BERT
- Smoothing methods
- Topic models
- Attention mechanisms
- Decoding strategies (greedy/beam/top-k/top-p/temperature)
- Preprocessing pipeline
- Evaluation metrics by task

End with an "Elevator pitch bank" - one memorized sentence per key concept.

**`02 - Study Dashboard.base` (optional):**
Generate via the `obsidian-bases` skill: a filterable table of all `concept` notes showing `status`, `difficulty`, `exam-likely`, sortable and filterable. Honest warning: the Base only earns its keep if the user actively updates `status` during review. If the user is unlikely to do that, skip.

## Phase 9 - Quality Pass

Before declaring done:

- **Depth check (CRITICAL)** - for each lecture, re-read slides and verify: "Did I create a note for every named technique, variant, algorithm, metric, or method? If a slide lists {A, B, C, D}, do I have notes for A, B, C, and D?" If a named sub-technique is only in prose inside another note, extract it.
- Scan for orphan notes (0 backlinks) - add wikilinks from a natural parent to connect them. Exclude MOC and README from this check.
- Check every concept note has: definition callout at top, ≥ 1 example, ≥ 2 outbound wikilinks, ≥ 2 flashcards.
- Verify Mermaid syntax where used.
- If Canvas exists: verify it's valid JSON and references real note paths.
- Broken-link audit:

  ```python
  import os, re
  vault = '<path>'
  existing = set()
  for root, _, fs in os.walk(vault):
      if '.obsidian' in root: continue
      for f in fs:
          if f.endswith('.md'): existing.add(f[:-3])
  def strip_code(t): return re.sub(r'```.*?```', '', t, flags=re.DOTALL)
  broken = []
  for root, _, fs in os.walk(vault):
      if '.obsidian' in root: continue
      for f in fs:
          if not f.endswith('.md'): continue
          with open(os.path.join(root, f)) as fh: c = strip_code(fh.read())
          for m in re.findall(r'\[\[([^\]|#\^]+)(?:[|#\^][^\]]*)?\]\]', c):
              if m.strip() not in existing: broken.append((f, m.strip()))
  ```

  Fix every hit (wrong target → correct; missing but ≥3 refs → stub; missing and <3 refs → plain italic text).

**Bidirectional link audit (studies vaults):**
Every concept note has `source: [[LXX - ...]]` in frontmatter. Every lecture note has `## Concepts introduced` with wikilinks. These must match. Run this check:

```python
import os, re, yaml
vault = '<path>'
# Build: concept → declared source lecture
concept_sources = {}
for root, _, fs in os.walk(vault):
    for f in fs:
        if not f.endswith('.md') or '.obsidian' in root: continue
        txt = open(os.path.join(root, f)).read()
        fm = re.match(r'^---\n(.*?)\n---', txt, re.DOTALL)
        if fm:
            try:
                meta = yaml.safe_load(fm.group(1))
                if meta.get('tags') and 'concept' in str(meta.get('tags', '')):
                    src = str(meta.get('source', ''))
                    lec = re.search(r'\[\[(.+?)\]\]', src)
                    if lec: concept_sources[f[:-3]] = lec.group(1)
            except: pass
# Check each lecture's "Concepts introduced" section contains its declared concepts
for concept, lecture in concept_sources.items():
    lec_path = os.path.join(vault, 'Lectures', lecture + '.md')  # adjust path as needed
    if not os.path.exists(lec_path): continue
    lec_txt = open(lec_path).read()
    if f'[[{concept}]]' not in lec_txt:
        print(f'MISSING BACKLINK: {lecture} should list [[{concept}]]')
```

For every gap found: add `[[ConceptName]]` to the lecture's `## Concepts introduced` section.

**Quality report (all vault types):**
After the broken-link check, run a note quality sweep and print a structured report:

```text
Quality report — <vault name>
─────────────────────────────────────────
Total notes:          N
Missing definition:   N  (list first 5 filenames)
Missing example:      N
Missing flashcards:   N  (studies vaults only)
Missing wikilinks:    N  (notes with 0 outbound links)
Status breakdown:     new: N · review: N · mastered: N
Difficulty dist:      1: N · 2: N · 3: N · 4: N · 5: N
─────────────────────────────────────────
Action items:
  • N notes need a definition callout
  • N notes need at least one example
  • N notes have no outbound wikilinks (orphan risk)
```

Print this after the broken-link count in the final report. Do not skip even if all numbers are zero — the user needs confirmation the vault is clean.

Final report (English):

```text
Built vault: <path>
- Concept notes: N
- Lectures: N
- Labs: N
- Flashcards: N Q/A pairs
- Wikilinks total: N
- Broken links resolved: N
- Canvas: <built / skipped>
- Tables.md: <built / skipped>
- Flagged for follow-up: <list>
```
