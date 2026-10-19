#!/usr/bin/env node
// Diagram goal check: every ```mermaid block in the vault must parse with Pele
// (https://pele.run, the Mermaid renderer built for Obsidian) and use only
// diagram types today's Obsidian (Mermaid 11.13) also draws.
// Usage: node check_diagrams.mjs <vault>   exit 0 = DONE, 1 = problems listed.
import { readdirSync, readFileSync, existsSync } from 'node:fs';
import { join, relative, dirname } from 'node:path';
import { execFileSync } from 'node:child_process';
import { fileURLToPath, pathToFileURL } from 'node:url';

const PELE_VERSION = '1.6.0';
// Pele parses these, Obsidian's bundled Mermaid 11.13 does not: blank box in the vault.
const PELE_ONLY = /^(swimlane-beta|agentflow-beta|railroad(-\w+)?-beta|treeView-beta|cynefin-beta|wardley-beta|eventmodeling|usecase-beta)\b/;

async function loadPele() {
  try {
    return await import('pele');
  } catch {
    // ponytail: private install next to the script, so the skill needs no package.json
    const prefix = join(dirname(fileURLToPath(import.meta.url)), '.pele');
    const entry = join(prefix, 'node_modules', 'pele', 'package.json');
    if (!existsSync(entry)) {
      execFileSync('npm', ['install', '--silent', '--prefix', prefix, `pele@${PELE_VERSION}`], { stdio: 'inherit' });
    }
    const pkg = JSON.parse(readFileSync(entry, 'utf8'));
    const main = pkg.exports?.['.']?.import ?? pkg.exports?.['.']?.default ?? pkg.module ?? pkg.main;
    return import(pathToFileURL(join(prefix, 'node_modules', 'pele', typeof main === 'string' ? main : main.default)).href);
  }
}

function* markdownFiles(dir) {
  for (const e of readdirSync(dir, { withFileTypes: true })) {
    if (e.name.startsWith('.')) continue;
    const p = join(dir, e.name);
    if (e.isDirectory()) yield* markdownFiles(p);
    else if (e.name.endsWith('.md')) yield p;
  }
}

function* mermaidBlocks(text) {
  const lines = text.split('\n');
  for (let i = 0; i < lines.length; i++) {
    const open = lines[i].match(/^(\s*(?:>\s*)*)(`{3,}|~{3,})\s*mermaid\s*$/);
    if (!open) continue;
    const [, prefix, fence] = open;
    const body = [];
    let j = i + 1;
    for (; j < lines.length && !lines[j].slice(prefix.length).trimStart().startsWith(fence); j++) {
      body.push(lines[j].slice(prefix.length));
    }
    yield { line: i + 1, source: body.join('\n') };
    i = j;
  }
}

function firstKeyword(source) {
  return source.split('\n').map((l) => l.trim())
    .find((l) => l && !l.startsWith('%%') && l !== '---') ?? '';
}

async function main() {
  const vault = process.argv[2];
  if (!vault || !existsSync(vault)) {
    console.error('usage: node check_diagrams.mjs <vault>');
    process.exit(2);
  }
  const { parse } = await loadPele();
  const problems = [];
  let count = 0;
  for (const file of markdownFiles(vault)) {
    for (const { line, source } of mermaidBlocks(readFileSync(file, 'utf8'))) {
      count++;
      const where = `${relative(vault, file)}:${line}`;
      if (PELE_ONLY.test(firstKeyword(source))) {
        problems.push(`${where} type "${firstKeyword(source)}" is Pele-only, Obsidian shows nothing`);
      }
      if (/themeVariables/.test(source)) {
        problems.push(`${where} themeVariables: Pele ignores them, colour comes from --pele-* CSS`);
      }
      try {
        parse(source);
      } catch (e) {
        const at = e.line ? ` (diagram line ${e.line})` : '';
        problems.push(`${where} ${e.code ?? 'error'}${at}: ${String(e.message).split('\n').pop()}`);
      }
    }
  }
  problems.forEach((p) => console.log(p));
  console.log(problems.length ? `${problems.length} problem(s) in ${count} diagram(s)` : `DONE: ${count} diagram(s) OK`);
  process.exit(problems.length ? 1 : 0);
}

main();
