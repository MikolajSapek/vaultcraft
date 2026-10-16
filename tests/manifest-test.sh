#!/usr/bin/env bash
# Manifest and directory-rule checks: versions agree across the Claude and Codex
# manifests, every file the skill points to exists, and the repo stays inside the
# limits the Claude and OpenAI plugin directories enforce.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_ROOT}"
fail() { echo "FAIL: $*" >&2; exit 1; }
json() { python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print(eval(sys.argv[2]))" "$@"; }

v_claude="$(json .claude-plugin/plugin.json 'd["version"]')"
v_market="$(json .claude-plugin/marketplace.json 'd["plugins"][0]["version"]')"
v_codex="$(json .codex-plugin/plugin.json 'd["version"]')"
[ "${v_claude}" = "${v_market}" ] && [ "${v_claude}" = "${v_codex}" ] \
  || fail "versions differ: claude ${v_claude}, marketplace ${v_market}, codex ${v_codex}"
grep -q "^## \[${v_claude}\]" CHANGELOG.md || fail "CHANGELOG has no entry for ${v_claude}"

for key in logo composerIcon; do
  f="$(json .codex-plugin/plugin.json "d['interface']['${key}']")"
  [ -f "${f}" ] || fail "codex ${key} ${f} missing"
done
json .agents/plugins/marketplace.json 'd["plugins"][0]["name"]' | grep -qx vaultcraft || fail "codex marketplace entry missing"

skill=skills/vaultcraft
while IFS= read -r ref; do
  [ -f "${skill}/${ref}" ] || fail "SKILL.md points to missing ${ref}"
done < <(grep -o -E '(references|templates)/[a-z0-9.-]+\.md' "${skill}/SKILL.md" "${skill}"/references/*.md | cut -d: -f2 | sort -u)

desc="$(sed -n 's/^description: //p' "${skill}/SKILL.md")"
case "${desc}" in *"<"*|*">"*) fail "SKILL.md description contains angle brackets" ;; esac
[ "${#desc}" -le 1024 ] || fail "SKILL.md description over 1024 characters"

[ -z "$(git ls-files | grep -E '(^|/)(\.DS_Store|Thumbs\.db|desktop\.ini|__MACOSX)')" ] || fail "OS junk files tracked"
while IFS= read -r f; do
  case "${f}" in *.png|*.jpg|*.jpeg|*.gif|*.webp) continue ;; esac
  [ "$(wc -c < "${f}")" -le 262144 ] || fail "${f} is over 256 KiB"
done < <(git ls-files)
[ "$(git ls-files | wc -l)" -le 512 ] || fail "more than 512 files"

tmp_agent="$(mktemp)"; trap 'rm -f "${tmp_agent}"' EXIT
./scripts/build-agent.sh "${tmp_agent}"
cmp -s "${tmp_agent}" agents/vaultcraft.md || fail "agents/vaultcraft.md is stale: run ./scripts/build-agent.sh"

echo "manifests: all checks passed (version ${v_claude})"
