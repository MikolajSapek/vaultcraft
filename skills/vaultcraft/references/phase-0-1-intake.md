# vaultcraft: phases 0 to 1.5 (mode detection, intake, budget)

## Workflow

When invoked, follow this pipeline. Announce each phase briefly to the user.

## Phase 0 - Mode Detection (CRITICAL - run as soon as a vault path is known)

Before committing to a plan, detect whether this is a fresh build or an incremental update. This decision shapes every subsequent phase.

**Order of operations:**

1. **If the user's initial prompt contains a vault path** (e.g., `Documents/ObsidianVaults/<Name>/`), run Phase 0 FIRST, then proceed to Phase 1 (reduced intake) only asking questions whose answers aren't already implied by vault state.
2. **If no vault path is in the initial prompt**, start Phase 1 and ask up to question #8 (vault path). As soon as you have the path, run Phase 0, then return to complete Phase 1.

**Detection commands (batch in one Bash call):**

```bash
VP="<vault>"
ls -la "$VP/.obsidian/" 2>/dev/null; \
  ls "$VP/Concepts/" "$VP/Lectures/" "$VP/Labs/" 2>/dev/null | head -20; \
  cat "$VP/.vault-progress.md" 2>/dev/null
```

**Three possible modes:**

| Mode | Trigger | Pipeline |
|---|---|---|
| **BOOTSTRAP** | `.obsidian/` missing, vault empty or doesn't exist | Phase 1 → 1.5 → 2 → 2.5 (bootstrap config) → 3 (propose structure) → 4 → 5 → 6 → 7 → 8 → 9 |
| **INCREMENTAL** | `.obsidian/` exists AND notes exist in standard folders | Phase 1 (reduced - ask only what's new) → 1.5 → 2 (extract new inputs only) → skip 2.5 & 3 → 4/5/8 (add/update) → 9 |
| **RESUME** | `.vault-progress.md` exists with `last_completed_phase` < 9 | Read progress file → announce "Resuming from <step>. Pending: <list>" → start from `next_action`, skip completed work |

**INCREMENTAL mode safety rules (non-negotiable):**

- Do NOT touch `.obsidian/` contents (preserves user's theme, plugins, graph filter).
- Do NOT touch `.obsidian/plugins/*/` (preserves Claudian, Spaced Repetition, etc.).
- Do NOT rename or delete existing notes.
- Do NOT overwrite existing content - APPEND new sections or create new notes.
- Announce explicitly: *"Detected existing vault with N notes. Running INCREMENTAL MODE - preserving all config and existing notes. I will only ADD new content."*

Announce the detected mode before proceeding to Phase 1.5.

## Phase 1 - Intake & Clarify

**ALWAYS ASK FIRST (CRITICAL):** Before touching any files, ask the user explicitly.

**HOW TO ASK - use the `AskUserQuestion` tool, not plain markdown text (CRITICAL).** The intake must surface as interactive option chips above the user's input field, not as a wall of markdown bullets they have to read and type back. Plain-text question lists are a regression - they make the user copy/retype answers and offer no preview of trade-offs. Use `AskUserQuestion` so each option appears as a clickable chip with a short description.

**Tool constraints to respect:**

- Max 4 questions per call · max 4 options per question · headers ≤12 chars
- Recommended option goes **first** with `(Recommended)` suffix in label
- `multiSelect: true` for questions where multiple answers make sense (e.g., explanation styles)
- Use the `preview` field on options when visual comparison helps the user (Format, Theme, Note format) - preview content renders as a markdown block on the right; use small Mermaid diagrams or sample callout snippets

**Batch sequence (always in this order):**

**Resume chip (Batch 0 - only if `.vault-progress.md` exists in detected vault path):**
Single question, header `Mode`, options: `Resume from last step (Recommended)` / `Start over fresh` / `Inspect progress first`. If user picks Resume, skip to the saved `next_action`. If Start over, archive the old vault first (move to `<vault>.archive-<YYYYMMDD>/`) before bootstrapping. If Inspect, print the progress file then re-ask.

**Batch A - Vault shape (always first, 4 questions, all single-select):**

1. `Vault type` - studies (Recommended) · work · research · personal *(reference and teaching go to "Other")*
2. `Format` - Detailed narrative (Recommended) · Study sheet · Golden template · Reference *(use `preview` field to show a 6-line sample of how each format renders - Detailed shows a paragraph-style intro, Study sheet shows a mini-box with bullets, Golden template shows the fixed section order with slide gallery + Key terms + Relations, Reference shows a code block)*
2b. `Templates` - asked only for `studies`/`teaching` vaults: "Use the golden templates for concept and lecture notes?" - options: `Yes - both (Recommended)` (lecture → `templates/lecture-golden.md`, concept → `templates/concept.md`, filled verbatim) · `Lecture only` · `Concept only` · `No - free format` (per Principle 16b)
3. `Depth` - standard (Recommended) · lean · thorough
4. `Language` - English (Recommended) · Polish · German · Spanish

**Batch B - Style preferences (3 questions):**

1. `Styles` (multiSelect: true) - pick the 4 most relevant explanation styles for the chosen vault type. Defaults by type: `studies` → ELI5 + Worked example + Historical + Real-world. `work` → Real-world + Counter-example + Worked example + Devil's advocate. `research` → Counter-example + Historical + Devil's advocate + Worked example. `personal` → ELI5 + Real-world + Historical + Visual metaphor.
2. `Flashcards` - None (Recommended) · Key concepts only · Every concept
3. `Urgency` - depends on vault type. For `studies`: <1 week · 1–4 weeks (Recommended) · 1–3 months · No rush. For `work`/`research`: weekly · monthly (Recommended) · quarterly · ongoing.

**Batch C - Free-text intake (markdown prompt, NOT chips):**
The remaining answers are open-ended and don't fit option chips. Ask as a single tight markdown block, numbered, one line per question:

```text
1. Course / project name?
2. Specific goal? (e.g., "exam 28 June", "onboarding doc by Q3")
3. Priority topics? (must-know vs nice-to-have, or "extract from materials")
4. Deadline / target date? (YYYY-MM-DD or "no rush")
5. Vault path? (default: ~/Documents/ObsidianVaults/<name>/)
6. Input sources? (file paths, folder paths, URLs)
```

**Batch D - Plan confirmation (after restating the plan in markdown):**
Single question, header `Confirm`, options: `Proceed (Recommended)` / `Adjust answers` / `Show estimated cost first`. Restate plan as a normal markdown block before this batch - don't put the plan inside the question text (UI doesn't render markdown in `AskUserQuestion` question fields well).

**Skip rules:**

- If user's initial prompt clearly states an answer (vault type, language, name, path, sources), skip that question.
- Never re-ask language if user already wrote in or specified a non-English preference.
- In INCREMENTAL mode (Phase 0 detected existing vault), skip Batches A and B entirely - read existing config from `.vault-progress.md` and only run Batch C for new sources.

**Error recovery chips (use during Phase 2 file ingestion):**
When PDF/PPTX parsing fails, show a chip question instead of dumping the error: header `File error`, options: `Skip this file` / `Retry with different parser` / `Paste text manually` / `Abort run`. Print the failing path and 1-line error reason in the question text. Same pattern for missing dependencies (LibreOffice not installed → chip: `Install hint` / `Skip PPTX files` / `Convert manually first`).

**Question content (what to ask in each batch):**

1. **What kind of vault is this?** - pick one. This is the most load-bearing answer; everything below adapts to it:
   - **`studies`** - academic course notes, exam prep. (Default if user mentions a course / exam / lecture.) Folder structure: `Lectures/`, `Concepts/`, `Labs/`, `Examples/`. Generates exam questions, `Tables.md`, oral-exam pitches.
   - **`work`** - professional knowledge base for a job, project, or domain. Folder structure: `Topics/`, `Concepts/`, `Playbooks/`, `Decisions/`, `People/` (orgs and stakeholders), `Meetings/`. No exam questions; Tables.md becomes a "decision matrix" instead. Tone: professional but plain.
   - **`personal`** - hobbies, life skills, curiosity-driven learning. Folder structure: `Topics/`, `Concepts/`, `Practice/` (skill drills), `Inspiration/`, `Journal/`. No exam questions; ELI5 default explanation style; flashcards optional.
   - **`research`** - paper / literature notes for academic or industry research. Folder structure: `Papers/`, `Concepts/`, `Methods/`, `Hypotheses/`, `Data/`, `Bibliography/`. Heavy on citations, BibTeX-compatible frontmatter. No exam questions; instead "open questions" sections.
   - **`reference`** - technical documentation reference, internal API docs, runbook collection. Folder structure: `Topics/`, `Concepts/`, `Procedures/`, `Troubleshooting/`. Heavy on copy-pasteable code, terse, no analogies needed.
   - **`teaching`** - preparing course materials TO teach. Folder structure: `Lessons/`, `Concepts/`, `Activities/`, `Assessments/`, `Resources/`. Each concept includes a "How to introduce this" section and a "Common student misconceptions" section.

   Default if user is ambiguous: `studies` (the original use case).

2. **Course name / project name / topic** - what should the agent call this in titles, MOC, and frontmatter?
3. **What's the goal?** - be specific about what the vault is FOR. Examples by vault type:
   - `studies` - written exam in 3 weeks, oral exam in 2 months, term paper, daily class reference, interview prep
   - `work` - onboarding a new hire, writing a system design doc, capturing tribal knowledge before someone leaves, runbook for an incident class
   - `personal` - learn watchmaking, prepare for a half-marathon, navigate divorce paperwork
   - `research` - literature review for a thesis chapter, replicate findings across N papers, prepare a survey paper
   - `reference` - onboarding doc for an API, troubleshooting playbook
   - `teaching` - prep a 12-lecture course, design a workshop curriculum, write a tutorial series
4. **Priority topics** - must-know vs. nice-to-have (scoping; affects depth allocation per topic).
5. **Output target / deadline** - exam date, project deadline, conference, presentation, or "no rush":
   - `studies` → exam date drives pacing suggestions in MOC
   - `work` → release / handoff date
   - `research` → submission deadline
6. **Format preference** - pick:
   - **Concise** (300-700w per major note) - scannable, mini-boxes
   - **Narrative** (1200-2500w) - story-style walkthrough - *default for `studies`, `teaching`*
   - **Reference** (terse, code-heavy, no narrative) - *default for `reference`, `work` runbooks*
7. **Depth setting** - `lean` / `standard` / `thorough`. Controls output length and token budget:
   - `lean` - atomic notes 150–300w, study sheets 300–500w. **~40% cheaper.**
   - `standard` - atomic 250–500w, study sheets 400–750w. **Default.**
   - `thorough` - atomic 400–700w, study sheets 600–900w. For term papers, deep references.
8. **Explanation style** - pick 1–3 (default: `eli5` + `worked-example` for math, just `worked-example` for `reference` vault):
   - **`eli5`** - analogy with everyday objects (toys, cooking, sports). Best for hard / abstract concepts. *Default for `studies`, `personal`, `teaching`.*
   - **`technical-analogy`** - analogy aimed at adults with technical background. No dumbing down. *"Attention is essentially key-value lookup, but where keys come from queries via softmax."*
   - **`historical`** - how the concept evolved, who invented it, what problem motivated it. Adds memorability via story.
   - **`counter-example`** - when does this concept FAIL? what's its limit? Useful for `reference` and `research` vaults where edge cases matter.
   - **`visual-metaphor`** - describe what it would look like as a diagram, chart, or shape. Followed by an actual Mermaid block where possible.
   - **`real-world-application`** - concrete industry / daily-life use case. *"PCA is what Spotify uses to compress 10K-feature listening histories into 2D visualizations."* - *Default for `work`, `reference`.*
   - **`devils-advocate`** - argue against the concept; show where it's overhyped or insufficient. Builds critical thinking; great for `research` and `teaching`.
   - **`worked-example`** - concrete numerical computation with real values. Always recommended for math / formulas; Principle 3 makes it mandatory for them anyway.

   The agent picks the chosen styles' callouts and adds them after "When to use vs avoid", before Flashcards.

9. **Vault path?** - suggest `~/Documents/ObsidianVaults/<topic-name>/` if no preference.
10. **Input sources?** - paths to PDFs, PPTX, .py, .ipynb, .md, web URLs, or pasted text.
11. **Language?** - pick one. **Default: English**.
    - **English** (Recommended) - portable, search-friendly, lingua franca for technical content
    - **Polish** - pełne notatki, nagłówki, callouty, fiszki po polsku
    - **German** - Notizen, Überschriften, Karteikarten auf Deutsch
    - **Spanish** - notas, encabezados, tarjetas en español
    - **Other** - French, Italian, Portuguese, etc. - user types language name; agent uses it for prose, keeps code identifiers in English

    Code identifiers, code comments, and library names always stay in English regardless of vault language. Wikilink targets stay in the chosen vault language (e.g., `[[Cross-Entropie]]` in a German vault, `[[Entropía Cruzada]]` in Spanish).

Minimum answers required before proceeding: 1 (vault type), 2 (name), 3 (goal), 4 (priorities), 8 (explanation styles), 9 (path), 10 (sources). For `studies` type, also require 5 (deadline).

**Exception:** If the user provided answers in their initial prompt, skip asking those. Always ask vault type if it's not crystal clear.

**After getting answers, restate the plan back, including the chosen vault type:**
> "Got it: a `<type>` vault called *<name>*, goal: <goal>. Priority topics: <topics>. Format: <format> · depth: <depth> · explanation styles: <styles>. Building at <path> from <sources>. Language: <lang>. Starting now?"

Wait for confirmation before Phase 2.

## Phase 1.5 - Budget Plan & Progress File

Before Phase 2, do a rough budget estimate and initialize progress tracking. You have `maxTurns=150` turns per run; each concept note costs ~1 Read + 1 Write = 2 uses, each lecture ~3 uses (read slides + verify concepts + write), each lab ~2 uses.

```text
budget_total = 150  (maxTurns per run)
reserved_for_audit = 10
budget_work = 140
```

If inventory has N concepts + L lectures + labs, estimate:

```text
estimated_uses = (N × 2) + (L × 3) + (labs × 2) + 10 (MOC/Tables/QA)
```

If `estimated_uses > budget_work`, you WILL run out mid-pass. Options:

- (a) Split into multiple runs: do lectures+concepts first, labs+Tables in next run.
- (b) Reduce depth per note (shorter lecture format, fewer flashcards).
- (c) Warn the user upfront and ask whether to split.

**Write `.vault-progress.md` at vault root** after every major milestone (after Phase 4, after Phase 5, after Phase 8) with this schema:

```markdown
# Vault Progress - <YYYY-MM-DD HH:MM>

## Status
- **mode:** bootstrap | incremental | resume
- **depth:** lean | standard | thorough
- **last_completed_phase:** 4
- **next_action:** "Run Phase 5 - create lecture notes for L01-L10"

## Completed
- [x] Phase 0 - mode detection (incremental)
- [x] Phase 1 - intake
- [x] Phase 4 - 117 concept notes
- [ ] Phase 5 - lecture notes (0/10)

## Pending
- Lectures L01-L10 (sources: session1.pdf..session10.pptx)
- Labs Lab01-Lab09
- Tables.md
- Phase 8 MOC + Base dashboard
- Phase 9 quality pass

## Source hashes (skip re-reading on resume if match)
- session1.pdf: sha256:abc123...
- session2.pptx: sha256:def456...
- (generate via: `shasum -a 256 <file>` on macOS / `sha256sum` on Linux)

## Inventory count
- Concepts created: 117
- Named sub-techniques unpacked: 47
- Broken wikilinks at last audit: 0
```

**On resume/incremental**: hash each input source at start, compare to stored hashes. If a source's hash matches the stored one, its inventory is already complete - skip the re-read. This alone can cut tokens by 40–60% on follow-up runs.

On completion or on hitting budget limit, UPDATE this file before your final message. The final message MUST include a "Resume instructions" section the user can paste into a new agent invocation.
