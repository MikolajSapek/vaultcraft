# Installation

## Requirements

- **[Claude Code](https://claude.com/claude-code)** - the official CLI from Anthropic. Free trial available; paid tier needed for sustained use. Run from a terminal; the agent prints status banners and progress lines that read better there than in the desktop chat UI.
- **[Obsidian](https://obsidian.md)** - free, available for Mac, Windows, Linux, iOS, Android.
- **Python 3** (already on macOS/Linux) - for some helper scripts during vault generation.
- **LibreOffice** (only if you have `.pptx` slides) - `brew install --cask libreoffice` on macOS, used to convert PPTX → PDF.

## Step 1 - Install the agent

**Recommended: as a Claude Code plugin** (macOS, Linux and Windows). In Claude Code:

```text
/plugin marketplace add MikolajSapek/vaultcraft
/plugin install vaultcraft@vaultcraft
```

Optional but recommended, the official Obsidian skills by Steph Ango ([kepano/obsidian-skills](https://github.com/kepano/obsidian-skills), MIT):

```text
/plugin marketplace add kepano/obsidian-skills
/plugin install obsidian@obsidian-skills
```

The agent falls back to its own tools when these skills are missing. See [`skills/README.md`](../skills/README.md) for what each one adds.

**Alternative: the install script** (macOS and Linux):

```bash
git clone https://github.com/MikolajSapek/vaultcraft.git
cd vaultcraft
./install.sh
```

It copies only `agents/vaultcraft.md` and `skills/vaultcraft/SKILL.md` into `~/.claude/`, records them in `~/.claude/.vaultcraft-installed`, and leaves every other skill and agent alone. `./install.sh --uninstall` removes exactly those files.

Verify Claude Code sees the agent:

```bash
ls ~/.claude/agents/ | grep vaultcraft
# vaultcraft.md
```

Plugin installs show up under `/plugin` instead.

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

```text
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

```text
> Show me the vaultcraft agent's description
```

If Claude Code responds with the agent's purpose summary, you're set.

If not, check:

- The file is at `~/.claude/agents/vaultcraft.md`
- File starts with `---` YAML frontmatter
- Restart your Claude Code session

## Troubleshooting

**"PPTX cannot be read"** → install LibreOffice (`brew install --cask libreoffice` on macOS) and confirm `soffice --version` works in terminal.

**"The agent stopped with a partial result"** → a run is capped at 150 turns (`maxTurns: 150`). Say *continue*: the agent resumes from `.vault-progress.md`. For very large courses, `depth: lean` or splitting the work into incremental runs also helps.

**"Hover preview doesn't show definition"** → ensure Obsidian's `Page preview` core plugin is enabled (Settings → Core plugins → Page preview).

**"Graph view shows tag nodes I didn't want"** → Settings → Open graph view → Display → uncheck *Tags*.

See [`usage.md`](usage.md) for typical invocation patterns.
