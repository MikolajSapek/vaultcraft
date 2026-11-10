# vaultcraft

vaultcraft turns lecture slides, lab sheets, meeting notes, project documents and research papers into a linked Obsidian
study vault. It writes atomic concept notes with hover-visible definitions, lecture notes that link to every concept they
introduce, embedded slides and figures, comparison tables, Mermaid diagrams and cross-course bridge notes, then checks the
vault until every source is covered, every link resolves and every note has a visual.

This is the instructions-only build of vaultcraft for the Claude plugin directory: skills, agents, templates and
references in Markdown. The full version, with the goal-check scripts, is on GitHub:
https://github.com/MikolajSapek/vaultcraft

## How to use

Install in Claude Code: `/plugin install vaultcraft --marketplace MikolajSapek/vaultcraft`. In claude.ai and the Claude apps, add it from the plugin directory.

Ask Claude to build a vault, for example "use vaultcraft to make an Obsidian vault from these lecture slides". vaultcraft
asks a few intake questions (vault type, folder, language, depth), extracts the named items from your files, writes the
notes in batches and runs the goal checks in `skills/vaultcraft/references/goal-checks.md` until they report nothing.

## What the plugin does on your machine

- Reads only the files and folders you give it.
- Writes only inside the vault folder you choose. In claude.ai chat it builds the vault in the sandbox and hands back a zip.
- Runs no scripts and installs nothing. It sends nothing to any other service.

[Privacy](https://github.com/MikolajSapek/vaultcraft/blob/main/PRIVACY.md) · License: MIT (see LICENSE)
