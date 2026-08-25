# Dotfiles

Minimal macOS development setup for shell, Git, terminal tools, editors, and a few desktop apps. Secrets and application state are intentionally not tracked.

## Install

```sh
git clone https://github.com/dungsnowaxe/dotfiles.git ~/dotfiles
cd ~/dotfiles
brew bundle --file=Brewfile
./install.sh
exec zsh
```

Create the machine-local Git identity once:

```sh
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "you@example.com"
```

`install.sh` installs mise from `mise.run` and creates symlinks for the tracked configuration. Existing regular files are left untouched and reported as `skip`; move or remove them yourself before running the installer again.

## Included

- Zsh, mise, Starship, fzf, zoxide, eza, bat
- tmux, Git, delta, GitHub CLI
- Cursor as the primary editor; VS Code for extension checks; Zed as a lower-memory option
- Codex and other currently installed development tools
- `pi -w <name>` for isolated agent worktrees with optional trusted setup hooks
- CodexBar for tracking usage across AI subscriptions
- Finicky for work/personal browser routing
- Karabiner-Elements keyboard mappings

## Headless devbox

The devbox installer deploys only portable Git, tmux, and worktree tooling. It does not install macOS applications or copy credentials:

```sh
git clone https://github.com/dungsnowaxe/dotfiles.git ~/dotfiles
~/dotfiles/devbox/install.sh
```

Install project runtimes from each project's mise configuration, then authenticate GitHub and agent CLIs independently on the devbox.

## Update

Refresh the package inventory from what is currently installed:

```sh
cd ~/dotfiles
brew bundle dump --file=Brewfile --force
```

Review the diff before committing. Keep project-specific packages in their projects rather than the global Brewfile.

After editing configuration, linked files update immediately. Validate changes with:

```sh
zsh -n .zshrc .zprofile
sh -n install.sh devbox/install.sh bin/dotfiles-check
brew bundle check --file=Brewfile
dotfiles-check
```

## Privacy

Do not track credentials, auth files, shell history, `.env` files, or mutable agent state. `.claude.json`, `.codex/`, `.claude/`, `.agents/`, and Pi agent settings remain machine-local. Store only deliberately authored, credential-free agent skills or hooks outside those state directories before adding them explicitly.

Before staging:

```sh
git status --short
git diff --check
```

Stage explicit paths rather than the entire home directory.
