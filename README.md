<div align="center">

![vaultcraft banner](.github/banner.png)

# vaultcraft

**An obsidian study vault builder.**

[![License: MIT](https://img.shields.io/badge/License-MIT-violet.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-agent-7C5CB8)](https://claude.com/claude-code)
[![Obsidian](https://img.shields.io/badge/Obsidian-compatible-7C5CB8)](https://obsidian.md)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

A [Claude Code](https://claude.com/claude-code) agent that turns lecture slides, lab notebooks, and textbook PDFs into a navigable, exam-ready [Obsidian](https://obsidian.md) knowledge vault — with hover-visible definitions, ELI5 analogies, comparison tables, and spaced-repetition flashcards.

[Quick start](#installation) · [How to use](#how-to-use) · [Examples](docs/examples.md) · [Conventions](docs/conventions.md) · [Contributing](CONTRIBUTING.md)

</div>

---

## What it does

Point the agent at a folder of course materials. It will:

1. **Read every slide deck and lab notebook** (PDFs, PPTX, .py, .ipynb).
2. **Extract atomic concepts** — every named technique, algorithm, metric, or method becomes its own note. *Smoothing* → six notes (Laplace, Add-k, Good-Turing, Kneser-Ney, Interpolation, Backoff). *Attention* → six notes (Scaled Dot-Product, Multi-Head, Self, Cross, Masked, Sinusoidal).
3. **Build a linked vault** with three layers:
   - **Atomic concept notes** — one concept per file, definition callout for hover preview, worked numerical example, ELI5 analogy, flashcards.
   - **Lecture study sheets** — per-lecture narrative walkthroughs with TL;DR, sections matching the slide deck, and 8–12 potential exam questions.
   - **Lab study sheets** — Python pattern walkthroughs, key library functions, gotchas, expected outputs.
4. **Cross-link aggressively** — every concept is wikilinked to related concepts. Average vault has 3,000–5,000 wikilinks across 400–600 notes.
5. **Configure Obsidian** — graph view colour-coded by folder path, hover preview enabled, recommended plugins listed.
6. **Build oral-exam tools** — `Tables.md` with comparison tables and an "elevator pitch bank" for every key concept.

The output: a vault you actually want to open at 2 AM the night before an exam.

---

## Why this exists

Most students take notes as they go. By exam season, those notes are scattered across PDFs, Notion pages, Google Docs, and handwritten pages. The information is *there* — it's just not retrievable under stress.

This agent inverts the workflow: take the same source material everyone else has (slides, labs, textbooks) and produce a knowledge graph optimized for recall. Hover over any wikilink → see the definition. Cmd+O → jump to any concept. Open the graph view → see how concepts cluster. Open `Tables.md` → recite the elevator pitch for every classifier the night before the oral exam.

---

## Example output

After running across four full courses (NLP, ML, Predictive Analytics, Digital Platforms), the resulting Obsidian graph view looks like this:

![Graph view of a 4-course vault built by vaultcraft](examples/screenshots/graph-view-example.png)

**What you're looking at:**
- Each colour cluster is one course (path-based colouring — no tag pollution)
- ~640 atomic notes across 4 courses, ~4,700 wikilinks holding them together
- Red dots: cross-course bridge notes in `_Shared/` connecting concepts across courses (e.g., *AIC/BIC* shared between PA and ML)
- White dots: lecture / lab study sheets — they sit at the centre of each course's concept cluster because every concept they introduce links back to them
- Smaller dots on the periphery: leaf concepts (definitions, formulas) referenced once or twice
- Larger dots in the middle of clusters: hub concepts (e.g., *Transformer*, *ARIMA*, *Logistic Regression*) referenced from many other notes

This is what semantic structure *looks like* — clusters emerge naturally from how concepts are wikilinked, not from any manual layout.

After running on a typical single course (12 lectures + 9 labs):

```
my-course/
├── 00 — Start Here.md               ← entry MOC
├── Tables.md                         ← oral-exam comparison tables
├── Lectures/   12 study sheets        ← TL;DR + narrative + exam Qs
├── Concepts/  ~150 atomic notes       ← hover-friendly definitions
└── Labs/        9 Python walkthroughs
```

Each concept note has:
- 1-sentence definition (hover preview shows it without clicking)
- Intuition (plain English)
- Worked numerical example
- "Simple explanation (ELI5)" — analogy with everyday objects
- Wikilinks to related concepts
- Flashcards for spaced repetition

See [`docs/examples.md`](docs/examples.md) for sample notes.

---

## Installation

You need [Claude Code](https://claude.com/claude-code) installed.

```bash
# 1. Clone this repo
git clone https://github.com/MikolajSapek/vaultcraft.git
cd vaultcraft

# 2. Copy the agent into your Claude Code agents folder
mkdir -p ~/.claude/agents
cp agents/vaultcraft-builder.md ~/.claude/agents/

# 3. (Optional) Copy templates if you want to author notes manually too
mkdir -p ~/Documents/ObsidianVaults/_templates
cp templates/*.md ~/Documents/ObsidianVaults/_templates/
```

The agent is now available to Claude Code. Invoke it like:

```
> I have lecture slides for my NLP course in ~/Downloads/.
> Build me an exam-ready Obsidian vault at ~/Documents/ObsidianVaults/NLP/.
```

Claude Code will recognize the task and spawn the `vaultcraft-builder` sub-agent.

See [`docs/installation.md`](docs/installation.md) for full setup including Obsidian plugin recommendations.

---

## How to use

The agent always runs Phase 1 — Intake first, asking 9 questions:

1. Which course are the notes from?
2. What's the purpose of the vault? (written exam, oral exam, term paper, daily reference, interview prep, making hard material approachable)
3. Which topics are must-know vs. nice-to-have?
4. Exam format? (test/essay/project/oral/coding)
5. Exam date?
6. Lecture format preference: Study Sheet (400–750w scannable) or Detailed Notes (1200–2500w narrative)?
7. Depth setting: lean / standard / thorough
8. Vault path?
9. Input sources?

Answer those, then the agent runs the full pipeline. Total time: 30–60 minutes for a typical 12-lecture course on a fast Claude model.

See [`docs/usage.md`](docs/usage.md) for example prompts and full workflow.

---

## What's in this repo

```
vaultcraft/
├── agents/
│   └── vaultcraft-builder.md   ← The agent definition
├── docs/
│   ├── installation.md                    ← Detailed setup
│   ├── usage.md                            ← Example invocations
│   ├── conventions.md                      ← Vault structure spec
│   └── examples.md                         ← Sample concept / lecture notes
├── templates/
│   ├── concept.md                          ← Atomic concept template
│   ├── lecture.md                          ← Lecture study sheet template
│   ├── lab.md                              ← Lab study sheet template
│   └── bridge.md                           ← Cross-course bridge template
├── README.md                               ← This file
└── LICENSE                                 ← MIT
```

---

## The crafting pipeline

vaultcraft thinks of vault generation as a Minecraft-style crafting workflow. Internally the agent runs nine numbered phases — here's the themed map of what each one does:

| Phase | Themed name | What it does |
|---|---|---|
| 0 | 🗺 **Site survey** | Detect whether you're starting a new vault, adding to one, or resuming an unfinished build |
| 1 | 📜 **Recipe selection** | Ask 9 intake questions: course, exam format, depth, sources, language |
| 1.5 | ⚖️ **Budget & blueprint** | Estimate tool budget and write `.vault-progress.md` so runs are resumable |
| 2 | ⛏ **Mining** | Read every PDF/PPTX/notebook and extract the full inventory of named concepts |
| 2.5 | 🏗 **Foundation** | Bootstrap `.obsidian/` config — graph colours, hotkeys, CSS, plugin recommendations |
| 3 | 🧱 **Layout** | Plan and propose the folder structure |
| 4 | 💎 **Forging concepts** | Generate atomic concept notes — one crystal per concept, all linked |
| 5 | 📚 **Crafting study sheets** | Build per-lecture and per-lab notes that link back to concept crystals |
| 6 | 🗺 **Cartography** *(low priority)* | Optional JSON Canvas course map |
| 7 | 🧭 **Hub & beacon** | Build the entry MOC + `Tables.md` for oral exams |
| 8 | 🔎 **Inspection** | Quality pass: broken links, depth check, orphans, hover-preview verification |

You don't need to know the phase names to use vaultcraft — but the agent announces each one as it runs so you always know what's happening.

---

## Conventions baked into the agent

The agent enforces these conventions across every vault it builds:

- **Atomic notes** — one concept per file, never two.
- **Hover-visible definitions** — definition callout is the FIRST content after the H1, so Obsidian's hover preview shows it without clicking.
- **Worked examples mandatory** — every formula gets actual numbers; every theoretical concept gets a concrete scenario.
- **ELI5 for hard concepts** — math-heavy and abstract concepts get a *"Simple explanation (ELI5)"* section with an everyday-object analogy.
- **Wikilinks not hashtags** — topical clustering happens via `[[wikilinks]]`. Tags are folder-level classifiers only (`concept`, `lecture`, `lab`, `moc`).
- **Path-based graph colours** — graph view is coloured by folder, not by tag, so it stays clean.
- **Comparison tables for oral exams** — `Tables.md` with "Say this" elevator-pitch column.
- **Token economy** — agent delegates mechanical writing (Phase 4 atomic notes, Phase 5 study sheets) to a sub-agent with `model: haiku` to save ~60% of tokens.

See [`docs/conventions.md`](docs/conventions.md) for the full spec.

---

## Limitations

- **Source quality matters.** If your slides are pure bullet-point outlines, the agent has less to extract. Detailed lecture decks produce better vaults.
- **PPTX requires LibreOffice** for conversion (`soffice --headless --convert-to pdf`) — install it for any vault that includes `.pptx` slides.
- **Claude Code only.** The agent is built for Claude Code's agent system. Porting to other agent frameworks would need rewriting the orchestration layer.
- **Math notation in PDF.** OCR on scanned slides loses LaTeX. Agent works best on natively-digital PDFs/PPTX.

---

## License

MIT — see [LICENSE](LICENSE).

---

## Contributing

Pull requests welcome — especially if you've used the agent on your own course and have improvements to suggest. Open an issue first to discuss large changes.

Built by students, for students. If this helps you nail an exam, that's the only thanks needed.
