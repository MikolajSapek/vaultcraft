# Usage

## The mental model

The agent has three modes (auto-detected):

| Mode | When | What runs |
|---|---|---|
| **Bootstrap** | Empty vault folder | Full pipeline: config + structure + extraction + generation + audit |
| **Incremental** | Existing vault with notes | Add new content only; preserves `.obsidian/` config and existing notes |
| **Resume** | `.vault-progress.md` exists with incomplete state | Pick up from `next_action` |

You don't choose the mode — the agent detects it from the vault state.

## Phase 1 — Intake questions

Before building anything, the agent asks 11 questions. The first — **vault type** — is the most load-bearing; everything below adapts to the answer.

1. **Vault type** — pick one:
   - `studies` (default) — academic course notes, exam prep
   - `work` — professional knowledge base, projects, runbooks
   - `personal` — hobbies, life skills, curiosity-driven learning
   - `research` — paper / literature notes
   - `reference` — technical documentation, APIs, runbooks
   - `teaching` — preparing course materials TO teach others

   See [`vault-types.md`](vault-types.md) for the full breakdown of how each type changes folder structure and defaults.

2. **Name** — course / project / topic. Used in titles, MOC, and frontmatter.
3. **Goal** — what the vault is FOR. Examples by type:
   - `studies` — written exam in 3 weeks · oral exam · term paper · daily reference
   - `work` — onboarding · system design doc · runbook · capturing tribal knowledge
   - `personal` — learn watchmaking · prepare for half-marathon
   - `research` — literature review · replicate findings · prepare survey paper
   - `reference` — onboarding doc for an API · troubleshooting playbook
   - `teaching` — prep a 12-lecture course · design a workshop curriculum
4. **Priority topics** — must-know vs nice-to-have (scoping; affects depth allocation per topic).
5. **Output target / deadline** — exam date, project deadline, conference, "no rush". Required for `studies`.
6. **Format preference**:
   - **Concise** — 300–700 words per major note, scannable, mini-boxes
   - **Narrative** — 1,200–2,500 words, story-style. *Default for `studies`, `teaching`.*
   - **Reference** — terse, code-heavy, no narrative. *Default for `reference`, `work` runbooks.*
7. **Depth setting** — `lean` (~40% cheaper) / `standard` (default) / `thorough` (term papers, deep references).
8. **Explanation styles** — pick 1–3 (default depends on vault type):
   - `eli5` — analogy with everyday objects. *Default for `studies`, `personal`, `teaching`.*
   - `technical-analogy` — analogy aimed at technical adults
   - `historical` — origin story, evolution
   - `counter-example` — when the concept fails. *Default for `research`, `reference`.*
   - `visual-metaphor` — describe as a shape/diagram (with Mermaid)
   - `real-world-application` — concrete industry use case. *Default for `work`, `reference`.*
   - `devils-advocate` — argument against the concept
   - `worked-example` — numerical computation (always for math, mandatory)
9. **Vault path** — where to build it.
10. **Input sources** — paths to PDFs, PPTX, .py, .ipynb, .md, web URLs, or pasted text.
11. **Language** — English (default) / Polish / mixed. Conversation can match the user's language; artefacts written to disk are always English unless explicitly told otherwise.

Answer those, the agent restates the plan and waits for your confirmation. Then it runs.

## Example invocations

### Fresh vault — single course

```
> Build me an Obsidian vault for my NLP course. Slides are at
> ~/Downloads/nlp-slides/ (12 PDFs, sessions 1-12), labs at
> ~/Downloads/nlp-labs/ (9 Jupyter notebooks). Vault path:
> ~/Documents/ObsidianVaults/NLP-2026/. Oral exam in 3 weeks.
> Detailed lecture notes, standard depth, English.
```

The agent will skip Phase 1 questions where you've already given answers.

### Adding a single new lecture (incremental mode)

```
> I just had Lecture 11 today. Slides: ~/Downloads/lecture-11.pdf.
> Add it to my existing vault at ~/Documents/ObsidianVaults/NLP-2026/.
```

Agent detects the existing `.obsidian/` and existing notes → runs incremental mode → adds only L11 + any new concept stubs it references → updates MOC.

### Multi-course vault

```
> I want a single vault for all 4 of my courses (NLP, ML, Stats, Strategy).
> Build it at ~/Documents/ObsidianVaults/Spring-2026/ with each course
> as a subfolder. Sources are in ~/Downloads/<course-name>/.
```

The agent will create folder-per-course structure with cross-course bridge notes in `_Shared/Concepts/`.

### Lean mode — quick reference vault

```
> Build a lean reference vault for my ML course. I just need short concept
> notes I can scan during open-book exams. Source: ~/Downloads/ml/.
> Vault: ~/Documents/ObsidianVaults/ML-quick/.
```

Atomic notes 150–300 words, study sheets 300–500 words. ~40% fewer tokens.

### Adding sources later

```
> Add this paper to my vault as a Reading: ~/Downloads/Vaswani2017.pdf.
> Vault: ~/Documents/ObsidianVaults/NLP-2026/. Note its key concepts
> and link them to existing concept notes where possible.
```

## What the agent produces

After a typical run on 12 lectures + 9 labs you get:

```
my-course-2026/
├── .obsidian/                          ← graph colours, hotkeys, snippets
├── 00 — Start Here.md                  ← entry MOC
├── Tables.md                            ← oral-exam comparison tables
├── 01 — Course Map.canvas               ← optional visual map
├── 02 — Study Dashboard.base            ← optional Base dashboard
├── README_PLUGINS.md                    ← plugin install guide
├── Lectures/   12 study sheets
├── Concepts/  100-180 atomic notes
├── Labs/        9 Python walkthroughs
├── Examples/                            ← worked examples (optional)
├── Formulas/                            ← formula cheat sheets (optional)
└── Assets/                              ← images, diagrams
```

Plus a `.vault-progress.md` if the agent hit any limits (lets you resume).

## Day-to-day study workflow

Once the vault is built:

1. **Open the vault in Obsidian** every study session.
2. **Hover over any wikilink** to see the definition without clicking.
3. **Cmd+O / Ctrl+O** to jump to any concept by name.
4. **Open the graph view** (Cmd+Shift+G) to see how concepts cluster.
5. **Open `Tables.md`** the night before an oral exam — read the elevator pitches aloud.
6. **Run Spaced Repetition** (the plugin) every day for 10 minutes — flashcards from every concept note get scheduled automatically.
7. **For each lecture, open the lecture sheet** and scroll through the *Potential Exam Questions* section — these are exam-style questions written from the actual lecture content.

## When to re-run the agent

- **New lecture** — incremental mode picks up the new slides.
- **New lab** — same.
- **Found a missing concept** — ask the agent to deep-extract a specific lecture again.
- **Want a different format** — *"reformat L05 as a Study Sheet instead of Detailed Notes."*
- **Adding a comparison table** — *"add a comparison of all classifiers we covered to Tables.md."*

## Limitations

- **40-turn cap per agent run.** For very large vaults (40+ lectures), the agent will write a `.vault-progress.md` with resume instructions and stop. Re-invoke to continue.
- **Incremental mode skips re-reading sources by hash.** If you change a slide deck and want it re-extracted, delete the corresponding entry from `source_hashes` in `.vault-progress.md`.
- **English by default.** Ask for Polish (or another language) explicitly in Phase 1 if needed.
