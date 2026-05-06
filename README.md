<div align="center">

![vaultcraft banner](.github/banner.png)

# vaultcraft

**vaultcraft.**

[![License: MIT](https://img.shields.io/badge/License-MIT-violet.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-agent-7C5CB8)](https://claude.com/claude-code)
[![Obsidian](https://img.shields.io/badge/Obsidian-compatible-7C5CB8)](https://obsidian.md)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

A [Claude Code](https://claude.com/claude-code) agent that turns lecture slides, lab notebooks, and textbook PDFs into a navigable, exam-ready [Obsidian](https://obsidian.md) knowledge vault — with hover-visible definitions, ELI5 analogies, comparison tables, and spaced-repetition flashcards.

[Quick start](#installation) · [How to use](#how-to-use) · [Examples](docs/examples.md) · [Conventions](docs/conventions.md) · [Contributing](CONTRIBUTING.md)

</div>

---

## Why this exists

Most students take notes as they go. By exam season, those notes are scattered across PDFs, Notion pages, Google Docs, and handwritten pages. The information is *there* — it's just not retrievable under stress.

This agent inverts the workflow: take the same source material everyone else has (slides, labs, textbooks) and produce a knowledge graph optimised for recall. Hover over any wikilink → see the definition. Cmd+O → jump to any concept. Open the graph view → see how concepts cluster. Open `Tables.md` → recite the elevator pitch for every classifier the night before the oral exam.

---

## What it does

Point vaultcraft at a folder of course materials. Around thirty minutes later, on a typical twelve-lecture course, you have a working Obsidian vault — linked, hover-previewable, exam-ready from the moment you open it.

**~150 atomic concept notes**, one idea per file, 250–500 words each. Every note opens with a `> [!definition]` callout that Obsidian renders inside its hover preview, so skimming a lecture sheet and hovering any wikilink shows you the definition without leaving the page.

The agent splits related techniques instead of bundling them. Where a textbook gives you one "Smoothing" section, the vault gives you six notes — `Laplace Smoothing`, `Add-k Smoothing`, `Good-Turing`, `Kneser-Ney`, `Linear Interpolation`, `Backoff` — each with its own formula, worked numbers, and trade-offs. Same pattern for attention (Scaled Dot-Product, Multi-Head, Self, Cross, Masked, Positional Encoding) and word embeddings (Word2Vec, CBOW, Skip-gram, Negative Sampling, GloVe, FastText, Contextual). At exam time you review one idea per note instead of hunting through paragraphs.

**12 lecture study sheets**, one per session. Each opens with a TL;DR callout (five bullets), follows the slide deck through 1,500–2,500 words of narrative, and closes with 8–12 potential exam questions across four categories: theory, comparison, application, critical thinking.

**9 lab study sheets** if the course includes Python notebooks. Each one lists the library functions actually used (`CountVectorizer.fit_transform`, `nltk.word_tokenize`, …), three to six annotated code patterns, the gotchas that surfaced during the lab, expected output, and four to six exam-style questions.

**`Tables.md` at the vault root** with five to eight side-by-side comparison tables — classifiers, embeddings, smoothing methods. Every row carries a **"Say this"** column: a one-sentence elevator pitch you can recite verbatim during an oral exam.

**Three to five thousand wikilinks** hold the whole thing together. Hover preview, `Cmd+O` jump-to-note, graph view, and backlinks panel all work the moment you open the vault. The bundled `.obsidian/` config handles the look — per-folder graph colours (lectures one shade, concepts another, labs a third), Page Preview enabled, navigation files filtered out of the graph, and CSS snippets that style the callouts.

**ELI5 sections on the hard stuff.** The concepts that slip out of your head under exam pressure get three to five sentences of plain analogy. Backpropagation becomes a restaurant kitchen passing complaints back through the prep line. Attention is reading a book with a flashlight that also lights up nearby words. Cross-entropy is a weather forecaster who gets punished extra for confident wrong predictions. Under stress the analogy surfaces first; the formalism reconstructs from there.

The result is a vault you actually want to open at 2 AM the night before an exam.

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

### Tables.md — the oral-exam cheatsheet

Every vault gets a `Tables.md` at root with comparison tables for the major dimensions of the course. Each row has a **"Say this"** column — a one-sentence elevator pitch you can recite verbatim during an oral exam.

![Tables.md comparison example: classifiers — Naive Bayes vs Logistic Regression vs SVM](examples/screenshots/tables-comparison.png)

Read the *"Say this"* column the night before an exam, and you have a confident opening sentence for any question about that comparison.

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

# 2. Run the installer
./install.sh                 # install agent + skills + templates
./install.sh --demo          # install + show how to run the bundled NLP demo
./install.sh --uninstall     # remove vaultcraft from ~/.claude/
```

The installer copies the agent to `~/.claude/agents/`, bundled skills to `~/.claude/skills/`, and templates to `~/Documents/ObsidianVaults/_templates/`. You can also do this manually if you prefer:

```bash
mkdir -p ~/.claude/agents && cp agents/vaultcraft.md ~/.claude/agents/
mkdir -p ~/.claude/skills && cp -R skills/obsidian-* ~/.claude/skills/
```

### Try the demo (60 seconds)

Want to see what vaultcraft produces before pointing it at your real coursework?

```bash
./install.sh --demo
```

This installs the agent and shows you exactly what to paste into Claude Code to build a small NLP vault from three bundled lecture stubs (`examples/demo-materials/`). The output lands at `~/Documents/ObsidianVaults/vaultcraft-demo/` — open it in Obsidian to see linked concept notes, hover-visible definitions, exam questions, and a populated graph view.

The agent is now available to Claude Code. Invoke it like:

```
> I have lecture slides for my NLP course in ~/Downloads/.
> Build me an exam-ready Obsidian vault at ~/Documents/ObsidianVaults/NLP/.
```

Claude Code will recognise the task and spawn the `vaultcraft` sub-agent. You'll know it's alive when it prints its banner.

See [`docs/installation.md`](docs/installation.md) for full setup including Obsidian plugin recommendations and skill installation. New to vaultcraft? Check [`docs/faq.md`](docs/faq.md) first.

---

## How to use

The agent always runs **Phase 1 — Intake** first, asking eleven quick questions before touching any files. The first one — *what kind of vault is this?* — is the most load-bearing; the rest of the agent's behaviour adapts to the answer. Answer them all, the agent restates the plan, you confirm, and it runs.

### Intake form

**Context** — what kind of vault and what it's for

| # | Field | Expected answer |
|---|---|---|
| 1 | Vault type | **`studies`** · `work` · `personal` · `research` · `reference` · `teaching` (see [docs/vault-types.md](docs/vault-types.md)) |
| 2 | Name | Course name · project name · topic — used in titles and frontmatter |
| 3 | Goal | What the vault is FOR — exam prep · onboarding doc · lit review · runbook · etc. |
| 4 | Priority topics | Must-know vs. nice-to-have |

**Deadline** — only required for `studies` and time-bound projects

| # | Field | Expected answer |
|---|---|---|
| 5 | Output target / deadline | Exam date · release date · submission · "no rush" |

**Format** — how the agent should write

| # | Field | Expected answer |
|---|---|---|
| 6 | Format preference | **Concise** (300–700w, scannable) · **Narrative** (1,200–2,500w, story-style) · **Reference** (terse, code-heavy) |
| 7 | Depth | **lean** (~40% cheaper) · **standard** (default) · **thorough** |
| 8 | Explanation styles | Pick 1–3: `eli5` · `technical-analogy` · `historical` · `counter-example` · `visual-metaphor` · `real-world-application` · `devils-advocate` · `worked-example` (see [Principle 19 in the agent](agents/vaultcraft.md)) |

**Inputs and outputs** — paths the agent should work with

| # | Field | Expected answer |
|---|---|---|
| 9 | Vault path | Where to build the vault, e.g. `~/Documents/ObsidianVaults/my-vault/` |
| 10 | Source files | Paths to PDFs · PPTX · .py · .ipynb · textbook excerpts · web URLs · pasted text |
| 11 | Language | English (default) · Polish · mixed |

### Typical run time

| Course size | Time on Sonnet | Time on Haiku |
|---|---|---|
| Light (5–7 lectures, no labs) | ~15 min | ~8 min |
| Standard (10–12 lectures + labs) | 30–60 min | 15–30 min |
| Heavy (16+ lectures + many labs) | 60–120 min | 30–60 min |

The agent uses **3-tier model routing** — Haiku for mechanical writing, Sonnet for synthesis, Opus only for hard reasoning (novel ELI5 analogies, ambiguous concept extraction). Full decision flow lives in Principle 18 of [`agents/vaultcraft.md`](agents/vaultcraft.md).

See [`docs/usage.md`](docs/usage.md) for example prompts and full workflow.

---

## What's in this repo

```
vaultcraft/
├── agents/
│   └── vaultcraft.md   ← The agent definition
├── skills/                      ← Obsidian skills the agent uses
│   ├── obsidian-markdown/
│   ├── obsidian-bases/
│   ├── obsidian-cli/
│   ├── json-canvas/
│   └── README.md
├── docs/
│   ├── installation.md          ← Detailed setup
│   ├── usage.md                  ← Example invocations
│   ├── conventions.md            ← Vault structure spec
│   └── examples.md               ← Sample concept / lecture notes
├── templates/
│   ├── concept.md                ← Atomic concept template
│   ├── lecture.md                ← Lecture study sheet template
│   ├── lab.md                    ← Lab study sheet template
│   └── bridge.md                 ← Cross-course bridge template
├── examples/screenshots/         ← Graph view example image
├── .github/                      ← Banner, issue templates, CI workflow
├── README.md                     ← This file
├── CONTRIBUTING.md
└── LICENSE                       ← MIT
```

---

## Skills the agent uses

The agent calls Claude Code skills to handle Obsidian-specific syntax and supplementary research. Four are bundled in `skills/`; six others are optional and the agent gracefully falls back if they're missing.

### Bundled (recommended install — copy to `~/.claude/skills/`)

| Skill | Purpose | When the agent invokes it |
|---|---|---|
| `obsidian-markdown` | Valid Obsidian Flavored Markdown — wikilinks, embeds, callouts, properties, frontmatter | Any time the agent writes a note (avoids syntax mistakes) |
| `obsidian-bases` | Generate `.base` files (Obsidian Bases — filterable database views) | Phase 7, when building the optional Study Dashboard |
| `obsidian-cli` | Bulk vault operations (rename, move, link verification) | Optional, used when doing >20 file operations in one pass |
| `json-canvas` | Generate `.canvas` JSON Canvas files (visual concept maps) | Phase 6, optional Course Map |

### Optional (not bundled — install separately if you want full functionality)

| Skill | Purpose | When the agent invokes it |
|---|---|---|
| `defuddle` | Clean markdown extraction from web pages | Phase 2, when supplementary web research has noisy HTML (ads, nav, comments) |
| `deep-research` | Multi-source research with synthesis (firecrawl + exa MCPs) | Phase 2, when a concept is under-explained in slides and needs >2 sources |
| `exa-search` | Neural search via Exa MCP | Phase 2, when finding a specific paper or reference implementation |
| `docs` | Context7 documentation lookup for libraries | Phase 5, when generating lab notes that use unfamiliar libraries (verifies API signatures) |
| `iterative-retrieval` | Progressive context retrieval for very long PDFs | Phase 2, only for >100-page PDFs |
| `context-engineering` | Meta-skill for agent context optimisation | Rare — only if the agent thrashes on setup |

**The agent works without any of these skills.** Skills speed things up and reduce mistakes; they are not strict dependencies. See [`skills/README.md`](skills/README.md) for full install instructions and fallback behaviour.

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
