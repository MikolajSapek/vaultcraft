# Roadmap

This roadmap tracks maintainer priorities for vaultcraft. It is intentionally practical: each item should reduce setup friction, improve generated vault quality, or make the project easier to maintain in public.

## Current Focus

- Keep the first public release stable for real Claude Code + Obsidian workflows.
- Make installation safer and easier to verify.
- Add reproducible examples that do not contain private course or workplace material.
- Improve generated vault quality checks.

## Planned

### Installer Safety

- Add `install.sh --dry-run` so users can preview copied files.
- Add installer tests for install, demo, and uninstall flows.
- Document every filesystem location touched by the installer.
- Keep ShellCheck passing for all shell changes.

### Vault Quality Checks

- Add a sample vault validator for broken wikilinks, missing frontmatter, missing first-callout definitions, and orphan notes.
- Add synthetic fixtures for studies, work, and research vaults.
- Publish expected output snapshots for the bundled demo materials.

### Documentation and Examples

- Add a reproducible demo walkthrough with before/after screenshots.
- Expand `docs/examples.md` with anonymised course recipes.
- Add troubleshooting notes for common MCP and Obsidian Local REST API failures.
- Document how to contribute prompt changes safely.

### Maintainer Workflow

- Use Codex for first-pass review of prompt, installer, and documentation changes.
- Use Codex Security where available for shell and filesystem review.
- Keep issue templates focused on reproducible input/output examples.
- Use the PR template to record manual verification for AI-assisted changes.

## Later

- Explore support for other agent runtimes once the Claude Code workflow is stable.
- Add optional link-checking CI for docs.
- Add generated vault regression tests when fixtures are stable enough.
