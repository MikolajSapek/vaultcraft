# vaultcraft: phases 2 to 3 (extract, configure, structure)

## Phase 2 - Extract & Index

For each input:

- **PDFs** - use `Read` (handles PDFs directly; for large PDFs use the `pages` parameter). Then run figure extraction (see below).
- **PPTX** - convert via `soffice --headless --convert-to pdf <file.pptx> --outdir /tmp/`, then Read the resulting PDF.
- **Python files** - read in full; extract imports (library inventory), function signatures, class definitions, key logic blocks.
- **Jupyter notebooks** - `Read` handles `.ipynb` natively; treat markdown cells as lecture notes, code cells as examples, outputs as verification.
- **Web supplements** - when a concept is under-explained in the source, use `WebSearch` + `WebFetch` (preferentially Wikipedia, official docs, university lecture notes). Always cite in the note.

**Figure extraction from PDFs (CRITICAL for visual notes):**

Run for every PDF that contains diagrams, charts, screenshots, or figures. Skip for text-only PDFs (e.g., pure equation sheets).

```bash
# 1. Check if poppler is installed (provides pdfimages)
which pdfimages || echo "poppler missing: ask the user before running brew install poppler"

# 2. Extract all embedded images from the PDF
# -png: output as PNG, -p: prefix filenames with page number
pdfimages -png -p "<source.pdf>" /tmp/fig-extract

# 3. Inspect what was extracted (reject very small images - likely icons/bullets)
ls -lh /tmp/fig-extract-*.png | awk '$5 > 20k'
```

After extraction:

1. **Read each image** with the `Read` tool (visual inspection) to identify what it depicts.
2. **Assign descriptive names** following vault convention: `{COURSE}-L{N}-fig{PAGE}-{description}.png`
   - e.g., `ML-L08-fig12-relu-vs-sigmoid.png`, `TEAM-meeting-2026-06-10-fig3-stakeholder-map.png`
3. **Copy named figures to `<vault>/Assets/`** (or `<vault>/<Course>/Assets/` for multi-course vaults).
4. **Embed inline** at the relevant section of the note: `![[ML-L08-fig12-relu-vs-sigmoid.png|600]]`
5. Skip images smaller than ~20KB (decorative bullets, icons, borders).

Naming convention for non-study vaults:

- Work/meeting PDFs: `{PROJECT}-{YYYYMMDD}-fig{N}-{description}.png`
- Research papers: `{FirstAuthor}{Year}-fig{N}-{description}.png`
- Reports: `{REPORT-SLUG}-fig{N}-{description}.png`

Build an in-memory **concept inventory**: every distinct concept mentioned, with its source(s) and first-mention context. Deduplicate synonyms.

**Inventory depth check (mandatory before Phase 4):**

Go through every slide a second time with this explicit question: *"What specific named techniques, algorithms, variants, methods, or sub-concepts are mentioned here, even in a parenthetical or a comparison table?"* Each one becomes a separate entry.

Examples of what you MUST unpack, not collapse:

- "Smoothing" → Laplace/Add-one, Add-k, Good-Turing, Kneser-Ney, Interpolation, Backoff (6 notes)
- "Tokenization" → Whitespace, WordPiece, BPE, SentencePiece, Unigram LM (5 + overview)
- "Regularization" → L1, L2, Elastic Net, Dropout, Early Stopping, Weight decay (6 + overview)
- "Optimizers" → SGD, Momentum, Nesterov, Adagrad, RMSProp, Adam, AdamW (7 + overview)
- "Attention" → Scaled dot-product, Additive/Bahdanau, Multi-head, Self, Cross, Masked (6)
- "Evaluation metrics" → Accuracy, Precision, Recall, F1, ROC-AUC, BLEU, ROUGE, Perplexity - each its own note
- "Loss functions" → MSE, MAE, Cross-entropy, Hinge, KL divergence - each its own note

If a slide has a bullet like "Common approaches: A, B, C", that is **three notes**, not one. If a slide has a comparison table with 4 rows, that is **at least 4 notes** (plus one overview hub). Over-split is fine - under-split is the failure mode.

Before proceeding to Phase 4, produce the count: "Inventory: N concepts across M slides. Of those, K are named sub-techniques that would have been missed by surface extraction." If K is 0, you are almost certainly under-extracting - re-scan.

## Phase 2.5 - Bootstrap Vault Configuration

Before generating notes, configure `.obsidian/` so the vault looks polished from day one.

**`.obsidian/app.json`:**

```json
{
  "alwaysUpdateLinks": true,
  "newLinkFormat": "shortest",
  "useMarkdownLinks": false,
  "attachmentFolderPath": "Assets",
  "showLineNumber": true,
  "readableLineLength": true,
  "livePreview": true,
  "defaultViewMode": "preview",
  "spellcheck": true,
  "spellcheckLanguages": ["en-US"]
}
```

**`.obsidian/appearance.json`:**

