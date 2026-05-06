# Skills bundled with vaultcraft

The vaultcraft agent calls four Obsidian-specific [Claude Code skills](https://docs.claude.com/en/docs/claude-code/skills). To save you a separate install, copies are bundled here.

## Installation

```bash
mkdir -p ~/.claude/skills
cp -r skills/* ~/.claude/skills/
```

After this, Claude Code will auto-discover them on the next session.

## What each skill does

| Skill | Purpose | When the agent invokes it |
|---|---|---|
| `obsidian-markdown` | Generate valid Obsidian Flavored Markdown (wikilinks, embeds, callouts, properties) | Any time the agent writes a note - handles edge cases the agent doesn't memorise |
| `obsidian-bases` | Build `.base` files (Obsidian Bases) - filterable database views | Phase 7, when generating the Study Dashboard |
| `obsidian-cli` | Bulk vault operations (rename, move, link verification) via Obsidian CLI | Optional - used when doing >20 file operations in one pass |
| `json-canvas` | Build `.canvas` JSON Canvas files (visual concept maps) | Phase 6, when generating the optional Course Map |

## Are these required?

**No.** The agent gracefully falls back to direct `Read`/`Write`/`Edit` tools if a skill is missing. The skills speed things up and avoid syntax mistakes, but the agent works without them.

If you skip the install, the agent will:
- Still produce valid Obsidian-flavored markdown (using its own knowledge)
- Skip `.base` generation (Phase 7's Study Dashboard becomes optional)
- Skip `.canvas` generation (Phase 6 was already low-priority)
- Use Bash for any bulk file ops

## Attribution

These skill files were installed locally on the maintainer's machine in April 2026, source unknown (no `LICENSE` file present at install). They are bundled here verbatim for convenience.

**If you authored any of these skills and want attribution credit or removal from this repo, please open an issue.** We will update or remove on request - no questions asked.

## Skills the agent references but does NOT bundle

The agent's "Skills You Leverage" section also mentions these general-purpose skills:

- `defuddle` - clean markdown extraction from web pages
- `deep-research` - multi-source web research with synthesis (firecrawl + exa MCPs)
- `exa-search` - neural search via Exa MCP
- `docs` - Context7 documentation lookup
- `iterative-retrieval` - progressive context retrieval for very long PDFs
- `context-engineering` - meta-skill for agent context optimisation

These are NOT bundled because they are general-purpose tools used across many agents and have their own install paths. The agent will function without them - they are nice-to-have for specific phases:

- Phase 2 web supplementation: prefer `WebSearch` + `WebFetch` if `deep-research`/`exa-search` aren't installed
- Phase 4 lab notes: skip API verification if `docs` isn't installed
- Phase 2 large PDFs: use `Read` with `pages` parameter if `iterative-retrieval` isn't installed
