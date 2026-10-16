# Privacy policy

vaultcraft is a set of instructions for an AI assistant (Claude, ChatGPT, Codex or Cursor). The plugin itself has no account, no telemetry and no analytics. The ChatGPT and Codex directory version can also use an optional server, described below. The author receives no other data from anyone who uses it.

## What it reads

Only the files, folders and attachments you point it at. These can contain personal data, for example names in meeting notes. vaultcraft does not look for personal data and does not treat it differently.

## What it writes

Notes, `.obsidian/` settings and copies of your sources, only inside the vault folder you chose. In a sandbox (claude.ai chat, ChatGPT) it gives you the vault as a zip file instead. Nothing is written anywhere else.

## What leaves your machine

- Web search queries, made with your assistant's own web tool, to fill gaps in a concept. Your files are not sent.
- Whatever your assistant provider (Anthropic, OpenAI or Cursor) processes to run the conversation, under that provider's own privacy policy.
- Only in the ChatGPT and Codex directory version: requests to the optional vaultcraft server, below.

vaultcraft sends nothing to any other service.

## Optional vaultcraft server (ChatGPT and Codex directory version only)

The Claude and Cursor versions, and installs from GitHub, do not connect to this server unless you add it to your assistant yourself.

- **What it receives.** For `get_vault_config` and `get_note_template`: the vault type, a language code and a template name. For `check_vault`: the paths and Markdown text of the notes the assistant passes in, and the names of attachment files. Notes can contain whatever personal data your materials contain.
- **Why.** Only to return the requested settings, template or link report in the same request.
- **Retention.** None. Each request is processed in memory and discarded when the response is sent. The server has no database, writes no files and does not log request bodies. The only log is of failed requests (method and path, nothing else), kept in a rotating 2 MB file.
- **Recipients.** Nobody. The server runs on the author's own machine behind Cloudflare, which carries the traffic to it under [Cloudflare's privacy policy](https://www.cloudflare.com/privacypolicy/). No data is sold or shared.
- **Your control.** Don't connect the server, or ask the assistant not to call `check_vault`. The plugin works without it.

## Retention

The plugin retains no data. The vault stays on your disk, or in the zip you downloaded, until you delete it.

## Contact

Open an issue at <https://github.com/MikolajSapek/vaultcraft/issues>.
