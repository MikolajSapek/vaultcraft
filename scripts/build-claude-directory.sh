#!/usr/bin/env bash
# Build claude-directory/ = the instructions-only plugin for the Claude plugin directory (claude.ai/directory/manage,
# path "claude-directory"). Unverified organisations may ship only Markdown, text, JSON, YAML and PNG/JPEG/GIF/WebP/ICO,
# no file starting with #!, so the scripts stay out and the skill falls back to references/goal-checks.md.
# The repo root stays the full plugin (Claude Code marketplace, Codex, Cursor). tests/manifest-test.sh fails when the
# folder is stale or holds a file type the directory refuses.
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="${1:-${REPO_ROOT}/claude-directory}"
rm -rf "${out}"
mkdir -p "${out}/.claude-plugin"
cp "${REPO_ROOT}/.claude-plugin/plugin.json" "${REPO_ROOT}/.claude-plugin/icon.png" "${out}/.claude-plugin/"
cd "${REPO_ROOT}"
git ls-files -- skills agents | grep -v '^skills/vaultcraft/scripts/' | while read -r f; do
  mkdir -p "${out}/$(dirname "${f}")"
  cp "${f}" "${out}/${f}"
done
cp LICENSE PRIVACY.md "${out}/"
cp scripts/directory-readme.md "${out}/README.md"
