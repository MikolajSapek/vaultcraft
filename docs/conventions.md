# Vault Conventions

The agent enforces these conventions on every vault it builds. If you author notes manually alongside the agent, follow the same conventions.

## Folder structure

Per-course:
```
COURSE/
├── Lectures/      One note per lecture/session — narrative walkthrough
├── Concepts/      Atomic notes — one concept, one file
├── Labs/          Lab session notes with code
├── Examples/      Worked examples, case studies, assignments
├── Formulas/      Formula sheets (optional)
└── Readings/      Reading summaries (optional)
```

Cross-course material lives in `_Shared/Concepts/`.

Vault root:
- `Starting point.md` — root MOC
- `VAULT SPEC.md` — this conventions doc (in real vaults, copy from `templates/`)
- `Tables.md` — comparison tables for oral exams
- `README_PLUGINS.md` — recommended plugin list

## Note types

### 1. Concept note (atomic)

One named concept per file. The atomic unit of the vault.

**Filename:** `Concept Name.md` — title case, spaces allowed, no underscores.

**Required structure:**
1. YAML frontmatter
2. `# Concept Name` heading
3. `> [!definition] Definition` callout — **first content after H1**, so hover preview shows it
4. `## Intuition` — plain language, analogy
5. Main content (formal definition, formula, mechanism)
6. `## Example` or `## In Python` — runnable code where applicable, worked numbers for math
7. `## Simple explanation (ELI5)` — for math-heavy or abstract concepts
8. `## Relations` — wikilinks to related notes
9. `## Flashcards` — `::` syntax for spaced repetition
10. `**Sources:**` line at the bottom

Length target: **250–500 words** for standard depth.

### 2. Lecture note

One file per lecture/session. Narrative walkthrough.

**Filename:** `L01 — Topic Name.md` (NLP/ML/PA), `S01 — Topic Name.md` (DPD-style strategy courses).

**Required structure:**
1. YAML frontmatter
2. `> [!tldr] TL;DR (30 seconds)` callout — 4–6 bullet points
3. Narrative sections matching lecture structure (one `##` per topic)
4. `## Key takeaways` — 4 crisp insights
5. `## Concepts introduced` — bulleted list of `[[wikilinks]]`
6. `## Potential Exam Questions` — 8–12 questions across 4 categories (Theory/Definitions, Understanding/Comparison, Application, Critical thinking)
7. `## Sources`

Length target depends on format:
- **Study Sheet:** 400–750 words body
- **Detailed Lecture Notes:** 1200–2500 words body

### 3. Lab note

Mirrors a lab session. Includes code, expected outputs, takeaways.

**Filename:** `Lab 01 — Topic.md` or `Lab01 — Topic.md`.

**Required sections:**
1. Frontmatter
2. `## What this lab teaches` — 3 bullets
3. `## Libraries & functions introduced` — table mapping each function to the concept it implements (with wikilink)
4. `## Core code patterns` — 3–6 patterns, each with snippet + "What's happening" + "Gotcha"
5. `## Expected output`
6. `## Connection to lecture`
7. `## Gotchas / common mistakes`
8. `## Potential exam questions` — 4–6
9. `## Sources`

### 4. Bridge note (`_Shared/Concepts/`)

Connects the same concept across two or more courses.

**Filename:** `Bridge — Topic Name.md`

Shows how each course frames the concept differently, side by side.

## YAML frontmatter

### Concept note frontmatter

```yaml
---
tags: [concept, course/nlp]
aliases: [synonym1, synonym2]
source: "[[L01 — Lecture Title]]"
status: new
difficulty: 2
created: 2026-05-05
exam-likely: true
course: NLP
---
```

### Lecture note frontmatter

```yaml
---
tags: [lecture, course/nlp]
aliases: [L01, Lecture 01 NLP]
source: session01.pdf
status: review
created: 2026-04-21
exam-likely: true
course: NLP
---
```

### Lab note frontmatter

```yaml
---
tags: [lab, course/nlp]
lab: 1
source-file: lab_01_answers.ipynb
related-lecture: "[[L01 — Lecture Title]]"
course: NLP
---
```

### Bridge note frontmatter

```yaml
---
tags: [concept, bridge]
aliases: []
applies-to: [NLP, DPD, ML]
status: new
created: 2026-05-05
---
```

## Tags