```json
{
  "baseFontSize": 16,
  "theme": "obsidian",
  "enabledCssSnippets": ["callouts", "concept-cards"]
}
```

**`.obsidian/core-plugins.json`** - enable: `file-explorer`, `global-search`, `switcher`, `graph`, `backlink`, `outgoing-link`, `tag-pane`, `properties`, `page-preview` *(critical - powers hover previews)*, `templates`, `note-composer`, `command-palette`, `editor-status`, `starred`, `outline`, `word-count`, `random-note`, `bookmarks`, `canvas`, `bases`.

**`.obsidian/page-preview.json`:**

```json
{"internalLinkOverride": true, "pageLinkOverride": true, "imageIndicator": true}
```

**`.obsidian/graph.json`** - path-based color groups, hide tag nodes and unresolved links. Colors differ by vault type:

For **`studies`** vaults:

```json
{
  "collapse-filter": false,
  "search": "-file:\"00 - Start Here\" -file:\"README_PLUGINS\" -file:\"01 - Course Map\" -file:\"Tables\"",
  "showTags": false,
  "showAttachments": false,
  "hideUnresolved": true,
  "showOrphans": true,
  "colorGroups": [
    {"query": "path:Lectures/", "color": {"a": 1, "rgb": 15778400}},
    {"query": "path:Labs/",     "color": {"a": 1, "rgb": 15913728}},
    {"query": "path:Concepts/", "color": {"a": 1, "rgb": 5793266}},
    {"query": "path:Formulas/", "color": {"a": 1, "rgb": 14914867}},
    {"query": "path:Examples/", "color": {"a": 1, "rgb": 4170580}}
  ],
  "showArrow": true,
  "nodeSizeMultiplier": 1.5,
  "lineSizeMultiplier": 1.2
}
```

For **`work`** vaults:

```json
{
  "collapse-filter": false,
  "search": "-file:\"00 - Start Here\" -file:\"README_PLUGINS\"",
  "showTags": false,
  "showAttachments": false,
  "hideUnresolved": true,
  "showOrphans": true,
  "colorGroups": [
    {"query": "path:Meetings/",  "color": {"a": 1, "rgb": 5793266}},
    {"query": "path:Projects/",  "color": {"a": 1, "rgb": 15778400}},
    {"query": "path:Companies/", "color": {"a": 1, "rgb": 14914867}},
    {"query": "path:People/",    "color": {"a": 1, "rgb": 4170580}},
    {"query": "path:Decisions/", "color": {"a": 1, "rgb": 15913728}},
    {"query": "path:Concepts/",  "color": {"a": 1, "rgb": 8978687}}
  ],
  "showArrow": true,
  "nodeSizeMultiplier": 1.5,
  "lineSizeMultiplier": 1.2
}
```

For **`research`** vaults:

```json
{
  "colorGroups": [
    {"query": "path:Papers/",      "color": {"a": 1, "rgb": 15778400}},
    {"query": "path:Concepts/",    "color": {"a": 1, "rgb": 5793266}},
    {"query": "path:Methods/",     "color": {"a": 1, "rgb": 14914867}},
    {"query": "path:Hypotheses/",  "color": {"a": 1, "rgb": 15913728}},
    {"query": "path:Data/",        "color": {"a": 1, "rgb": 4170580}}
  ],
  "showTags": false, "showAttachments": false, "hideUnresolved": true, "showOrphans": true,
  "showArrow": true, "nodeSizeMultiplier": 1.5, "lineSizeMultiplier": 1.2
}
```

The default `search` filter excludes navigation/index files from graph view so only semantic nodes appear.

**Why path-based, not tag-based:** tag queries create extra orphan nodes when `showTags: true`; path queries color the note itself. Folder-path filtering (`file.inFolder("Concepts")`) also matches the Base/Dataview convention.

**CSS snippets** (`.obsidian/snippets/`):

`callouts.css` - colored, icon-prefixed callouts. Write the appropriate block for the vault type:

For **`studies`** vaults:

```css
.callout[data-callout="definition"] {
    --callout-color: 56, 139, 253;
    --callout-icon: "book-open";
}
.callout[data-callout="definition"] .callout-title {
    font-weight: 700;
    font-size: 1.05em;
}
.callout[data-callout="example"]  { --callout-color: 46, 160, 67;  --callout-icon: "lightbulb"; }
.callout[data-callout="question"] { --callout-color: 163, 113, 247; --callout-icon: "help-circle"; }
.callout[data-callout="important"]{ --callout-color: 248, 81, 73;  --callout-icon: "alert-triangle"; }
.callout[data-callout="exam"]     { --callout-color: 210, 153, 34;  --callout-icon: "graduation-cap"; }
```

For **`work`** vaults:

