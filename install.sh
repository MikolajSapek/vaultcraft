#!/usr/bin/env bash
set -euo pipefail

# vaultcraft installer (manual install; the Claude Code plugin is the recommended route)
# Usage:
#   ./install.sh                      install the agent + front-end skill into ~/.claude/
#   ./install.sh --templates DIR      also copy note templates into DIR (never overwrites)
#   ./install.sh --demo               install + show how to run the bundled NLP demo
#   ./install.sh --uninstall          remove only the files this installer put there

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
AGENTS_DIR="${CLAUDE_DIR}/agents"
SKILLS_DIR="${CLAUDE_DIR}/skills"
MANIFEST="${CLAUDE_DIR}/.vaultcraft-installed"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
RESET='\033[0m'

banner() {
  cat <<'EOF'
██╗   ██╗ █████╗ ██╗   ██╗██╗  ████████╗ ██████╗██████╗  █████╗ ███████╗████████╗
██║   ██║██╔══██╗██║   ██║██║  ╚══██╔══╝██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
██║   ██║███████║██║   ██║██║     ██║   ██║     ██████╔╝███████║█████╗     ██║
╚██╗ ██╔╝██╔══██║██║   ██║██║     ██║   ██║     ██╔══██╗██╔══██║██╔══╝     ██║
 ╚████╔╝ ██║  ██║╚██████╔╝███████╗██║   ╚██████╗██║  ██║██║  ██║██║        ██║
  ╚═══╝  ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝    ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝
                  obsidian study vault builder · installer
EOF
}

# Copy one file and record it in the manifest, so uninstall removes only what we installed.
install_file() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "${dest}")"
  cp "${src}" "${dest}"
  grep -qxF "${dest}" "${MANIFEST}" 2>/dev/null || echo "${dest}" >> "${MANIFEST}"
}

install_files() {
  mkdir -p "${CLAUDE_DIR}"
  touch "${MANIFEST}"

  echo -e "${BLUE}→${RESET} Installing agents (vaultcraft + Haiku/Sonnet workers) to ${AGENTS_DIR}/"
  local agent
  for agent in "${REPO_ROOT}"/agents/vaultcraft*.md; do
    install_file "${agent}" "${AGENTS_DIR}/$(basename "${agent}")"
  done

  echo -e "${BLUE}→${RESET} Installing skill (SKILL.md, references, templates) to ${SKILLS_DIR}/vaultcraft/"
  local src
  while IFS= read -r src; do
    install_file "${src}" "${SKILLS_DIR}/vaultcraft/${src#"${REPO_ROOT}/skills/vaultcraft/"}"
  done < <(find "${REPO_ROOT}/skills/vaultcraft" -type f -name '*.md')

  echo -e "${GREEN}✓${RESET} Install complete. Nothing else in ~/.claude was touched."
  echo
  echo "Recommended: the official Obsidian skills by Steph Ango (MIT). In Claude Code:"
  echo "      /plugin marketplace add kepano/obsidian-skills"
  echo "      /plugin install obsidian@obsidian-skills"
  echo
  echo "Then run the skill in Claude Code (banner + intake in the main chat, then the agent builds):"
  echo "      > /vaultcraft"
  echo "      > /vaultcraft build a vault from ~/Downloads/slides/"
}

install_templates() {
  local dir="$1"
  echo -e "${BLUE}→${RESET} Copying note templates to ${dir} (existing files are kept)"
  mkdir -p "${dir}"
  for f in "${REPO_ROOT}/skills/vaultcraft/templates/"*.md; do
    if [ -e "${dir}/$(basename "${f}")" ]; then
      echo -e "  ${YELLOW}skip${RESET} $(basename "${f}") (already exists)"
    else
      cp "${f}" "${dir}/"
    fi
  done
}

uninstall_files() {
  if [ ! -f "${MANIFEST}" ]; then
    echo -e "${YELLOW}!${RESET} No install manifest at ${MANIFEST}; nothing to remove."
    echo "  (If you installed vaultcraft as a plugin, use: /plugin uninstall vaultcraft@vaultcraft)"
    return
  fi
  echo -e "${YELLOW}!${RESET} Removing the files vaultcraft installed:"
  while IFS= read -r path; do
    [ -n "${path}" ] || continue
    case "${path}" in
      "${CLAUDE_DIR}"/*) ;;
      *) echo "  skip ${path} (outside ${CLAUDE_DIR})"; continue ;;
    esac
    if [ -e "${path}" ]; then
      rm -f "${path}"
      echo "  removed ${path}"
    fi
  done < "${MANIFEST}"
  [ -d "${SKILLS_DIR}/vaultcraft" ] && find "${SKILLS_DIR}/vaultcraft" -depth -type d -empty -delete
  rm -f "${MANIFEST}"
  echo -e "${GREEN}✓${RESET} Uninstalled. Other skills and agents were left alone."
}

run_demo() {
  local demo_src="${REPO_ROOT}/examples/demo-materials"
  local demo_out="${HOME}/Documents/ObsidianVaults/vaultcraft-demo"

  if [ ! -d "${demo_src}" ]; then
    echo -e "${RED}✗${RESET} Demo materials missing at ${demo_src}"
    exit 1
  fi

  echo
  echo -e "${BLUE}→${RESET} Demo mode"
  echo "  Source materials : ${demo_src}"
  echo "  Output vault     : ${demo_out}"
  echo
  echo "Open Claude Code in this directory and paste:"
  echo
  cat <<EOF
> /vaultcraft build a 'studies' vault called "NLP Demo"
> from sources at ${demo_src}
> output at ${demo_out}
> language English, depth lean, format Detailed narrative
EOF
  echo
  echo "The skill asks the intake questions, confirms the plan, then the agent builds a"
  echo "small but complete sample vault you can open in Obsidian."
}

usage() {
  cat <<EOF
Usage:
  ./install.sh                      install the agent + front-end skill into ~/.claude/
  ./install.sh --templates DIR      also copy note templates into DIR (never overwrites)
  ./install.sh --demo               install + show how to run the bundled NLP demo
  ./install.sh --uninstall          remove only the files this installer put there

Recommended instead: install as a Claude Code plugin (works on macOS, Linux and Windows):
  /plugin marketplace add MikolajSapek/vaultcraft
  /plugin install vaultcraft@vaultcraft
EOF
}

main() {
  case "${1:-install}" in
    --uninstall|uninstall)
      banner; echo
      uninstall_files
      ;;
    --demo|demo)
      banner; echo
      install_files
      run_demo
      ;;
    --templates)
      if [ -z "${2:-}" ]; then
        echo -e "${RED}✗${RESET} --templates needs a target directory" >&2
        usage >&2
        exit 1
      fi
      banner; echo
      install_files
      install_templates "$2"
      ;;
    --help|-h|help)
      usage
      ;;
    install)
      banner; echo
      install_files
      ;;
    *)
      echo -e "${RED}✗${RESET} Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
}

main "$@"
