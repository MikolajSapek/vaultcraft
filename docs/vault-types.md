# Vault types

vaultcraft supports six vault types. Pick one in Phase 1 question #1 - the agent adapts folder structure, note types, and emphasis to match.

## Quick reference

| Type | When | Folder structure | Special behaviour |
|---|---|---|---|
| **`studies`** | Academic course notes, exam prep | `Lectures/` `Concepts/` `Labs/` `Examples/` | Exam questions on every lecture, `Tables.md` with oral-exam pitches, ELI5 default |
| **`work`** | Professional knowledge base, projects | `Topics/` `Concepts/` `Playbooks/` `Decisions/` `People/` `Meetings/` | No exam questions; "decision matrix" instead of `Tables.md`; real-world-application default |
| **`personal`** | Hobbies, life skills, curiosity | `Topics/` `Concepts/` `Practice/` `Inspiration/` `Journal/` | No exam questions; ELI5 default; flashcards optional |
| **`research`** | Paper / lit notes for academic or industry research | `Papers/` `Concepts/` `Methods/` `Hypotheses/` `Data/` `Bibliography/` | BibTeX-compatible frontmatter; "open questions" instead of exam questions; counter-example emphasis |
| **`reference`** | Technical docs reference, API / runbook collection | `Topics/` `Concepts/` `Procedures/` `Troubleshooting/` | Code-heavy, terse, no narrative; real-world-application default; counter-example for edge cases |
| **`teaching`** | Preparing course materials TO teach | `Lessons/` `Concepts/` `Activities/` `Assessments/` `Resources/` | "How to introduce this" + "Common student misconceptions" sections per concept |

---

## Detail by type

### `studies` - academic exam prep

**Goal:** turn lecture slides + lab notebooks into a vault that lets you find any concept in 3 seconds during exam stress.

- Every lecture gets a study sheet with 8–12 potential exam questions (theory / comparison / application / critical thinking)
- `Tables.md` at root with comparison tables and a "Say this" elevator-pitch column for oral exams
- Concept notes optimise for hover-preview definitions and flashcards
- Default explanation style: `eli5` + `worked-example` for math

This is the original design target of vaultcraft. Most defaults assume this type.

### `work` - professional knowledge base

**Goal:** capture the parts of a job, project, or domain that aren't already in someone's head - and make them retrievable when the right person isn't around.

- Folder structure shifts:
  - **`Topics/`** instead of Lectures - broad areas your work touches
  - **`Playbooks/`** for repeatable procedures (incident response, customer escalation, sprint kickoff)
  - **`Decisions/`** as a lightweight ADR log - dated, reasoning preserved
  - **`People/`** for org structure, stakeholder context, who-knows-what
  - **`Meetings/`** for raw meeting notes (light, decisions extracted into Decisions/)
- No exam questions section
- `Tables.md` becomes a **decision matrix** - when to use approach A vs B
- Default explanation style: `real-world-application` (concrete examples from work context)
- Tone: professional, plain, no academic register

### `personal` - hobbies and life skills

**Goal:** scaffold curiosity-driven learning across hobbies and life topics.

- **`Topics/`** as the broad areas you're learning
- **`Practice/`** for skill drills and progress tracking
- **`Inspiration/`** for sources you want to revisit
- **`Journal/`** for date-stamped entries when relevant (training log, meditation notes)
- No exam questions, no formal tone
- Flashcards optional (only if user wants spaced-repetition for, e.g., language vocab)
- Default explanation style: `eli5` (you're learning at your own pace; analogies stick)

### `research` - academic / industry research

**Goal:** track a body of literature, methods, and open questions for a thesis chapter, paper, or research project.

- **`Papers/`** - one note per cited paper, with structured fields (authors, venue, year, key claims, datasets used, methods, citations)
- **`Concepts/`** - atomic concepts as in `studies`, but with citations
- **`Methods/`** - methodology notes (statistical tests, experimental designs, etc.)
- **`Hypotheses/`** - open questions you're tracking, with predictions and evidence accumulating
- **`Data/`** - datasets, sources, access notes
- **`Bibliography/`** - full BibTeX entries; can export to LaTeX

**Frontmatter on Paper notes:**
```yaml
---
type: paper
authors: [Author Name, Another Name]
year: 2023
venue: NeurIPS
doi: 10.xxxx/xxxxx
status: read | skimmed | queued
relevance: high | medium | low
---
```

- No exam questions; instead a **"## Open questions"** section per Paper note
- Default explanation style: `counter-example` + `historical`

### `reference` - technical documentation

**Goal:** internal docs you can copy-paste from. Optimise for retrieval, not learning.

- Code-first notes with minimal narrative
- **`Procedures/`** for step-by-step how-to
- **`Troubleshooting/`** for symptom-to-cause mappings
- Heavy use of fenced code blocks with language hints
- No exam questions
- Default explanation style: `real-world-application` + `counter-example` (where it breaks matters)
- Tone: terse, imperative

### `teaching` - preparing to teach

**Goal:** materials you'll use to teach others - flipping the agent's perspective from learner to instructor.

- **`Lessons/`** - one note per lesson plan, with timing, learning outcomes, and activity scaffolds
- **`Concepts/`** - but each concept includes:
  - `## How to introduce this` - your hook / opener / motivation for the concept
  - `## Common student misconceptions` - the predictable wrong answers
  - `## Sequencing` - what students need to know first
- **`Activities/`** - exercises, problems, projects
- **`Assessments/`** - rubrics, quizzes, exam questions you'll give
- Default explanation style: `eli5` (you're going to need it for students) + `devils-advocate` (anticipate pushback)

---

## Choosing the right type

Most users land on `studies` or `work`. The rest are situational.

- Got course materials? → `studies`
- Got a project that's not done and you're scared knowledge will leak? → `work`
- Learning a hobby for fun? → `personal`
- Reading a stack of papers? → `research`
- Building docs for a tool? → `reference`
- About to teach a course? → `teaching`

You can change the type later by re-running the agent and asking it to migrate, but folder restructuring on a 200-note vault is a 30-minute job - better to pick the right type up front.

## Mixing types

Don't. One vault, one type. If you have multiple use cases, make multiple vaults (Obsidian supports unlimited vaults - each is just a folder).
