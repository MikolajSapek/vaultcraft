#!/usr/bin/env python3
"""vaultcraft goal check: is the vault done?

Runs locally (Claude Code, Codex, Cursor, the ChatGPT and claude.ai sandboxes) with the
standard library only. It checks the vault the way Obsidian resolves links and measures
the goal written at the start of a run:

  coverage  every named item in .vaultcraft/extract/*.md has a note (by name or alias)
  links     no broken [[wikilinks]], no orphan notes
  concepts  each concept note has a definition callout (<= 200 chars) and an example,
            and links to at least 2 other notes
  lectures  each lecture lists the concepts that name it as their source
  visuals   every concept and lecture note has a visual: a ```mermaid block (Pele) or an
            embedded image (extracted slide/figure)

Usage:  python3 check_vault.py <vault> [--json]
Exit code 0 when the goal is met, 1 when something is left to do.
"""
import json
import os
import re
import sys

NAV_NOTES = {"00 - start here", "readme_plugins", "01 - course map", "tables"}
DEFINITION_MAX = 200
LIST_CAP = 50
SKIP_DIRS = {".obsidian", ".vaultcraft", ".trash", ".git"}

VISUAL_RE = re.compile(r"^```mermaid|!\[\[[^\]]+\.(?:png|jpe?g|gif|svg|webp)(?:\|[^\]]*)?\]\]|!\[[^\]]*\]\([^)]+\.(?:png|jpe?g|gif|svg|webp)\)", re.M | re.I)
LINK_RE = re.compile(r"(!?)\[\[([^\]|#^]+)(?:[|#^][^\]]*)?\]\]")


def key(name):
    return name.strip().lower()


def base_name(path):
    name = os.path.basename(path)
    return name[:-3] if name.lower().endswith(".md") else name


def strip_code(text):
    return re.sub(r"`[^`\n]*`", "", re.sub(r"```.*?```", "", text, flags=re.S))


def frontmatter(text):
    m = re.match(r"^---\r?\n(.*?)\r?\n---", text, re.S)
    return m.group(1) if m else ""


def aliases(fm):
    m = re.search(r"^aliases:\s*\[(.*?)\]", fm, re.M)
    if m:
        return [a.strip().strip("\"'") for a in m.group(1).split(",") if a.strip()]
    block = re.search(r"^aliases:\s*\n((?:\s*-\s*.+\n?)+)", fm, re.M)
    return [a.strip().lstrip("-").strip().strip("\"'") for a in block.group(1).splitlines()] if block else []


def is_concept(fm):
    return bool(re.search(r"^tags:.*\bconcept\b", fm, re.M) or re.search(r"^\s*-\s*concept\s*$", fm, re.M))


def definition(text):
    m = re.search(r"^>\s*\[!definition\][^\n]*\n((?:>[^\n]*\n?)+)", text, re.M | re.I)
    return re.sub(r"^>\s?", "", m.group(1), flags=re.M).strip() if m else None


def is_lecture(path, fm):
    return "Lectures" in path.replace(os.sep, "/").split("/")[:-1] or bool(re.search(r"^tags:.*lecture", fm, re.M))


def has_example(text):
    return bool(re.search(r"^>\s*\[!example\]", text, re.M | re.I) or re.search(r"^#{2,4}\s+.*example", text, re.M | re.I))


def read_vault(root):
    notes, files = {}, set()
    for d, dirs, fs in os.walk(root):
        dirs[:] = [x for x in dirs if x not in SKIP_DIRS]
        for f in fs:
            rel = os.path.relpath(os.path.join(d, f), root)
            files.add(key(f))
            files.add(key(os.path.splitext(f)[0]))
            files.add(key(rel))
            if f.lower().endswith(".md"):
                with open(os.path.join(d, f), encoding="utf-8", errors="replace") as fh:
                    notes[rel] = fh.read()
    return notes, files


