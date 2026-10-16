#!/usr/bin/env bash
# Build dist/vaultcraft-<version>.zip: the plugin folder for claude.ai
# (Customize > Plugins > Upload plugin) and for the OpenAI plugin submission.
# Only tracked files go in, so local junk never ships.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_ROOT}"
version="$(python3 -c 'import json; print(json.load(open(".claude-plugin/plugin.json"))["version"])')"
out="dist/vaultcraft-${version}.zip"

mkdir -p dist
rm -f "${out}"
git ls-files .claude-plugin .codex-plugin agents skills assets README.md LICENSE PRIVACY.md | zip -q -X "${out}" -@
echo "${out} ($(unzip -l "${out}" | tail -1 | awk '{print $2}') files)"
