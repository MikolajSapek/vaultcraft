#!/usr/bin/env bash
set -euo pipefail

# vaultcraft installer
# Usage:
#   ./install.sh              install agent + skills to ~/.claude/
#   ./install.sh --demo       install + run agent on bundled NLP demo materials
#   ./install.sh --uninstall  remove vaultcraft files from ~/.claude/

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
AGENTS_DIR="${CLAUDE_DIR}/agents"
SKILLS_DIR="${CLAUDE_DIR}/skills"
TEMPLATES_DIR="${HOME}/Documents/ObsidianVaults/_templates"

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

install_files() {
  echo -e "${BLUE}→${RESET} Installing agent to ${AGENTS_DIR}"
  mkdir -p "${AGENTS_DIR}"
  cp "${REPO_ROOT}/agents/vaultcraft.md" "${AGENTS_DIR}/"

  echo -e "${BLUE}→${RESET} Installing bundled skills to ${SKILLS_DIR}"
  mkdir -p "${SKILLS_DIR}"
  for skill_dir in obsidian-markdown obsidian-bases obsidian-cli json-canvas; do
    if [ -d "${REPO_ROOT}/skills/${skill_dir}" ]; then
      cp -R "${REPO_ROOT}/skills/${skill_dir}" "${SKILLS_DIR}/"
    fi
  done

  echo -e "${BLUE}→${RESET} Copying templates to ${TEMPLATES_DIR}"
  mkdir -p "${TEMPLATES_DIR}"
  cp "${REPO_ROOT}/templates/"*.md "${TEMPLATES_DIR}/" 2>/dev/null || true

  echo -e "${GREEN}✓${RESET} Install complete."
  echo
  echo "Next: open Claude Code and ask vaultcraft to build a vault, e.g."
  echo "      > use vaultcraft to build an Obsidian vault from ~/Downloads/slides/"
}

uninstall_files() {
  echo -e "${YELLOW}!${RESET} Removing vaultcraft files from ${CLAUDE_DIR}"
  rm -f "${AGENTS_DIR}/vaultcraft.md"
  for skill_dir in obsidian-markdown obsidian-bases obsidian-cli json-canvas; do
    rm -rf "${SKILLS_DIR}/${skill_dir}"
  done
  echo -e "${GREEN}✓${RESET} Uninstalled. Templates at ${TEMPLATES_DIR} were left untouched."
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
  echo "After install, open Claude Code in this directory and paste:"
  echo
  cat <<EOF
> use vaultcraft to build a 'studies' vault called "NLP Demo"
> from sources at ${demo_src}
> output at ${demo_out}
> language English, depth lean, format Detailed narrative
EOF
  echo
  echo "The agent will run Phase 1 intake (chip-style), confirm the plan, and build a"
  echo "small but complete sample vault you can open in Obsidian."
}

main() {
  banner
  echo

  case "${1:-install}" in
    --uninstall|uninstall)
      uninstall_files
      ;;
    --demo|demo)
      install_files
      run_demo
      ;;
    --help|-h|help)
      cat <<EOF
Usage:
  ./install.sh              install agent + skills to ~/.claude/
  ./install.sh --demo       install + show how to run the bundled NLP demo
  ./install.sh --uninstall  remove vaultcraft files from ~/.claude/
EOF
      ;;
    *)
      install_files
      ;;
  esac
}

main "$@"