def named_items(root):
    """Items listed under '## Named items' in the extraction files."""
    items = []
    folder = os.path.join(root, ".vaultcraft", "extract")
    if not os.path.isdir(folder):
        return items
    for f in sorted(os.listdir(folder)):
        if not f.endswith(".md"):
            continue
        with open(os.path.join(folder, f), encoding="utf-8", errors="replace") as fh:
            section = re.search(r"^## Named items\s*\n(.*?)(?=^## |\Z)", fh.read(), re.M | re.S)
        for line in (section.group(1).splitlines() if section else []):
            m = re.match(r"\s*[-*]\s+(.+?)(?:\s+[(—-]\s*(?:slide|page|p\.|cell).*)?$", line, re.I)
            if m:
                items.append((m.group(1).strip().strip("*`"), f))
    return items


def check(root):
    notes, files = read_vault(root)
    paths = sorted(notes)
    # Two notes can share a name in different folders; both checks resolve to the first path.
    by_key, alias_keys = {}, {}
    for p in paths:
        by_key.setdefault(key(base_name(p)), p)
    for p in paths:
        for a in aliases(frontmatter(notes[p])):
            alias_keys.setdefault(key(a), p)

    inbound = {p: 0 for p in paths}
    outbound = {}
    broken = []
    for path in paths:
        linked, seen = set(), set()
        for embed, raw in LINK_RE.findall(strip_code(notes[path])):
            raw = raw.rstrip("\\").strip()
            target = by_key.get(key(base_name(raw))) or alias_keys.get(key(raw))
            if target:
                if target != path:
                    linked.add(target)
            elif key(raw) not in files and key(os.path.basename(raw)) not in files and raw not in seen:
                seen.add(raw)
                broken.append({"note": path, "target": raw})
        outbound[path] = linked
        for t in linked:
            inbound[t] += 1

    orphans = [base_name(p) for p, c in inbound.items() if c == 0 and key(base_name(p)) not in NAV_NOTES]
    gaps = {"missing_definition": [], "long_definition": [], "missing_example": [], "under_2_links": [], "lecture_misses_concept": [], "missing_visual": []}
    for path in paths:
        text = notes[path]
        fm = frontmatter(text)
        if (is_concept(fm) or is_lecture(path, fm)) and not VISUAL_RE.search(text):
            gaps["missing_visual"].append(base_name(path))
        if not is_concept(fm):
            continue
        name = base_name(path)
        d = definition(text)
        if d is None:
            gaps["missing_definition"].append(name)
        elif len(d) > DEFINITION_MAX:
            gaps["long_definition"].append(name)
        if not has_example(text):
            gaps["missing_example"].append(name)
        if len(outbound[path]) < 2:
            gaps["under_2_links"].append(name)
        m = re.search(r"^source:\s*[\"']?\[\[([^\]|#]+)", fm, re.M)
        lecture = by_key.get(key(m.group(1))) if m else None
        if lecture and path not in outbound.get(lecture, set()):
            gaps["lecture_misses_concept"].append(f"{base_name(lecture)} -> {name}")

    known = set(by_key) | set(alias_keys)
    norm = lambda s: re.sub(r"[^a-z0-9]+", "", s.lower())
    known_norm = {norm(k) for k in known}
    uncovered = [f"{item} ({src})" for item, src in named_items(root)
                 if key(item) not in known and norm(item) not in known_norm]

    result = {
        "notes": len(notes),
        "coverage_missing": uncovered,
        "broken_links": broken,
        "orphan_notes": orphans,
        **gaps,
    }
    result["done"] = not any(v for k, v in result.items() if isinstance(v, list))
    return result


def report(r):
    rows = [(k, len(v)) for k, v in r.items() if isinstance(v, list)]
    lines = [f"Goal check: {r['notes']} notes - {'DONE' if r['done'] else 'NOT DONE'}"]
    lines += [f"  {k.replace('_', ' '):<24}{n}" for k, n in rows]
    for k, v in r.items():
        if isinstance(v, list) and v:
            lines.append(f"{k}:")
            lines += [f"  - {json.dumps(x, ensure_ascii=False) if isinstance(x, dict) else x}" for x in v[:LIST_CAP]]
    return "\n".join(lines)


def main(argv):
    if len(argv) < 2 or not os.path.isdir(argv[1]):
        print("usage: check_vault.py <vault> [--json]", file=sys.stderr)
        return 2
    r = check(argv[1])
    print(json.dumps(r, ensure_ascii=False, indent=1) if "--json" in argv else report(r))
    return 0 if r["done"] else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