**Use tags ONLY as folder-level classifiers.** One classifier tag per note:
- `concept` for `Concepts/`
- `lecture` for `Lectures/`
- `lab` for `Labs/`
- `moc` for the entry MOC
- `formula` for `Formulas/`
- `example` for `Examples/`
- `reading` for `Readings/`
- `bridge` for cross-course bridges

**Plus a course/ namespace tag** for filtering: `course/nlp`, `course/ml`, etc.

**No topical tags.** No `#nlp`, `#transformers`, `#embeddings`. Topical clustering is done via wikilinks.

## Definition callouts (CRITICAL)

The first content after the H1 in every concept note MUST be a definition callout:

```markdown
# N-gram Language Model

> [!definition] Definition
> An **n-gram language model** estimates the probability of a word given the n-1 preceding words, using the Markov assumption.
```

This is what Obsidian's hover preview shows. Keep the callout body **under 200 characters** so it fits the hover popup completely.

## Wikilinks

Every concept name in note prose should be wikilinked on first mention:

```markdown
A vanilla [[RNN]] uses a single hidden state vector, while [[LSTM]] adds a [[Cell State]] for long-term memory.
```

Filenames must match wikilink targets exactly. Common pitfalls:
- Plural/singular: `[[N-gram Language Model]]` vs `[[N-gram Language Models]]` — be consistent
- Hyphens vs spaces: `[[Stop-Words]]` vs `[[Stop Words]]` vs `[[Stopwords]]` — pick one, alias the others

If a note's filename doesn't match how you want to link to it, add an alias in frontmatter:

```yaml
aliases: [skip-gram, skipgram, Skip Gram]
```

## Flashcards

Use `::` inline syntax (compatible with [obsidian-spaced-repetition](https://github.com/st3v3nmw/obsidian-spaced-repetition)):

```markdown
## Flashcards

What is gradient descent?::Optimization that iteratively moves parameters in the direction of steepest descent of the loss function.
What's the difference between SGD and mini-batch SGD?::SGD uses one example per update; mini-batch averages gradients over 32-256 examples — better GPU efficiency and lower variance.
```

Keep them concise. Front (question) and back (answer) on the same line, separated by `::`.

## ELI5 sections (for hard concepts)

For mathematically heavy or abstract concepts, add an ELI5 section before the Flashcards:

```markdown
## Simple explanation (ELI5)

> [!tip] Explain like I'm five
> Imagine reading a book with a flashlight. You shine it on the word you're reading, but a little light also falls on nearby words. Attention is how the model shines weighted flashlights on different words to figure out what's important for understanding THIS word.
```

Rules:
- 3–5 sentences max
- Pure analogy with everyday objects (toys, kitchens, sports, schools)
- Zero jargon
- The reader should be able to repeat the core idea after reading

## Worked examples (for formulas)

Every formula needs a worked numerical example with specific values:

```markdown
$$ \text{PPMI}(w,c) = \max(0, \log_2 \frac{P(w,c)}{P(w)P(c)}) $$

**Worked example.** Total corpus co-occurrences = 100. For *(cherry, pie)*: joint=20, marginal cherry=25, marginal pie=30.
- $P(w,c) = 20/100 = 0.20$
- $P(w)P(c) = 0.25 × 0.30 = 0.075$
- $\text{PMI} = \log_2(0.20/0.075) = 1.41$
- $\text{PPMI} = \max(0, 1.41) = 1.41$ → strong association
```

A formula without numbers is opaque at exam time. Students can recite the formula but can't apply it.

## Graph view configuration

The agent writes `.obsidian/graph.json` with:

- **Path-based colour groups** — one colour per top-level folder (Lectures, Concepts, Labs, Formulas, Examples, _Shared)
- **Tags hidden** (`showTags: false`) — keeps graph clean
- **Unresolved links hidden** — no orphan grey nodes
- **Search filter** excludes navigation files (`Starting point`, `00 — X Start Here`, `Tables`, `README_PLUGINS`) so only semantic notes appear

If you add new top-level folders, update the colour groups manually in `.obsidian/graph.json`.

## Comparison tables (`Tables.md`)

For oral exams, the agent builds `Tables.md` at the vault root with:
- 5–8 comparison tables covering the major dimensions of the course
- Each table has a **"Say this"** column with a one-sentence elevator pitch the student can recite verbatim
- An **"Elevator pitch bank"** at the end — one memorized sentence per major concept

Open `Tables.md` the night before an oral exam, read the pitches aloud once, and you'll have a reliable starting sentence for every question.
