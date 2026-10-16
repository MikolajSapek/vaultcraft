#!/usr/bin/env bash
# Build the release zips from tracked files only, so local junk never ships:
#   dist/vaultcraft-<version>.zip         skills-only plugin (claude.ai upload, Claude directory)
#   dist/vaultcraft-<version>-openai.zip  ChatGPT and Codex directory: the same plugin plus the
#                                         optional vaultcraft MCP server (openai/) and review cases
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_ROOT}"
version="$(python3 -c 'import json; print(json.load(open(".claude-plugin/plugin.json"))["version"])')"
out="dist/vaultcraft-${version}.zip"
out_openai="dist/vaultcraft-${version}-openai.zip"
files=(.claude-plugin .codex-plugin agents skills assets README.md LICENSE PRIVACY.md TERMS.md)

mkdir -p dist
rm -f "${out}" "${out_openai}"
git ls-files "${files[@]}" | zip -q -X "${out}" -@
echo "${out} ($(unzip -l "${out}" | tail -1 | awk '{print $2}') files)"

stage="$(mktemp -d)"; trap 'rm -rf "${stage}"' EXIT
git ls-files "${files[@]}" | grep -v -E '^(\.claude-plugin|agents)/' | rsync -a --files-from=- . "${stage}/"
cp openai/mcp.json "${stage}/.mcp.json"
python3 - "${stage}/.codex-plugin/plugin.json" openai/codex-overlay.json <<'PY'
import json, sys
manifest_path, overlay_path = sys.argv[1:]
manifest = json.load(open(manifest_path))
manifest.update(json.load(open(overlay_path)))
json.dump(manifest, open(manifest_path, "w"), indent=2, ensure_ascii=False)
PY
(cd "${stage}" && find . -type f ! -name '.DS_Store' | sed 's#^\./##' | sort | zip -q -X "${REPO_ROOT}/${out_openai}" -@)
echo "${out_openai} ($(unzip -l "${out_openai}" | tail -1 | awk '{print $2}') files)"
