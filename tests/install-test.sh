#!/usr/bin/env bash
# Installer regression test: runs install.sh against a throwaway HOME and checks it
# never overwrites or deletes files it did not install.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAKE_HOME="$(mktemp -d)"
trap 'rm -rf "${FAKE_HOME}"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }
run() { HOME="${FAKE_HOME}" "${REPO_ROOT}/install.sh" "$@" >/dev/null; }

# A skill the user installed on their own, with the same name as a common Obsidian skill.
mkdir -p "${FAKE_HOME}/.claude/skills/obsidian-markdown"
echo "user's own copy" > "${FAKE_HOME}/.claude/skills/obsidian-markdown/SKILL.md"

run
[ -f "${FAKE_HOME}/.claude/agents/vaultcraft.md" ] || fail "agent not installed"
[ -f "${FAKE_HOME}/.claude/skills/vaultcraft/SKILL.md" ] || fail "front-end skill not installed"
[ -f "${FAKE_HOME}/.claude/skills/vaultcraft/references/principles.md" ] || fail "skill references not installed"
[ -f "${FAKE_HOME}/.claude/skills/vaultcraft/templates/lecture-golden.md" ] || fail "skill templates not installed"
grep -qx "user's own copy" "${FAKE_HOME}/.claude/skills/obsidian-markdown/SKILL.md" || fail "install overwrote a foreign skill"

# Templates go only where asked, and existing files are kept.
mkdir -p "${FAKE_HOME}/tpl"
echo "mine" > "${FAKE_HOME}/tpl/concept.md"
run --templates "${FAKE_HOME}/tpl"
grep -qx "mine" "${FAKE_HOME}/tpl/concept.md" || fail "--templates overwrote an existing template"
[ -f "${FAKE_HOME}/tpl/lab.md" ] || fail "--templates did not copy new templates"
[ ! -e "${FAKE_HOME}/Documents" ] || fail "installer created ~/Documents without being asked"

run --uninstall
[ ! -e "${FAKE_HOME}/.claude/agents/vaultcraft.md" ] || fail "uninstall left the agent"
[ ! -e "${FAKE_HOME}/.claude/skills/vaultcraft" ] || fail "uninstall left the front-end skill"
grep -qx "user's own copy" "${FAKE_HOME}/.claude/skills/obsidian-markdown/SKILL.md" || fail "uninstall deleted a foreign skill"

if HOME="${FAKE_HOME}" "${REPO_ROOT}/install.sh" --bogus >/dev/null 2>&1; then fail "unknown option did not fail"; fi

echo "install.sh: all checks passed"
