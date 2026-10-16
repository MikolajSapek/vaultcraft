# Publishing vaultcraft to the plugin directories

vaultcraft ships as one plugin for two directories:

- **Claude directory**: people add it on claude.ai, in the desktop app, in Cowork and in Claude Code.
- **ChatGPT and Codex plugin directory**: people add it from the Plugins tab in ChatGPT and with `/plugins` in Codex.

Both directories review every submission. Neither guarantees a listing.

## Before either submission

1. Merge the release branch to `main` and tag it (`git tag v<version> && git push origin main --tags`). Both directories read the public default branch.
2. Run the local checks:

   ```bash
   ./tests/manifest-test.sh
   ./tests/install-test.sh
   claude plugin validate --strict .
   ./scripts/package.sh            # builds dist/vaultcraft-<version>.zip
   ```

3. Test the sandbox surfaces by hand. Claude Code and Codex are covered by the end-to-end runs; claude.ai chat and ChatGPT are not:
   - claude.ai: **Customize > Plugins > Add > Upload plugin** with `dist/vaultcraft-<version>.zip`, attach the files from `examples/demo-materials/`, ask for a vault, and check that you get a zip that opens in Obsidian.
   - ChatGPT desktop app: add this repo as a marketplace, install vaultcraft, and run the same demo.
4. Update the GitHub repository description so it matches the README. Flashcards are optional, off by default.

## Claude directory

Requires a paid claude.ai plan (Pro or Max: submit from your own account) and your GitHub account connected on claude.ai.

1. Open [claude.ai/directory/manage](https://claude.ai/directory/manage), select **Submit new**, then **Plugin bundle**.
2. **Source**: repository `MikolajSapek/vaultcraft`, plugin path empty (the plugin is the repo root), branch `main`. Select **Validate** and fix every finding marked **Blocking**.
3. **Listing details** come from `.claude-plugin/plugin.json` and `README.md`. To change them, edit those files, push, and validate again.
4. **Data handling**: suggested answers.
   - Reads or stores personal data: it reads only the files the user points it at, and writes only into the vault folder the user chose. Nothing is stored anywhere else.
   - Sends data to other services: no. The only outbound traffic is web searches made with the assistant's own web tool to fill gaps in a concept. The user's files are not sent anywhere.
   - Retention: none. vaultcraft keeps no data of its own.
   - Intended for people under 18: no.
5. **Compliance**: check the contact email and tick the four acknowledgements.
6. **Review and submit**: keep **GitHub push webhook**, then **Submit for review**, then **Set up push updates**.
7. When the version passes, select **Publish** on the plugin page.

Later releases: raise `version` in all three manifests (the manifest test enforces it), merge to `main`, and the directory picks the commit up.

## ChatGPT and Codex plugin directory

OpenAI is not accepting skills-only plugins (2026-10-16), so this listing ships with the optional vaultcraft MCP server (code: [MikolajSapek/vaultcraft-mcp](https://github.com/MikolajSapek/vaultcraft-mcp), endpoint `https://vaultcraft.sapcorp.eu/mcp`). The server config and the review test cases live in `openai/` and go only into the OpenAI zip, so Claude and Cursor installs never connect to it.

Requires an OpenAI Platform organisation where you are owner or have **Apps Management Write**, completed individual or business verification, and a project with global (not EU) data residency.

1. Deploy the server and check `https://vaultcraft.sapcorp.eu/healthz` answers `ok`.
2. Run `./scripts/package.sh` and keep `dist/vaultcraft-<version>-openai.zip`.
3. Open [Plugins](https://platform.openai.com/plugins), select **Upload new or existing plugin**, pick your verified identity and upload the zip.
4. **MCPs**: select `vaultcraft`, then **Connect**, authentication **None**. Put the domain-verification token in the server's `.env` as `OPENAI_APPS_CHALLENGE`, restart it, and finish verification. Wait for the tool scan.
5. **Review details**: the five positive and three negative test cases come from the zip. Add the video walkthrough URL (record the test cases in ChatGPT).
6. Resolve findings, complete the policy attestations and submit. Feedback arrives by email; only one review per plugin can be open at a time.

## Without a directory listing

These work as soon as `main` is pushed:

```text
# Claude Code
/plugin install vaultcraft --marketplace MikolajSapek/vaultcraft

# Codex CLI
codex plugin marketplace add MikolajSapek/vaultcraft
codex plugin add vaultcraft@vaultcraft
```

On claude.ai, attach `dist/vaultcraft-<version>.zip` to the GitHub release; users add it with **Customize > Plugins > Add > Upload plugin**.
