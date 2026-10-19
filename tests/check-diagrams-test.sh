#!/usr/bin/env bash
# Diagram goal check: a broken, a Pele-only and a themed block fail; fixed vault passes.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHECK="${REPO_ROOT}/skills/vaultcraft/scripts/check_diagrams.mjs"
V="$(mktemp -d)"
trap 'rm -rf "${V}"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }

mkdir -p "${V}/Concepts"
cat > "${V}/Concepts/Bad.md" <<'MD'
```mermaid
flowchart LR
  A -->
```

> [!example] Picture it
> ```mermaid
> wardley-beta
> title Map
> ```

```mermaid
%%{init: {"themeVariables": {"primaryColor": "#f00"}}}%%
pie
  "a" : 1
```
MD

out="$(node "${CHECK}" "${V}" || true)"
grep -q 'Bad.md:1 syntax' <<<"${out}" || fail "syntax error not reported: ${out}"
grep -q 'Bad.md:7 type "wardley-beta" is Pele-only' <<<"${out}" || fail "Pele-only type not reported: ${out}"
grep -q 'Bad.md:12 themeVariables' <<<"${out}" || fail "themeVariables not reported: ${out}"

cat > "${V}/Concepts/Bad.md" <<'MD'
```mermaid
xychart
  x-axis [2024, 2025, 2026]
  bar [3, 5, 8]
```
MD
node "${CHECK}" "${V}" | grep -q 'DONE: 1 diagram' || fail "valid chart rejected"
echo "check-diagrams-test: OK"
