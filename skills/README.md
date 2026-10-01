# Skills

This folder holds one skill: **`vaultcraft/`**, the interactive front-end. It shows the banner and runs the intake questions in the main conversation, then hands the build to the `vaultcraft` agent (a subagent cannot show a banner or ask interactive questions itself).

## Recommended companion: Obsidian skills by Steph Ango

The agent works best with the official Obsidian skills from [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) (MIT licence, by Steph Ango). They are **not** copied into this repo; install them from the source so you always get the current version.

As a Claude Code plugin:

```text
/plugin marketplace add kepano/obsidian-skills
/plugin install obsidian@obsidian-skills
```

Or manually, by following the instructions in that repository.

| Skill | What vaultcraft uses it for |
|---|---|
| `obsidian-markdown` | Valid Obsidian Flavored Markdown: wikilinks, embeds, callouts, properties |
| `obsidian-bases` | `.base` files for the Study Dashboard |
| `obsidian-cli` | Bulk vault operations (rename, move, link checks) |
| `json-canvas` | `.canvas` concept maps |

## Are they required?

**No.** If a skill is missing, the agent falls back to its own `Read`/`Write`/`Edit` tools:

- it still writes valid Obsidian Markdown from its own knowledge,
- the Study Dashboard (`.base`) and Course Map (`.canvas`) become optional,
- bulk file operations go through Bash.

## Other skills the agent can use if you have them

`defuddle`, `deep-research`, `exa-search`, `docs` and `iterative-retrieval` are general-purpose skills with their own install paths. None is required:

- web supplementation falls back to `WebSearch` + `WebFetch`,
- lab notes skip API verification without `docs`,
- large PDFs are read page by page with `Read` when `iterative-retrieval` is missing.
