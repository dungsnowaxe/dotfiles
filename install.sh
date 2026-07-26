#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

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

link "$repo/.zshrc" "$HOME/.zshrc"
link "$repo/.zprofile" "$HOME/.zprofile"
link "$repo/.tmux.conf" "$HOME/.tmux.conf"
link "$repo/.gitconfig" "$HOME/.gitconfig"
link "$repo/.finicky.js" "$HOME/.finicky.js"
link "$repo/.config/starship.toml" "$HOME/.config/starship.toml"
link "$repo/.config/git/ignore" "$HOME/.config/git/ignore"
link "$repo/.config/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
