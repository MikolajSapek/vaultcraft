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

```mermaid
flowchart LR
  A[Opening problem] --> B[First mechanism]
  B --> C[Core technique]
  C --> D[Extension or limit]
  D --> E[Where the next lecture picks up]
```

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
