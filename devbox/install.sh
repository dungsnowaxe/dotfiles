#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

need() {
  command -v "$1" >/dev/null 2>&1 || {
    printf 'missing required command: %s\n' "$1" >&2
    exit 1
  }
}

need git
need curl
need bash

if ! command -v mise >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/mise" ]; then
  curl -fsSL https://mise.run | sh
fi

link() {
  source=$1
  target=$2
  mkdir -p "$(dirname "$target")"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    printf 'skip: %s already exists\n' "$target"
    return
  fi

  ln -sfn "$source" "$target"
  printf 'link: %s -> %s\n' "$target" "$source"
}

link "$repo/.gitconfig" "$HOME/.gitconfig"
link "$repo/.tmux.conf" "$HOME/.tmux.conf"
link "$repo/.config/git/ignore" "$HOME/.config/git/ignore"
link "$repo/bin/pi-worktree" "$HOME/.local/bin/pi-worktree"
link "$repo/.config/pi-worktree/setup.example" "$HOME/.config/pi-worktree/setup.example"

link "$repo/bin/dotfiles-check" "$HOME/.local/bin/dotfiles-check"

if [ ! -f "$HOME/.gitconfig.local" ]; then
  printf 'create ~/.gitconfig.local with your [user] name and email\n'
fi

"$repo/bin/dotfiles-check" --devbox
