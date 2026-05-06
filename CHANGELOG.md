# Changelog

All notable changes to **vaultcraft** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project adheres (loosely) to [Semantic Versioning](https://semver.org).

## [Unreleased]

### Added

- **Six vault types** in Phase 1 question 1: `studies`, `work`, `personal`, `research`, `reference`, `teaching`. Each gets its own folder structure (e.g., `work` has `Decisions/` for ADRs, `research` has `Papers/` + `Bibliography/`, `teaching` adds *"How to introduce this"* + *"Common student misconceptions"* sections per concept). Tables.md, exam questions, and other defaults adapt accordingly.
- **Eight explanation styles** (Principle 19, expanded from ELI5-only): `eli5`, `technical-analogy`, `historical`, `counter-example`, `visual-metaphor`, `real-world-application`, `devils-advocate`, `worked-example`. User picks 1–3 in Phase 1 question 8; defaults differ by vault type.
- **`docs/vault-types.md`** — full reference for all six vault types with folder structure, special behaviour, frontmatter examples, and guidance on choosing.
- **Status footer** — agent prints `─── vaultcraft · model: <model> · phase N/8 · <stat> ───` after every major output to keep brand visible and surface model tier in real time.
- **3-tier model routing** (Principle 18 expanded): Tier 1 Haiku for mechanical writing, Tier 2 Sonnet for synthesis, Tier 3 Opus for novel ELI5 analogies / ambiguous extraction / hard reasoning. Replaces single-tier Haiku-only delegation.
- **CODE_OF_CONDUCT.md** adapted from Contributor Covenant, simplified for a small student project.
- **CHANGELOG.md** following Keep a Changelog format.
- **Strengthened English-default language policy** as a top-level non-negotiable section in the agent prompt. Conversation can match user's language; artefacts written to disk stay English unless user explicitly requests another language.

### Changed

- Phase 1 grew from 9 to 11 questions, restructured around vault type → name → goal → priorities → deadline → format → depth → explanation styles → path → sources → language.
- README intake table reorganized: Context (1–4) · Deadline (5) · Format (6–8) · Inputs/outputs (9–11).
- Banner ASCII art now prints on every agent invocation (not just first session).
- Subtitle below ASCII reverted to single-line `⛏ an obsidian study vault builder ⛏`.

---

## [0.1.0] — 2026-05-06

First public release of vaultcraft.

### Added

- **`agents/vaultcraft.md`** — the core agent, ~850 lines, 11 phases (0 through 8 with halves), 20 numbered principles
  - Phase 0: mode detection (bootstrap / incremental / resume)
  - Phase 1: 9-question intake form
  - Phase 1.5: budget plan + `.vault-progress.md` for resumable runs
  - Phase 2 / 2.5 / 3: extraction, vault config, structure
  - Phase 4: atomic concept notes (with wikilink registry pre-flight check)
  - Phase 5: lecture and lab study sheets
  - Phase 6: optional JSON Canvas (low priority)
  - Phase 7: MOC + `Tables.md` for oral exams
  - Phase 8: quality pass (broken-link audit, orphan check, depth check)
- **3-tier model routing** (Principle 18) — Haiku for mechanical work, Sonnet for synthesis, Opus for hard reasoning
- **ASCII banner greeting** — agent prints `VAULTCRAFT` ASCII art on every invocation
- **Status footer** — `─── vaultcraft · model: X · phase N/8 · stat ───` after every major output
- **`skills/`** — 4 bundled Obsidian-specific Claude Code skills:
  - `obsidian-markdown` — wikilinks, embeds, callouts, properties
  - `obsidian-bases` — `.base` filterable database views
  - `obsidian-cli` — bulk vault operations
  - `json-canvas` — `.canvas` concept-map files
- **`templates/`** — 4 note templates: `concept.md`, `lecture.md`, `lab.md`, `bridge.md`
- **`docs/`** — installation, usage, conventions, examples, FAQ
- **`.github/`** — banner image, issue templates (bug / feature / course recipe), PR template, markdown-lint workflow
- **README** with banner, badges, quick navigation, concrete output stats, screenshot of real 4-course vault graph view, screenshot of `Tables.md`
- **CONTRIBUTING.md** with style guide and privacy rules
- **CODE_OF_CONDUCT.md** adapted from Contributor Covenant
- **MIT License**

### Known limitations

- Source quality matters — bullet-only slide decks produce thinner vaults
- PPTX support requires LibreOffice (`soffice --headless --convert-to pdf`)
- Math notation in scanned PDFs (OCR) loses LaTeX
- Claude Code only — porting to other agent frameworks would need rewriting orchestration

### Not yet shipped (planned)

- Hover preview screenshot in `examples/screenshots/`
- ELI5 callout screenshot in `examples/screenshots/`
- Demo GIF showing agent in action
- Course-recipe library (community-contributed working configurations for specific courses)

[Unreleased]: https://github.com/MikolajSapek/vaultcraft/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/MikolajSapek/vaultcraft/releases/tag/v0.1.0