```css
.callout[data-callout="decision"] { --callout-color: 31, 111, 235;  --callout-icon: "check-square"; }
.callout[data-callout="action"]   { --callout-color: 234, 139, 0;   --callout-icon: "zap"; }
.callout[data-callout="risk"]     { --callout-color: 248, 81, 73;   --callout-icon: "alert-triangle"; }
.callout[data-callout="meeting"]  { --callout-color: 20, 184, 166;  --callout-icon: "users"; }
.callout[data-callout="stakeholder"] { --callout-color: 139, 92, 246; --callout-icon: "user"; }
.callout[data-callout="tldr"]     { --callout-color: 100, 116, 139; --callout-icon: "align-left"; }
```

`concept-cards.css` - concept notes look like study cards (H1 accent border, H2 left-border, rounded code blocks).

**Community plugins** - create `<vault_path>/README_PLUGINS.md` (absolute path) with install instructions (do NOT auto-install). List differs by vault type:

For **`studies`** vaults:

1. **Spaced Repetition** (`st3v3nmw/obsidian-spaced-repetition`) - `::` flashcards. Critical.
2. **Dataview** - dynamic study dashboards.
3. **Excalidraw** - hand-drawn sketches (optional).
4. **Advanced Tables** - table UX (optional).
5. **Templater** - dynamic templates (optional).

For **`work`** vaults:

1. **Kanban** (`mgmeyers/obsidian-kanban`) - task board. Critical for work vaults.
2. **Calendar** (`liamcain/obsidian-calendar-plugin`) - daily/weekly note navigation, meeting log by date.
3. **Dataview** - dynamic dashboards (active projects, open actions).
4. **Advanced Tables** - table UX (optional).
5. **Templater** - auto-fill meeting/decision templates with current date.

**Work vault: Kanban board (`00 - Dashboard.md`):**

Generate this file on bootstrap for all `work` vaults. It uses the obsidian-kanban plugin syntax:

````markdown
---
kanban-plugin: board
---

## 🔴 Blocked

- [ ] <drag cards here>

## 🟡 In progress

- [ ] [[<Project or task>]]

## 🟢 Done

- [ ] [[<Completed item>]]

%% kanban:settings
```

{"kanban-plugin":"board","list-collapse":[false,false,false]}

```
%%
````

Below the Kanban board, add a static section with Dataview queries (requires Dataview plugin):

````markdown
---

## Active projects

```dataview
TABLE status, deadline, owner FROM "Projects" WHERE status = "active" SORT deadline ASC
```

## Meetings this week

```dataview
LIST FROM "Meetings" WHERE date >= date(today) - dur(7d) SORT date DESC LIMIT 10
```

## Open actions

```dataview
TASK FROM "Meetings" WHERE !completed SORT file.mtime DESC
```

````

After generating the dashboard, tell the user: *"Dashboard created. Open Obsidian and enable the Kanban plugin (Settings → Community plugins) to activate the board view."*

After writing config files, tell the user (English):
> "Vault configured. To activate everything: open Obsidian, enable Community Plugins (Settings → Community plugins → Turn on), and install the plugins listed in `README_PLUGINS.md` (~2 min)."

## Phase 3 - Plan the Vault Structure

Default structure by vault type:

**`studies` vault:**

```text

<VaultRoot>/
├── 00 - Start Here.md            ← entry MOC
├── 01 - Course Map.canvas        ← optional visual map (low priority)
├── 02 - Study Dashboard.base     ← optional Base dashboard
├── Tables.md                      ← comparison tables for oral exam
├── README_PLUGINS.md              ← plugin install guide
├── Concepts/                      ← atomic notes (one per concept)
├── Lectures/                      ← per-lecture summary notes
├── Labs/                          ← lab writeups with embedded Python
├── Examples/                      ← longer worked examples (optional)
├── Formulas/                      ← formula cheat sheets (optional)
├── Assets/                        ← images, diagrams, embedded PDFs
└──_Templates/                    ← note templates

```

**`work` vault:**

```text

<VaultRoot>/
├── 00 - Dashboard.md              ← Kanban board + active project links
├── README_PLUGINS.md
├── Projects/                      ← one note per project/initiative
├── Meetings/                      ← meeting notes (YYYY-MM-DD format)
├── Stakeholders/                  ← person and company profiles
│   ├── People/                    ← individual contacts
│   └── Companies/                 ← organisation profiles
├── Decisions/                     ← decision log
├── Concepts/                      ← domain knowledge notes
├── Documents/                     ← embedded PDFs, reports, contracts
│   └── <person-or-project>/       ← subfolder per stakeholder or project
└── Assets/                        ← extracted figures, logos, diagrams

```

Generate `Stakeholders/People/` and `Stakeholders/Companies/` folders on bootstrap. Ask the user in Phase 1 Batch C: *"List your key stakeholders (names / companies) — I'll create their profiles now so you can link to them from meetings and decisions."* Create a stub profile for each one provided.

Present the proposed structure only if it deviates substantially (e.g., math-heavy courses get a `Proofs/` folder).
