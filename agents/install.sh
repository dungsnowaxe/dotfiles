#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
source=$repo/agents/AGENTS.md

link_guidance() {
  target=$1
  mkdir -p "$(dirname "$target")"

  # Unlike other dotfiles, migrate global guidance after preserving local edits.
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    if [ ! -f "$target" ]; then
      printf 'error: not a regular instruction file: %s\n' "$target" >&2
      exit 1
    fi
    backup=$target.bak.$(date +%Y%m%d%H%M%S)
    suffix=0
    while [ -e "$backup" ] || [ -L "$backup" ]; do
      suffix=$((suffix + 1))
      backup=$target.bak.$(date +%Y%m%d%H%M%S).$suffix
    done
    mv "$target" "$backup"
    printf 'backup: %s -> %s\n' "$target" "$backup"
  fi

  ln -sfn "$source" "$target"
  printf 'link: %s -> %s\n' "$target" "$source"
}

link_guidance "${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}/AGENTS.md"
link_guidance "$HOME/.claude/CLAUDE.md"
link_guidance "${CODEX_HOME:-$HOME/.codex}/AGENTS.md"
link_guidance "${XDG_CONFIG_HOME:-$HOME/.config}/opencode/AGENTS.md"
link_guidance "$HOME/.zcode/AGENTS.md"
link_guidance "$HOME/.qoder/AGENTS.md"

for directory in "${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}" "${CODEX_HOME:-$HOME/.codex}"; do
  if [ -f "$directory/AGENTS.override.md" ]; then
    printf 'warning: %s/AGENTS.override.md takes precedence over shared guidance\n' "$directory" >&2
  fi
done
