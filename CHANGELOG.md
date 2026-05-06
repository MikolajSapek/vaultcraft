# Changelog

All notable changes to **vaultcraft** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project adheres (loosely) to [Semantic Versioning](https://semver.org).

## [Unreleased]

Things in development that haven't shipped yet.

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
