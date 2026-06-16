# Codex-Assisted Maintenance

vaultcraft is maintained as a small open-source project with AI assistance used for review, verification, and repetitive maintenance work. Codex is a maintainer tool, not an automatic committer: all generated changes must be reviewed by a human before merge.

## Where Codex Helps

Codex is useful for:

- reviewing changes to `agents/vaultcraft.md` for broken phase numbering, inconsistent principles, and unsafe file operations
- checking `install.sh` changes for shell portability, path handling, and uninstall safety
- drafting synthetic fixtures for demo materials and generated vault validation
- updating documentation when behaviour changes
- triaging issues into bug reports, feature requests, course recipes, or setup questions
- suggesting tests and manual verification steps for pull requests

## Required Human Review

Before merging AI-assisted work, maintainers should verify:

- the diff is scoped to the issue or PR
- no private source material, vault content, API keys, or local usernames were added
- installer changes do not write outside documented locations
- prompt changes preserve the intended phase order and numbered principles
- generated examples are synthetic or clearly anonymised
- docs describe behaviour that actually exists

## Suggested Review Prompt

Use a prompt like this when asking Codex to review a PR:

```text
Review this vaultcraft change as an OSS maintainer. Prioritise bugs,
unsafe filesystem behaviour, privacy leaks, broken documentation claims,
and missing verification. Do not rewrite the project; report concrete
findings with file and line references.
```

## Suggested Security Prompt

Use a prompt like this for installer or filesystem changes:

```text
Review this change for local filesystem security. Focus on path traversal,
unexpected writes outside the target vault, unsafe cleanup, shell quoting,
secrets exposure, and whether user confirmation is required before any
destructive operation.
```

## Issue Triage

Codex can help classify new issues, but maintainers should make the final call:

| Issue type | Maintainer check |
|---|---|
| Bug report | Can it be reproduced with synthetic input? |
| Feature request | Does it fit one of the supported vault types? |
| Course recipe | Is the example anonymised? |
| Security report | Does it involve file writes, secrets, MCP config, or private material? |
| Setup question | Is the answer already covered in `docs/installation.md` or `docs/faq.md`? |

## Pull Request Checklist

AI-assisted pull requests should state what was generated or reviewed by Codex and what was checked manually. The PR template includes a dedicated section for this so reviewers can separate tool output from maintainer judgement.
