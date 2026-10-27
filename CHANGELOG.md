# Changelog

All notable changes to **vaultcraft** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project adheres (loosely) to [Semantic Versioning](https://semver.org).

## [Unreleased]

### Added

- Visuals are mandatory: every concept and lecture note must contain a Pele-valid Mermaid
  diagram/chart or an embedded image (extracted slide, figure, or openly licensed web image).
  Slide images in lecture notes go inline under the paragraph they illustrate, never in a gallery.
- Goal check: `check_vault.py` reports `missing_visual` and fails until every concept and
  lecture note has a visual.

## [0.6.0] - 2026-10-19

### Added

- Diagram and chart standard: [Pele](https://pele.run), the Mermaid renderer built for Obsidian.
  Charts are Mermaid blocks (`xychart`, `pie`, `quadrantChart`, ...), not images; only diagram
  types today's Obsidian also draws; no `themeVariables`, colour comes from `--pele-*` CSS.
- `skills/vaultcraft/scripts/check_diagrams.mjs`: goal check that parses every Mermaid block
  with Pele and flags Pele-only types and `themeVariables`. Needs Node; installs `pele` on
  first run. Regression test `tests/check-diagrams-test.sh` runs in CI.

## [0.5.0] - 2026-10-17

### Changed

- Model routing is real: the `vaultcraft` agent runs on your session's model and only decides, and three
  worker agents pinned to their models do the writing: `vaultcraft-extractor` and
  `vaultcraft-writer` (Haiku), `vaultcraft-drafter` (Sonnet). Before, the agent asked for
  cheaper models in the prompt text, which does not switch models.
- Generation runs as a loop per source batch until a measurable goal is met: extract,
  decide, write, goal check, fix (Haiku, then Sonnet, then the orchestrator decides),
  record progress.
- `skills/vaultcraft/scripts/check_vault.py`: the goal check (coverage of named items,
  links, orphans, definitions, examples, lecture backlinks). Standard library only, so it
  runs locally in every host with code execution; `tests/check-vault-test.sh` covers it.
- `install.sh` installs the worker agents; `tests/manifest-test.sh` checks each agent's model.

## [0.4.0] - 2026-10-16

### Added

- Optional vaultcraft MCP server for the ChatGPT and Codex directory version
  (`openai/`, server code in MikolajSapek/vaultcraft-mcp): `get_vault_config`,
  `get_note_template` and `check_vault`. The skill uses them when the host lists them.
- `TERMS.md`, declared as `termsOfServiceURL` in the Codex manifest.
- `scripts/package.sh` also builds `dist/vaultcraft-<version>-openai.zip` with the
  server config and the OpenAI review test cases.
- Cursor plugin manifest (`.cursor-plugin/plugin.json`, skills only).
- Claude directory icon (`.claude-plugin/icon.png`, declared as `icon`).

### Changed

- `PRIVACY.md` describes the optional server. The Claude and Cursor versions do not use it.

## [0.3.1] - 2026-10-16

### Added

- `PRIVACY.md`, linked from the README and declared as `privacyPolicyUrl` / `privacyPolicyURL` in both manifests.
- Codex `supportURL`.

### Changed

- README images moved to the `media` branch, so the plugin ships no binary files.
- The Codex logo and composer icon use `assets/logo.svg`.
- The Codex listing meets the OpenAI directory limits: short description of 30 characters or fewer, category `Education & Research`.
- `tests/manifest-test.sh` checks for binaries and enforces the OpenAI listing limits.

### Removed

- The outdated Obsidian MCP and API key setup from `docs/installation.md`.

## [0.3.0] - 2026-10-15

### Added

- **One plugin for Claude, ChatGPT and Codex.** `.codex-plugin/plugin.json` (with logo and icon in `assets/`) and `.agents/plugins/marketplace.json` sit next to the Claude manifests, so the same repo installs in Codex with `codex plugin marketplace add MikolajSapek/vaultcraft` and can be submitted to the ChatGPT/Codex plugin directory and to the Claude directory (claude.ai, Cowork, Claude Code).
- **Runs without the agent.** In claude.ai chat, ChatGPT and Codex the skill runs the whole pipeline itself, falls back to plain-text intake questions, uses Python for PDF figures when `pdfimages` is missing, and delivers the vault as a zip when it cannot write to your disk.
- **`tests/manifest-test.sh`** checks that all manifests carry the same version and that the repo stays within the plugin directories' file rules. **`scripts/package.sh`** builds the upload zips.

### Changed

- **The pipeline moved from the agent into the skill.** The instructions now live in `skills/vaultcraft/references/*.md`, one file per phase group, so every platform runs the same text. `agents/vaultcraft.md` is generated from them by `scripts/build-agent.sh`, and CI fails if it is out of date. Note templates moved to `skills/vaultcraft/templates/`, so they travel with the skill.
- **No silent installs.** The pipeline now asks before running `brew install` for poppler or LibreOffice.
- **README** documents directory installs, where the vault ends up on each platform, and everything the plugin does on your machine. The outdated Obsidian MCP prerequisite is gone; vaultcraft writes files directly.

## [0.2.0] - 2026-10-01

### Added

- **Claude Code plugin.** `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` make the repo installable on macOS, Linux and Windows with `/plugin marketplace add MikolajSapek/vaultcraft` and `/plugin install vaultcraft@vaultcraft`, and updatable with `/plugin update`.
- **Installer regression test** (`tests/install-test.sh`), run in CI next to shellcheck. It fails if the installer overwrites or deletes anything it did not install.

### Changed

- **Installer no longer touches other people's files.** `install.sh` copies only the agent and the `/vaultcraft` front-end skill, records them in `~/.claude/.vaultcraft-installed`, and `--uninstall` removes exactly those files. Previously it overwrote same-named Obsidian skills and its uninstall deleted them.
- **Templates are copied only on request** with `./install.sh --templates <folder>`, and existing templates are kept. The installer no longer creates `~/Documents/ObsidianVaults/_templates` on its own.
- **`maxTurns` raised from 40 to 150**, with the turn budget in Phase 1.5 updated to match. A run that still hits the cap returns a partial result; saying *continue* resumes from `.vault-progress.md`.
- The front-end skill dispatches the agent as `vaultcraft` or, when installed as a plugin, `vaultcraft:vaultcraft`; the agent accepts plugin-prefixed Obsidian skill names.
- README screenshot of an embedded slide deck now comes from the bundled demo materials instead of real course slides.

### Removed

- **Bundled copies of the Obsidian skills** (`obsidian-markdown`, `obsidian-bases`, `obsidian-cli`, `json-canvas`). They belong to [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) by Steph Ango (MIT) and were outdated copies without the licence notice. The docs now point to installing them from the source; the agent still falls back to its own tools without them.

### Earlier unreleased changes (shipped in 0.2.0)

### Changed

- **Flashcards are now opt-in, not the default.** The Phase 1 intake option reads `None (Recommended) · Key concepts only · Every concept`. The agent no longer generates a `## Flashcards` section unless the user explicitly asked for spaced repetition, never adds one to a vault that does not already use them, and never reintroduces one when rewriting an existing note. Templates keep the section as a clearly marked optional block.
- **Golden Template rewritten** (`templates/lecture-golden.md`) from a fixed-section skeleton into the argument-led format validated on a 16-lecture build (roughly 2400 to 4300 words per note). New required anatomy: `[!tldr] TL;DR: the argument of the whole lecture` in prose rather than bullets, a `## Navigate this lecture` mermaid flowchart, 8 to 11 numbered sections whose headings are claims rather than topic labels, `## Running through the deck`, `## Key terms at a glance`, `## What to be able to do`, `## Exam cues` with model answers inside the callouts, and `## Source coverage` mapping PDF page ranges to topic clusters.
- **Figures must be named descriptively** (`fig-three-schema`, not `slide-27`) so a re-exported deck does not break every embed, and each embed carries a bold "Read the visual." lead-in explaining what the reader should look at. A figure without that lead-in counts as decoration.
- Format (c) quality checklist updated to match the new anatomy.

### Added

- **Maintainer workflow documentation**: added `ROADMAP.md`, `SECURITY.md`, `.gitignore`, and `docs/codex-maintenance.md` to make the public OSS maintenance process clearer. The docs describe Codex-assisted review, installer/security review scope, synthetic fixture work, and manual verification expectations for AI-assisted changes.
- **AI-assisted review section in the PR template** so contributors can disclose Codex or other assistant use while confirming manual review and privacy checks.
- **Phase 6 — Embed source materials (on request)** as a new standalone phase in the agent prompt (renumbered existing Phase 6 → 7, 7 → 8, 8 → 9; pipeline is now 0–9, ten phases including the optional 5.5/2.5 fractional ones). Documents the workflow for embedding original course slides / PDFs / paper sources inline in lecture, example, and reading notes when the user asks for it. Covers: LibreOffice `soffice --headless --convert-to pdf` for `.pptx` / `.docx` conversion, normalized naming (`L01_slides.pdf`, `S00_slides.pdf` for sessions, `PS01_solutions.pdf` for problem sets), idempotent `> [!example]+ 🎞️ Course slides (auto-embedded)` callout insertion after frontmatter, `source-file:` frontmatter field for traceability, file-naming hygiene (PDF rename by content, `md5 -q` dedup, drop original `.pptx` post-conversion), and safe source-folder cleanup via Finder AppleScript Trash. Phase runs only on explicit user request, never by default.
- **Six vault types** in Phase 1 question 1: `studies`, `work`, `personal`, `research`, `reference`, `teaching`. Each gets its own folder structure (e.g., `work` has `Decisions/` for ADRs, `research` has `Papers/` + `Bibliography/`, `teaching` adds *"How to introduce this"* + *"Common student misconceptions"* sections per concept). Tables.md, exam questions, and other defaults adapt accordingly.
- **Eight explanation styles** (Principle 19, expanded from ELI5-only): `eli5`, `technical-analogy`, `historical`, `counter-example`, `visual-metaphor`, `real-world-application`, `devils-advocate`, `worked-example`. User picks 1–3 in Phase 1 question 8; defaults differ by vault type.
- **`docs/vault-types.md`** - full reference for all six vault types with folder structure, special behaviour, frontmatter examples, and guidance on choosing.
- **Status footer** - agent prints `─── vaultcraft · model: <model> · phase N/9 · <stat> ───` after every major output to keep brand visible and surface model tier in real time.
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

## [0.1.0] - 2026-05-06

First public release of vaultcraft.

### Added

- **`agents/vaultcraft.md`** - the core agent, ~850 lines, 11 phases (0 through 8 with halves), 20 numbered principles
  - Phase 0: mode detection (bootstrap / incremental / resume)
  - Phase 1: 9-question intake form
  - Phase 1.5: budget plan + `.vault-progress.md` for resumable runs
  - Phase 2 / 2.5 / 3: extraction, vault config, structure
  - Phase 4: atomic concept notes (with wikilink registry pre-flight check)
  - Phase 5: lecture and lab study sheets
  - Phase 6: optional JSON Canvas (low priority)
  - Phase 7: MOC + `Tables.md` for oral exams
  - Phase 8: quality pass (broken-link audit, orphan check, depth check)
- **3-tier model routing** (Principle 18) - Haiku for mechanical work, Sonnet for synthesis, Opus for hard reasoning
- **ASCII banner greeting** - agent prints `VAULTCRAFT` ASCII art on every invocation
- **Status footer** - `─── vaultcraft · model: X · phase N/8 · stat ───` after every major output
- **`skills/`** - 4 bundled Obsidian-specific Claude Code skills:
  - `obsidian-markdown` - wikilinks, embeds, callouts, properties
  - `obsidian-bases` - `.base` filterable database views
  - `obsidian-cli` - bulk vault operations
  - `json-canvas` - `.canvas` concept-map files
- **`templates/`** - 4 note templates: `concept.md`, `lecture.md`, `lab.md`, `bridge.md`
- **`docs/`** - installation, usage, conventions, examples, FAQ
- **`.github/`** - banner image, issue templates (bug / feature / course recipe), PR template, markdown-lint workflow
- **README** with banner, badges, quick navigation, concrete output stats, screenshot of real 4-course vault graph view, screenshot of `Tables.md`
- **CONTRIBUTING.md** with style guide and privacy rules
- **CODE_OF_CONDUCT.md** adapted from Contributor Covenant
- **MIT License**

### Known limitations

- Source quality matters - bullet-only slide decks produce thinner vaults
- PPTX support requires LibreOffice (`soffice --headless --convert-to pdf`)
- Math notation in scanned PDFs (OCR) loses LaTeX
- Claude Code only - porting to other agent frameworks would need rewriting orchestration

### Not yet shipped (planned)

- Hover preview screenshot in `examples/screenshots/`
- ELI5 callout screenshot in `examples/screenshots/`
- Demo GIF showing agent in action
- Course-recipe library (community-contributed working configurations for specific courses)

[Unreleased]: https://github.com/MikolajSapek/vaultcraft/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/MikolajSapek/vaultcraft/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/MikolajSapek/vaultcraft/releases/tag/v0.1.0
