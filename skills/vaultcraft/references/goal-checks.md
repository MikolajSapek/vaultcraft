# Goal checks without the scripts

Use this file when `<skill-dir>/scripts/check_vault.py` or `scripts/check_diagrams.mjs` is not there (the Claude directory
version ships instructions only) or the host cannot run Python or Node. The rules are the same as the scripts: the vault is
done only when every check below reports nothing. Work through the notes in batches, write the findings to
`.vaultcraft/goal-check.md` in the vault (one heading per check, one line per finding), fix them, and run the checks again
until every list is empty.

Skip these folders everywhere: `.obsidian`, `.vaultcraft`, `.trash`, `.git`. Navigation notes never count as orphans:
`00 - Start here`, `README_plugins`, `01 - Course map`, `Tables` (any letter case).

## 1. Coverage

Every item under `## Named items` in each `.vaultcraft/extract/*.md` file needs a note whose file name or one of its
`aliases` matches the item (letter case and punctuation ignored). Report each missing item with the extract file it came from.

## 2. Links

- Read every `[[wikilink]]` and `![[embed]]` outside code spans and code blocks. Cut the part after `|`, `#` or `^`.
- A link resolves when a note has that file name or alias, or when a file with that name (with or without extension, or that
  relative path) exists in the vault.
- **Broken links:** every link that does not resolve, listed once per note.
- **Orphan notes:** every note that no other note links to (links from a note to itself do not count), except the
  navigation notes above.

## 3. Concept notes

A concept note has `concept` in its `tags`. For each one:

- **Definition:** a `> [!definition]` callout must exist and its text (without the `>` markers) must be at most 200 characters.
- **Example:** a `> [!example]` callout or a heading (level 2 to 4) that contains the word "example".
- **Links:** it links to at least 2 other notes.
- **Lecture link back:** when its front matter has `source: [[Lecture name]]`, that lecture note must link to the concept.

## 4. Visuals

Every concept note and every lecture note (in a `Lectures` folder, or tagged `lecture`) needs at least one visual: a
` ```mermaid ` block or an embedded image (`![[file.png]]`, `.jpg`, `.jpeg`, `.gif`, `.svg`, `.webp`, or a Markdown image).

## 5. Diagrams

For every ` ```mermaid ` block (also inside callouts, where each line starts with `>`):

- The first keyword must be a type that Obsidian's bundled Mermaid 11.13 draws. These Pele-only types show a blank box in
  Obsidian and are not allowed: `swimlane-beta`, `agentflow-beta`, any `railroad...-beta`, `treeView-beta`, `cynefin-beta`,
  `wardley-beta`, `eventmodeling`, `usecase-beta`.
- No `themeVariables` in the block: Pele ignores them.
- The block must be valid Mermaid syntax: check it against the rules in `references/principles.md` (Principle on visuals)
  line by line. Where the host has a Mermaid renderer, render it; a block that does not render counts as a finding.

## Report

When every list is empty, write `Goal check: <n> notes - DONE` at the top of `.vaultcraft/goal-check.md` and give the user the
final report. Otherwise write `NOT DONE`, the count per check, and keep fixing.
