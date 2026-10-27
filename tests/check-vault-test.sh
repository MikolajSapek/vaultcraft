#!/usr/bin/env bash
# Goal-check regression test: builds a tiny vault and checks every rule of
# skills/vaultcraft/scripts/check_vault.py, then fixes it and expects DONE.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHECK="${REPO_ROOT}/skills/vaultcraft/scripts/check_vault.py"
V="$(mktemp -d)"
trap 'rm -rf "${V}"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }

mkdir -p "${V}/Concepts" "${V}/Lectures" "${V}/.vaultcraft/extract" "${V}/Assets"
cat > "${V}/.vaultcraft/extract/L01.md" <<'MD'
# L01
## Named items
- TF-IDF (slide 4)
- Bag of Words (slide 2)
- Zipf's law (slide 9)
MD
cat > "${V}/Concepts/TF-IDF.md" <<'MD'
---
tags: [concept]
source: "[[L01 - Intro]]"
---
> [!definition] TF-IDF
> Weights a word by how rare it is.

Builds on [[Bag of Word]]. `[[Ignored]]`
MD
cat > "${V}/Concepts/Bag of Words.md" <<'MD'
---
tags: [concept]
aliases: [BoW]
---
> [!definition] Bag of Words
> Counts words.

> [!example] Example
> two words

See [[tf-idf]] and [[L01 - Intro]]. | [[TF-IDF\|weights]] | ![[slides.pdf#page=2]]
MD
echo "First lecture. [[BoW]]" > "${V}/Lectures/L01 - Intro.md"
touch "${V}/Assets/slides.pdf"

out="$(python3 "${CHECK}" "${V}" --json || true)"
get() { python3 -c "import json,sys; print(json.dumps(json.loads(sys.argv[1])[sys.argv[2]]))" "${out}" "$1"; }
[ "$(get done)" = false ] || fail "unfinished vault reported done"
[ "$(get broken_links)" = '[{"note": "Concepts/TF-IDF.md", "target": "Bag of Word"}]' ] || fail "broken links: $(get broken_links)"
[ "$(get coverage_missing)" = '["Zipf'"'"'s law (L01.md)"]' ] || fail "coverage: $(get coverage_missing)"
[ "$(get missing_example)" = '["TF-IDF"]' ] || fail "missing example: $(get missing_example)"
[ "$(get lecture_misses_concept)" = '["L01 - Intro -> TF-IDF"]' ] || fail "lecture backlinks: $(get lecture_misses_concept)"
[ "$(get missing_visual)" = '["Bag of Words", "TF-IDF", "L01 - Intro"]' ] || fail "missing visual: $(get missing_visual)"
python3 "${CHECK}" "${V}" >/dev/null && fail "exit code 0 for an unfinished vault"

# Fix everything; the goal must now be met.
printf -- '---\ntags: [concept]\nsource: "[[L01 - Intro]]"\n---\n> [!definition] TF-IDF\n> Weights a word by how rare it is.\n\n> [!example] Example\n> rare words\n\n```mermaid\npie\n  "rare" : 1\n  "common" : 9\n```\n\nBuilds on [[Bag of Words]] and [[Zipf'"'"'s law]].\n' > "${V}/Concepts/TF-IDF.md"
printf -- '---\ntags: [concept]\n---\n> [!definition] Zipf'"'"'s law\n> Word frequency falls with rank.\n\n> [!example] Example\n> the, of\n\n![[zipf.svg]]\n\n[[TF-IDF]] [[BoW]]\n' > "${V}/Concepts/Zipf's law.md"
printf 'First lecture. [[BoW]] [[TF-IDF]]\n\n![[l01-p04.png|560]]\n' > "${V}/Lectures/L01 - Intro.md"
touch "${V}/Assets/l01-p04.png" "${V}/Assets/zipf.svg"
printf '\n```mermaid\nflowchart LR\n  A[Words] --> B[Counts]\n```\n' >> "${V}/Concepts/Bag of Words.md"
python3 "${CHECK}" "${V}" >/dev/null || { python3 "${CHECK}" "${V}"; fail "fixed vault not reported done"; }

echo "check_vault.py: all checks passed"
