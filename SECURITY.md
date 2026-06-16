# Security Policy

vaultcraft is a local-first Claude Code agent for building Obsidian vaults from user-provided materials. The main security-sensitive areas are installer behaviour, filesystem access, source document handling, and MCP/Obsidian integration.

## Supported Versions

| Version | Supported |
|---|---|
| `main` | Yes |
| `v0.1.x` | Best effort |

## Reporting a Vulnerability

Please report security issues by opening a private security advisory on GitHub if available. If that is not available for your fork or account, open a minimal public issue that avoids exploit details and marks the issue as security-related.

Include:

- affected version or commit
- operating system
- whether the issue involves `install.sh`, MCP configuration, generated vault files, or source material handling
- minimal reproduction steps using synthetic files only
- expected and actual behaviour

Do not include real course material, private vault notes, API keys, local usernames, or MCP tokens.

## Security Review Scope

Security reviews focus on:

- shell commands in `install.sh`
- path handling and writes outside the target vault
- source document copying, conversion, and cleanup
- accidental exposure of private notes or source materials in examples
- agent instructions that could overwrite user files without confirmation
- MCP setup documentation that could encourage unsafe credential handling

## Maintainer Response

For confirmed vulnerabilities, maintainers aim to:

1. acknowledge the report within 7 days
2. reproduce the issue using synthetic files
3. prepare the smallest fix that addresses the root cause
4. document any user-facing mitigation in `CHANGELOG.md`

## AI-Assisted Security Work

Maintainers may use Codex to review installer changes, reason about filesystem edge cases, generate synthetic repro fixtures, and check documentation for unsafe setup instructions. All AI-assisted changes must be manually reviewed before merge.
