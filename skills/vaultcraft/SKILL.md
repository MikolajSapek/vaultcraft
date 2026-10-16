---
name: vaultcraft
description: "Turn scattered materials (lecture slides, lab scripts, project docs, meeting notes, research papers) into a richly visual, linked Obsidian knowledge vault. Use when the user wants to build, bootstrap, or extend an Obsidian study, work or research vault from raw inputs. Trigger on '/vaultcraft', 'build a vault', 'vaultcraft', or 'make an Obsidian vault from my materials'."
---

# vaultcraft

This skill turns course, work or research materials into a linked Obsidian vault.
It runs the same way in Claude Code, Cowork, claude.ai, ChatGPT and Codex: this file
owns the conversation (banner, intake, confirm), and the files in `references/` hold
the generation pipeline (parsing, note-writing, linking, audit).

Paths in this skill (`references/...`, `templates/...`) are relative to the folder
that holds this `SKILL.md`. Call that folder `SKILL_DIR`.

Do these steps in order. Do not skip the banner or the intake.

## Step 1 — Print the banner (always, first thing)

Print this exactly, inside a fenced code block, before anything else:

```text
██╗   ██╗ █████╗ ██╗   ██╗██╗  ████████╗ ██████╗██████╗  █████╗ ███████╗████████╗
██║   ██║██╔══██╗██║   ██║██║  ╚══██╔══╝██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
██║   ██║███████║██║   ██║██║     ██║   ██║     ██████╔╝███████║█████╗     ██║
╚██╗ ██╔╝██╔══██║██║   ██║██║     ██║   ██║     ██╔══██╗██╔══██║██╔══╝     ██║
 ╚████╔╝ ██║  ██║╚██████╔╝███████╗██║   ╚██████╗██║  ██║██║  ██║██║        ██║
  ╚═══╝  ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝    ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝
           ⛏  an obsidian vault builder — study · work · research  ⛏
```

Then one status line, e.g. `→ Bootstrap mode. Starting intake.`

## Step 2 — Quick mode detection

If the user's prompt names a vault path you can read, glob it: `.obsidian/` present +
notes in standard folders → **INCREMENTAL** (only ask what's new). `.vault-progress.md`
present → offer **Resume** (Resume / Start over / Inspect). Otherwise → **BOOTSTRAP**
(full intake). Announce the detected mode.

## Step 3 — Intake

Skip any question the user's prompt already answered. If your host has an interactive
question tool (`AskUserQuestion` in Claude Code and Cowork), use it: ≤4 questions and
≤4 options per call, headers ≤12 chars, Recommended option first with `(Recommended)`,
`multiSelect: true` where multiple answers fit, `preview` for Format/Style. If it has
none (claude.ai chat, ChatGPT, Codex), send Batches A and B as ONE numbered plain-text
list with the options and the recommended default on each line, and tell the user they
can reply "defaults" to accept every recommendation.

**Batch A — Vault shape** (4 single-select):

1. `Vault type` — studies (Recommended) · work · research · personal *(reference/teaching → Other)*
2. `Format` — Detailed narrative (Recommended) · Study sheet · Golden template · Reference *(preview a 6-line sample of each)*
3. `Depth` — standard (Recommended) · lean · thorough
4. `Language` — English (Recommended) · Polish · German · Spanish

For `studies`/`teaching`, add a follow-up `Templates` — Yes both (Recommended) · Lecture only · Concept only · No free format.

**Batch B — Style** (3 questions):

1. `Styles` (multiSelect) — defaults by type: studies → ELI5 + Worked example + Historical + Real-world; work → Real-world + Counter-example + Worked example + Devil's advocate; research → Counter-example + Historical + Devil's advocate + Worked example; personal → ELI5 + Real-world + Historical + Visual metaphor.
2. `Flashcards` — None (Recommended) · Key concepts only · Every concept
3. `Urgency` — studies: <1 week · 1–4 weeks (Recommended) · 1–3 months · No rush; work/research: weekly · monthly (Recommended) · quarterly · ongoing.

**Batch C — Free-text** (plain markdown block, never option chips):

```text
1. Course / project name?
2. Specific goal? (e.g. "exam 28 June", "onboarding doc by Q3")
3. Priority topics? (must-know vs nice-to-have, or "extract from materials")
4. Deadline / target date? (YYYY-MM-DD or "no rush")
5. Vault path? (default: ~/Documents/ObsidianVaults/<name>/)
6. Input sources? (file paths, folder paths, URLs, or files attached to this chat)
```

Ask question 5 only when you can write to the user's own disk (see Step 5).
INCREMENTAL mode: skip Batches A and B, run only Batch C for new sources.

## Step 4 — Restate the plan, then confirm

Restate the locked answers as a short markdown block (type, format, depth, language,
styles, flashcards, name, path, sources, mode). Then ask one confirm question:
Proceed (Recommended) · Adjust answers · Show estimated cost first.

## Step 5 — Generate

### 5a. Claude Code or Cowork with the vaultcraft agent: delegate

If your Agent tool lists a `vaultcraft` agent (`vaultcraft` or, from the plugin,
`vaultcraft:vaultcraft`), dispatch it with a prompt that starts with this exact marker
so it skips its own banner and intake. Fill in every line; the agent needs `SKILL_DIR`
to find the note templates:

```text
VAULTCRAFT_HANDOFF: intake complete, banner already shown — do NOT reprint the banner,
do NOT run Phase 1 AskUserQuestion. Start at Phase 0 with these LOCKED PARAMETERS:
- SKILL_DIR: <absolute path of the folder holding this SKILL.md>
- vault_type: <…>
- format: <…>          (and templates: <…> if studies/teaching)
- depth: <…>
- language: <…>
- styles: <…>
- flashcards: <…>
- urgency: <…>
- name: <…>
- goal: <…>
- priority_topics: <…>
- deadline: <…>
- vault_path: <…>
- sources: <…>
- mode: BOOTSTRAP | INCREMENTAL | RESUME
Run the full phase pipeline and write the vault. Print status footers as specified.
```

Relay the agent's final report. If it returns with a question it cannot decide (e.g. a
file fails to parse), ask the user and re-dispatch.

