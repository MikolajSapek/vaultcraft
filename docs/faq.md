# FAQ

## Setup

### Do I need a Claude subscription?

Yes. The agent runs inside [Claude Code](https://claude.com/claude-code), which uses your Claude API access. Claude Code has a free trial; sustained use needs a paid Claude plan.

### Can I run this without internet?

No. The agent calls Claude's API for every step. The vault it produces, however, is fully offline - Obsidian works without internet, and once the vault is built you can study without an active session.

### Will my course materials leave my machine?

The agent runs locally (Claude Code is a CLI on your machine), but the contents of files it reads - your slides, notebooks, etc. - are sent to Claude's API as part of the prompt. If your university or employer prohibits sending materials to third-party LLMs, do not use this tool. Anthropic's data policies for Claude API: <https://www.anthropic.com/legal/aup>.

### Does this work on Windows?

Yes - Claude Code supports macOS, Linux, and Windows (via WSL or native). Obsidian works everywhere too. The bash snippets in `docs/installation.md` use Unix paths; on Windows native, use the equivalent `mkdir` / `copy` PowerShell or just use Git Bash / WSL.

### How do I update to a newer agent version?

```bash
cd vaultcraft
git pull
cp agents/vaultcraft.md ~/.claude/agents/
```

The agent file is a single document - overwrite to update.

---

## Output quality

### My vault came out shallow / missed obvious concepts. Why?

Three common causes:

1. **Source materials are bullet-only outlines.** If your slides don't have full sentences, the agent has limited material to extract from. Ask the agent to supplement from textbook chapters or web sources.
2. **You picked `depth: lean`.** Lean produces concise notes; if you wanted thorough coverage, re-run with `depth: thorough`.
3. **The agent hit the 40-turn budget.** Check if `.vault-progress.md` exists in your vault - if it does, the agent ran out of budget and stopped. Re-invoke; it'll resume from `next_action`.

### Can I correct a mistake the agent made?

Yes - every note is a regular `.md` file. Edit it manually in Obsidian and the agent will respect your edits on the next run (unless you ask it to overwrite).

### How do I tell the agent to fix something specific?

Give it a focused follow-up prompt:

> *"In `Concepts/PPMI.md`, the worked example uses 0.20 but `0.20 / 0.075 = 2.67`, not 1.41. Fix the math."*

Or:

> *"L05 lecture is missing a section on regularization variants. Add atomic notes for L1, L2, ElasticNet under `Concepts/`, link them from L05."*

### The graph view is messy. How do I clean it?

Settings → Open graph view → Display:
- Uncheck **Tags** (the agent's vault doesn't use topical tags, but the default graph shows tag nodes)
- Uncheck **Attachments**
- Toggle **Existing files only**

Or check `.obsidian/graph.json` - the agent writes a clean default config but Obsidian sometimes overrides it on first load.

### My concept notes don't show definitions on hover

Settings → Core plugins → make sure **Page preview** is enabled.

If still not working, the definition callout might not be the FIRST content in the note. Open a sample note and verify it looks like:

```markdown
# Concept Name

> [!definition] Definition
> **Concept Name** is ...
```

The definition callout MUST be directly after the H1 with no other content in between.

---

## Cost and time

### How much does a full course vault cost in API credits?

Highly variable. Rough estimates for a 12-lecture course on Claude API pricing:

| Depth | Tier-1 (Haiku) bulk | Tier-2 (Sonnet) synthesis | Tier-3 (Opus) hard reasoning | Approx total |
|---|---|---|---|---|
| `lean` | ~150K input tokens | ~80K input tokens | ~30K input tokens | $5–10 |
| `standard` | ~250K | ~150K | ~50K | $10–25 |
| `thorough` | ~400K | ~300K | ~100K | $25–60 |

Output tokens are typically ~25% of input. Use `depth: lean` for first pass; iterate with focused prompts after.

### How long does it take?

See the [Typical run time](../README.md#typical-run-time) table in the README. 15–120 minutes depending on size and tier.

### Can I cancel mid-run and resume?

Yes. Hit Ctrl+C / close terminal. The agent writes `.vault-progress.md` after each major phase. Re-invoke and the agent reads the progress file and resumes from `next_action`.

---

## Customization

### Can I change the prompt / behaviour?

Yes - the agent is just a markdown file at `~/.claude/agents/vaultcraft.md`. Edit it. The `description` and `tools` in YAML frontmatter are load-bearing; the body of the prompt is yours to modify.

If your changes work well, please open a PR - others would benefit.

### Can I use this for non-academic content (work knowledge base, research notes)?

Yes, but adjust the prompt. The current agent assumes academic course materials with lectures, labs, exam prep. For research notes you'd want different conventions:
- Replace "lecture" with "paper" in the prompt
- Skip the exam-question generation phase
- Different folder structure

The conventions in `docs/conventions.md` are tuned for studying. Other use cases need different conventions.

### Can I use this with a different note app (Logseq, Roam, Notion)?

Currently no - the agent emits Obsidian-Flavoured Markdown and configures `.obsidian/` directly. Porting requires rewriting the syntax assumptions and dropping Obsidian-specific features (callouts, hover preview, properties, base files). Open an issue if you want this and we can discuss the scope.

---

## Troubleshooting

### Agent says "PPTX cannot be read"

Install LibreOffice for PPTX → PDF conversion:

```bash
# macOS
brew install --cask libreoffice

# Linux
sudo apt install libreoffice  # or your distro equivalent
```

Test: `soffice --version` should print a version. If "command not found", add LibreOffice's `program/` folder to PATH.

### Agent timed out at 40 turns

The agent has `maxTurns: 40` to prevent runaway costs. For very large courses (30+ lectures), one run isn't enough. Two strategies:
- **Split:** run lectures+concepts first, labs+Tables in a second invocation
- **Lean first:** use `depth: lean` for the first pass; targeted re-runs to expand specific lectures

### "Hover preview doesn't show full definition"

Two possible causes:

1. **Page preview core plugin disabled.** Settings → Core plugins → Enable *Page preview*.
2. **Definition callout body too long.** Hover preview shows the first ~250 characters of the note body. The agent enforces ≤200 char definitions, but if you edited a note manually and made the definition very long, the preview will truncate. Edit the definition shorter.

### "I get errors saying skill X not found"

Make sure you ran the install steps in `docs/installation.md`:

```bash
mkdir -p ~/.claude/skills
cp -r skills/* ~/.claude/skills/
```

If still missing, the agent should fall back to direct tools - but if it doesn't, add a frontmatter override at the top of the agent file:

```yaml
---
name: vaultcraft
description: ...
tools: Read, Write, Edit, Glob, Grep, Bash, WebSearch, WebFetch, Task
# remove "Skill" from tools if you don't have any skills installed
---
```

### Graph view shows tag nodes I didn't want

Settings → Open graph view → Display tab → uncheck **Tags**. The agent's vault doesn't rely on tags for topical clustering; the graph stays cleaner without them.

### Some concept notes are tiny stubs

By design - the agent writes a stub when ≥3 wikilinks point to a concept that doesn't exist yet (Principle 12). To replace stubs with full notes, ask:

> *"Expand all stubs in `Concepts/` (notes with `status: new` and under 200 words). Use the source materials I provided."*

---

## Other questions

### Can I share the vault output with other students?

Strongly recommended - see the project's spirit. But before sharing:
- Remove your own assignment / project files
- Redact any names, emails, or institution-specific identifiers from frontmatter `source:` fields
- Check `.obsidian/workspace.json` is not in the zip (contains your recent file list)

### Can I contribute course recipes?

Yes - open an issue using the "Course recipe" template. Share your intake answers and a rough description of how the output came out. Someone else taking a similar course will benefit.

### Where do I report bugs?

Open an issue in this repo. Use the bug report template. Include the agent invocation prompt, what failed, and which phase the failure occurred in (the agent announces phases as it runs).

### Can I run multiple instances in parallel?

Yes, on different vaults. Don't run two instances on the same vault - they'll race on the wikilink registry and produce duplicates.
