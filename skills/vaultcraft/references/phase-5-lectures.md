# vaultcraft: phase 5 (lecture notes)

## Phase 5 - Per-Lecture Notes

**Choose format from Principle 16 based on user's answer in Phase 1. Respect depth setting (lean/standard/thorough) from Phase 1.**

**Token economy:** lecture notes are also templatable. If depth=lean or depth=standard with Study Sheet format, delegate via Task tool with haiku (per Principle 18). For depth=thorough with Detailed Lecture Notes format, the narrative judgement calls may warrant sonnet - use your discretion. When in doubt, draft the first lecture yourself (sonnet), then delegate the remaining 9 to haiku with your L01 as the quality exemplar. Format (c) Golden Template is fully templated - haiku-eligible once you've drafted L01 as the exemplar.

Formats (a) and (b) share this skeleton (Format (c) has its own fixed skeleton further below):

```markdown
---
tags: [lecture]
session: <n>
title: <full title>
source-file: <original filename>
---

# L0X - <Title>

> [!tldr] TL;DR (30 seconds)
> - <Key insight 1>
> - <Key insight 2>
> - <Key insight 3>
> - <Key insight 4 or 5 if lecture is wide>

## <Topic section 1 - matches a slide section>

<Format-dependent body - see below.>

→ See [[<Concept Note>]] for derivation depth.

---

## <Topic section 2 - next section>

<Same pattern.>

---

## Key takeaways

1. <One-liner>
2. <One-liner>
3. <One-liner>
4. <One-liner>

## Concepts introduced

- [[Concept A]] - one-line reminder of role in this lecture
- [[Concept B]] - ...

## Potential Exam Questions

### Theory / Definitions
1. **<Question>** - <1–2 line pointer with [[wikilink]]>

### Understanding / Comparison
2. ...

### Application / Worked problem
3. ...

### Critical thinking
4. ...

## Sources
- Slides: `<original filename>`
- Lab: [[Lab0X - Title]]
```

---

**Format (a) - Study Sheet (scannable, 400–750 words body):**

Each topic section follows a compact mini-box pattern:

````markdown
> [!definition] In one line
> **<Concept>** - <one-sentence definition>.

**Why it matters** - <2–3 sentences on motivation and when you'd use this>.

**Example**
```python
# runnable snippet, 2–6 lines max
```

**Gotcha** - <1–2 line pitfall>.

→ See [[Concept Note]] for full derivation.

````

Scan-ability first. Max 3 sentences of prose between boxes. Tables for any comparison. Mermaid for any pipeline/hierarchy. Code snippets ≤ 6 lines. One formula per section max.

---

**Format (b) - Detailed Lecture Notes (narrative, 1200–2500 words body):**

Each topic section expands into full narrative paragraphs:

```markdown
> [!definition] <Concept name>
> **<Concept>** is <one-sentence definition>.

**Intuition.** <1–2 paragraph narrative in plain language, the way a professor would explain it out loud. Include the "aha moment" or the reason the technique was invented. 80–150 words.>

**Formal detail.** <1 paragraph + formula if applicable. Explain each symbol. Walk through derivations. 80–120 words.>

**Worked example.** <A concrete numerical OR code example with actual values. Show the computation. For math-heavy lectures this is essential. 100–200 words or a code block with real numbers.>

**Why it matters / when to use.** <1 paragraph on practical relevance, what it solves, what its alternative is, when it fails. 60–100 words.>

**Gotcha.** <1–3 bullets of pitfalls and common mistakes.>

→ See [[Concept Note]] for derivation depth.
```

For lectures with many slides on a single theme, add a "Running through the slide deck" narrative section that ties topics together as they flow in the lecture arc, e.g.:

> "The lecturer started by motivating n-gram models from the chain rule, then introduced the Markov assumption as a tractability compromise. The issue of sparsity led to the sequence: unsmoothed MLE → Laplace → Add-k → Good-Turing → Kneser-Ney. The key insight is that better smoothing reduces perplexity dramatically even without changing n..."

This makes the note read as a coherent lecture, not disconnected Q&A.

---

**Format (c) - Golden Template (CBS standard, fixed sections):**

Use ONLY when the user opted into templates in Phase 1 (Principle 16b). Fill `templates/lecture-golden.md` verbatim - keep section order, never drop a section. Differences vs. formats (a)/(b):