### 5b. Everywhere else: run the pipeline yourself

No vaultcraft agent listed (claude.ai chat, ChatGPT, Codex, or Claude Code with the
skill alone): run the pipeline in this conversation.

1. Read `references/principles.md` and `references/operations.md` now.
2. Start at Phase 0 with the locked answers from Step 4. Skip Phase 1, which Steps 3
   and 4 already did. Read each `references/phase-*.md` file when you reach that phase:
   `phase-0-1-intake.md`, `phase-2-3-extract.md`, `phase-4-notes.md`,
   `phase-5-lectures.md`, `phase-6-9-finish.md`.
3. Apply the substitutions below wherever those files name a tool you do not have.

| The references say | If you don't have it, do this instead |
|---|---|
| `Task` sub-agents, haiku/sonnet/opus delegation | Write those notes yourself, in order. Keep the same templates and quality bar. |
| `Skill` (obsidian-markdown, json-canvas, docs, …) | Use the syntax rules already in the references and your own knowledge. |
| `AskUserQuestion` | Ask in plain text, as in Step 3. |
| `Bash` + `pdfimages` / `brew install poppler` | Use the code tool's Python (`pypdf`, `pymupdf`/`fitz`, `pdfplumber`, whichever imports). Never install system packages without asking. If figures can't be extracted, embed the source PDF and say so. |
| `WebSearch` / `WebFetch` | Use your host's web tool. If there is none, skip web supplements and mark gaps with `> [!warning] Needs verification`. |
| The user's vault path on disk | See "Where the vault goes" below. |

Print the status footer after each phase, as `references/principles.md` specifies,
with the name of the model you actually are (not the Claude tiers in its examples).

### Where the vault goes

- **You can write to the user's disk** (Claude Code, Cowork with a folder, Codex): write
  to the vault path from Batch C.
- **You run in a sandbox** (claude.ai chat, ChatGPT): build the vault in a working
  folder named after the course, then zip it as `<name>-vault.zip` and give the user
  the file. Tell them: unzip it, then in Obsidian choose **Open folder as vault** and
  pick the unzipped folder. Keep the run inside the sandbox's limits: if the materials
  are large, say how many lectures fit in this run and offer to continue in the next
  message using the zip they upload back (RESUME mode reads `.vault-progress.md`).
