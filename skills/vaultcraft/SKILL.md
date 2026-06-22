---
name: vaultcraft
description: "Turn scattered materials (lecture slides, lab scripts, project docs, meeting notes, research papers) into a richly visual, linked Obsidian knowledge vault. Use when the user wants to build, bootstrap, or extend an Obsidian study/work/research vault from raw inputs. Trigger on '/vaultcraft', 'build a vault', 'vaultcraft', or 'make an Obsidian vault from <materials>'. This skill runs the banner + interactive intake in the main loop, then delegates heavy generation to the vaultcraft agent."
---

# vaultcraft (front-end)

This skill is the **interactive front-end** for vaultcraft. It exists because the
banner and the `AskUserQuestion` intake only work in the main conversation loop —
a subagent cannot print a visible banner or ask the user interactive chips. So the
skill owns the *conversation* (banner → intake → confirm) and the `vaultcraft`
**agent** owns the *generation* (parsing, note-writing, linking, audit).

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

If the user's prompt names a vault path, glob it: `.obsidian/` present + notes in
standard folders → **INCREMENTAL** (only ask what's new). `.vault-progress.md`
present → offer a **Resume** chip (Resume / Start over / Inspect). Otherwise →
**BOOTSTRAP** (full intake). Announce the detected mode.

## Step 3 — Intake via `AskUserQuestion` (NOT plain markdown)

Skip any question the user's prompt already answered. Constraints: ≤4 questions and
≤4 options per call, headers ≤12 chars, Recommended option first with `(Recommended)`,
`multiSelect: true` where multiple answers fit, use `preview` for Format/Style.

**Batch A — Vault shape** (single call, 4 single-select):
1. `Vault type` — studies (Recommended) · work · research · personal *(reference/teaching → Other)*
2. `Format` — Detailed narrative (Recommended) · Study sheet · Golden template · Reference *(preview a 6-line sample of each)*
3. `Depth` — standard (Recommended) · lean · thorough
4. `Language` — English (Recommended) · Polish · German · Spanish

For `studies`/`teaching`, add a follow-up call `Templates` — Yes both (Recommended) · Lecture only · Concept only · No free format.

**Batch B — Style** (single call, 3 questions):
1. `Styles` (multiSelect) — defaults by type: studies → ELI5 + Worked example + Historical + Real-world; work → Real-world + Counter-example + Worked example + Devil's advocate; research → Counter-example + Historical + Devil's advocate + Worked example; personal → ELI5 + Real-world + Historical + Visual metaphor.
2. `Flashcards` — Every concept (Recommended) · Key only · None
3. `Urgency` — studies: <1 week · 1–4 weeks (Recommended) · 1–3 months · No rush; work/research: weekly · monthly (Recommended) · quarterly · ongoing.

**Batch C — Free-text** (plain markdown block, NOT chips — these don't fit options):
```text
1. Course / project name?
2. Specific goal? (e.g. "exam 28 June", "onboarding doc by Q3")
3. Priority topics? (must-know vs nice-to-have, or "extract from materials")
4. Deadline / target date? (YYYY-MM-DD or "no rush")
5. Vault path? (default: ~/Documents/ObsidianVaults/<name>/)
6. Input sources? (file paths, folder paths, URLs)
```

INCREMENTAL mode: skip Batches A and B, run only Batch C for new sources.

## Step 4 — Restate the plan, then confirm

Restate the locked answers as a short markdown block (type, format, depth, language,
styles, flashcards, name, path, sources, mode). Then one `AskUserQuestion`, header
`Confirm`: Proceed (Recommended) · Adjust answers · Show estimated cost first.

## Step 5 — Delegate generation to the `vaultcraft` agent

On Proceed, dispatch the `vaultcraft` agent (Task tool, `subagent_type: vaultcraft`)
with a prompt that starts with this exact marker so the agent skips its own banner
and intake:

```text
VAULTCRAFT_HANDOFF: intake complete, banner already shown — do NOT reprint the banner,
do NOT run Phase 1 AskUserQuestion. Start at Phase 0 with these LOCKED PARAMETERS:
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

Relay the agent's final report back to the user. If the agent needs a mid-run
decision it cannot make (e.g. a file fails to parse), it returns and asks you — then
you surface that choice to the user via `AskUserQuestion` and re-dispatch.