```markdown
---
tags:
  - lecture
  - course/COURSE_CODE
aliases:
  - L0X
  - Lecture 0X COURSE_SHORT
source: COURSE-L0X_slides.pdf
status: new
created: YYYY-MM-DD
exam-likely: true
course: COURSE_CODE
topic-area: [primary theme, secondary theme]
description: "One sentence naming what this lecture establishes and why it matters."
---

> [!example]+ 🎞️ Course slides
> ![[COURSE-L0X_slides.pdf]]

# L0X — Lecture Title

> [!tldr] TL;DR: the argument of the whole lecture
> Two to four short paragraphs, prose not bullets, stating the lecture's actual argument end to end. Wikilink the concepts on first mention.
>
> A reader who stops here should understand what the lecture claims and why, not merely which topics it lists. Name the problem the lecture solves, the mechanism it introduces, and what it sets up for the next lecture.

## Navigate this lecture

(a fenced mermaid block here: flowchart LR mapping the lecture's arc,
 Opening problem -> First mechanism -> Core technique -> Extension or limit -> Next lecture)

## 1. Section headings are claims, not labels

Every numbered heading states something arguable. Write "Data only becomes useful in context", never "Data". A reader skimming the headings alone should be able to reconstruct the argument.

> [!definition] [[Concept Note Name]]
> The definition, under 160 plain-text characters so it reads cleanly as a hover preview. No wikilinks and no bold inside a definition callout body.

Narrative prose develops the claim. Aim for 200 to 400 words per section, referencing the concept notes on first mention.

| Term | What it answers | Example | Do not confuse with |
|---|---|---|---|
| First | The question it settles | A concrete instance | Its common lookalike |
| Second | The question it settles | A concrete instance | Its common lookalike |

A "Do not confuse with" column is worth more than a definition restated, because it encodes the distinction an exam actually tests.

![[COURSE-L0X-fig-descriptive-name.png|650]]

**Read the visual.** Say what the reader should look at and what it proves. A figure without this lead-in is decoration. Name figures descriptively (`fig-three-schema`), never by slide number, so a re-export does not break every embed.

> [!tip] Exam-safe test
> A short, portable rule the reader can apply under time pressure.

## 2. Keep going for eight to eleven numbered sections

Use `> [!warning]` for a trap, `> [!example]` for a worked case, `> [!quote]` for a primary source. Use fenced code blocks for anything executable, and `$...$` or `$$...$$` for mathematics.

## Running through the deck

Two or three paragraphs explaining why the deck is ordered as it is: what the opening earns, why the middle sits where it does, and what the closing sets up. This is the section that turns a list of topics into a remembered argument.

## Key terms at a glance

| Term | One-line recall |
|---|---|
| First term | The compressed version that survives in memory |
| Second term | The compressed version that survives in memory |

## What to be able to do

1. A verb-first capability, phrased as an exam task rather than a topic.
2. Compare two things the lecture deliberately contrasted.
3. Classify a new case using the lecture's own scheme.
4. Work an end-to-end example, naming the step most people skip.
5. Defend a judgement call the lecture flagged as contested.

## Exam cues

Three or four `[!question]` callouts, each carrying its model answer inside the callout and
ending with a pointer to the concept note, for example: See [[Concept Note Name]].
Include at least one question asking "why", not only "what", since definitions alone rarely carry full marks.

## Flashcards

OPTIONAL section. Omit it entirely unless spaced repetition was requested during intake.
When it is wanted, pick one format and keep it consistent across the whole vault:
`Question text?::Answer text.` for the obsidian-spaced-repetition plugin, or
`**Q:**` / `**A:**` line pairs for a plugin-free prose version.

## Related notes

- [[Concept One]] · [[Concept Two]] · [[Concept Three]]
- [[Concept Four]] · [[Concept Five]]
- Next: [[L0Y — Following Lecture]]

## Source coverage

All NN PDF pages are incorporated by topic cluster: opening and definitions (pp. 1-8); the core mechanism (pp. 9-19); worked examples (pp. 20-28); extensions and limits (pp. 29-NN). Figures reproduced above are extracted from the supplied PDF.

**Sources:** `COURSE-L0X_slides.pdf`; textbook reference with chapter; course, institution, term.

```

Quality checklist for Format (c) - verify before marking a note done:

- [ ] PDF embedded in a `[!example]+` callout; 6-11 figures extracted with DESCRIPTIVE names, each followed by a bold "**Read the visual.**" lead-in
- [ ] TL;DR is prose paragraphs stating the argument; numbered section headings are claims, not labels; `## Navigate this lecture` mermaid present
- [ ] All concepts linked to concept notes via wikilinks; Key terms table exam-ready
- [ ] Exam cues carry model answers, not bare questions; any flashcards (optional) are ≤15 words
- [ ] Relations section connects course hub + prerequisites; sources cited explicitly

---

**Shared rules (all formats):**

- Every first mention of a concept gets a `[[wikilink]]`. No exceptions.
- Comparison tables for any 2+ alternatives compared in slides.
- Mermaid diagrams for pipelines, state machines, hierarchies.
- Formulas in LaTeX ($inline$, $$display$$).
- Preserve exam questions section - it is mandatory, don't shrink.
- **For labs specifically**: include key Python patterns in a `## Core code patterns` section, each with 3–8 line snippets and "What's happening" + "Gotcha" annotations. Full lab script can go in a collapsible `> [!example]- Full lab script` callout.
