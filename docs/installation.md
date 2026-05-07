# Installation

## Requirements

- **[Claude Code](https://claude.com/claude-code)** - the official CLI from Anthropic. Free trial available; paid tier needed for sustained use. Run from a terminal; the agent prints status banners and progress lines that read better there than in the desktop chat UI.
- **[Obsidian](https://obsidian.md)** - free, available for Mac, Windows, Linux, iOS, Android.
- **An Obsidian MCP server connected to Claude Code** - see Step 0 below. Without this, the agent can write `.md` files but cannot open notes, run Obsidian commands, or validate wikilinks against the live vault.
- **Python 3** (already on macOS/Linux) - for some helper scripts during vault generation.
- **LibreOffice** (only if you have `.pptx` slides) - `brew install --cask libreoffice` on macOS, used to convert PPTX → PDF.

## Step 0 - Connect an Obsidian MCP server

Claude Code talks to Obsidian through an MCP (Model Context Protocol) server. Pick one of the community servers and register it with Claude Code:

- **[`mcp-obsidian`](https://github.com/MarkusPfundstein/mcp-obsidian)** by MarkusPfundstein - widely used, reads/writes notes via Obsidian's Local REST API plugin
- **[Smithery Obsidian](https://smithery.ai/server/@modelcontextprotocol/obsidian)** - hosted option, fastest to try
- **[obsidian-mcp](https://github.com/StevenStavrakis/obsidian-mcp)** - alternative implementation

Install whichever you pick, then add it to Claude Code:

```bash
# Example with mcp-obsidian (replace with the server you chose)
claude mcp add obsidian -s user -- npx -y mcp-obsidian

# Verify
claude mcp list
```

You should see `obsidian` listed and connected. If the server requires an API key (most do), you also need the **Local REST API** plugin installed inside Obsidian:

1. Open Obsidian → Settings → Community plugins → Browse
2. Search for "Local REST API" and install
3. Enable it, copy the generated API key
4. Paste the key into your MCP server's config (per the server's README)
5. Restart Claude Code

Without a working MCP connection, vaultcraft falls back to writing files directly - you lose hover-preview validation, automatic graph refresh, and the ability for the agent to inspect existing notes before extending them.

## Step 1 - Install the agent

```bash
git clone https://github.com/MikolajSapek/vaultcraft.git
cd vaultcraft

# Install the agent
mkdir -p ~/.claude/agents
cp agents/vaultcraft.md ~/.claude/agents/

# Install the bundled Obsidian skills (recommended)
mkdir -p ~/.claude/skills
cp -r skills/obsidian-markdown skills/obsidian-bases skills/obsidian-cli skills/json-canvas ~/.claude/skills/
```

The `skills/` install is **recommended but optional** - the agent gracefully falls back to direct tools if any skill is missing. See [`skills/README.md`](../skills/README.md) for which skills do what.

Verify Claude Code sees the agent:

```bash
ls ~/.claude/agents/ | grep obsidian
# vaultcraft.md
```

That's it for the agent - Claude Code picks up agents from `~/.claude/agents/` automatically on each invocation.

## Step 2 - Set up your first vault folder

Pick a location and create the folder:

```bash
mkdir -p ~/Documents/ObsidianVaults/my-course-2026
```

The agent will populate this folder during its first run.

## Step 3 - Install Obsidian and recommended plugins

1. Download Obsidian from [obsidian.md](https://obsidian.md) and open the app.
2. Click *Open folder as vault* → pick your `my-course-2026` folder.
3. Settings → Community plugins → *Turn on community plugins*.
4. Install these plugins (search by name in Community plugins → Browse):
   - **Spaced Repetition** by st3v3nmw - flashcards via `::` syntax. **Critical for exam prep.**
   - **Dataview** - dynamic study dashboards.
   - **Excalidraw** - hand-drawn diagrams (optional).
   - **Advanced Tables** - table editing UX (optional).
   - **Templater** - auto-fill templates with timestamps (optional).

5. Enable each plugin (click the toggle next to its name).

## Step 4 - Run the agent

In your terminal:

```bash
claude
```

Then in the Claude Code session:

```
> I have lecture slides in ~/Downloads/lectures/ and lab notebooks
> in ~/Downloads/labs/. Build me an Obsidian vault for my Machine Learning
> course at ~/Documents/ObsidianVaults/my-course-2026/. The exam is in
> 4 weeks, format is oral. I want detailed lecture notes with worked
> numerical examples.
```

Claude Code will:
1. Detect the request matches the `vaultcraft` agent description
2. Spawn the agent
3. Run Phase 1 - Intake (asking confirming questions)
4. Once you confirm, run Phases 2–8 (extraction → vault generation → quality pass)

Total time: 30–90 minutes depending on source material volume and depth setting.

## Verifying installation

Open a Claude Code session and type:

```
> Show me the vaultcraft agent's description
```

If Claude Code responds with the agent's purpose summary, you're set.

If not, check:
- The file is at `~/.claude/agents/vaultcraft.md`
- File starts with `---` YAML frontmatter
- Restart your Claude Code session

## Troubleshooting

**"PPTX cannot be read"** → install LibreOffice (`brew install --cask libreoffice` on macOS) and confirm `soffice --version` works in terminal.

**"Agent timed out at 40 turns"** → the agent has a `maxTurns: 40` cap. Use `depth: lean` in your initial intake or split the work into incremental runs (the agent's incremental mode preserves config and only adds new content).

**"Hover preview doesn't show definition"** → ensure Obsidian's `Page preview` core plugin is enabled (Settings → Core plugins → Page preview).

**"Graph view shows tag nodes I didn't want"** → Settings → Open graph view → Display → uncheck *Tags*.

See [`usage.md`](usage.md) for typical invocation patterns.
