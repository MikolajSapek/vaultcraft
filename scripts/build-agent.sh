#!/usr/bin/env bash
# Build agents/vaultcraft.md = scripts/agent-header.md + the skill's reference files.
# The skill is the single source of truth; the agent carries the same text in its
# system prompt so it never has to find and read the references at run time.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
refs="${REPO_ROOT}/skills/vaultcraft/references"
out="${1:-${REPO_ROOT}/agents/vaultcraft.md}"

{
  cat "${REPO_ROOT}/scripts/agent-header.md"
  for f in principles phase-0-1-intake phase-2-3-extract phase-4-notes \
           phase-5-lectures phase-6-9-finish operations; do
    echo
    tail -n +3 "${refs}/${f}.md"   # drop the file's own H1 title and blank line
  done
} > "${out}"
