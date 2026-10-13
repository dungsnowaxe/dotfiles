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

`install.sh` installs mise from `mise.run` and creates symlinks for the tracked configuration. Existing regular files are left untouched and reported as `skip`, except global agent instructions: those are backed up beside the original file before linking the shared guidance.

## Included

- Zsh, mise, Starship, fzf, zoxide, eza, bat
- tmux, Git, delta, GitHub CLI
- Cursor as the primary editor; VS Code for extension checks; Zed as a lower-memory option
- Codex and other currently installed development tools
- `pi -w <name>` for isolated agent worktrees with optional trusted setup hooks
- CodexBar for tracking usage across AI subscriptions
- Finicky for work/personal browser routing
- Karabiner-Elements keyboard mappings

## Shared agent instructions

`agents/AGENTS.md` is the single source for personal, cross-project agent guidance. The root `AGENTS.md` remains specific to this dotfiles repository. Both installers symlink the shared file to:

| Harness | Global instruction path |
| --- | --- |
| Pi | `~/.pi/agent/AGENTS.md` |
| Claude Code | `~/.claude/CLAUDE.md` |
| Codex | `~/.codex/AGENTS.md` |
| OpenCode | `~/.config/opencode/AGENTS.md` |
| ZCode | `~/.zcode/AGENTS.md` |
| Qoder CLI | `~/.qoder/AGENTS.md` |

The installers honor `PI_CODING_AGENT_DIR`, `CODEX_HOME`, and `XDG_CONFIG_HOME`. Existing regular instruction files are preserved as timestamped `.bak.*` files; existing symlinks are repointed. Review backups for machine-specific guidance before removing them. Pi or Codex `AGENTS.override.md` files can supersede the shared instructions and produce an installer warning.

Claude Code uses the shared file through its documented global `CLAUDE.md` filename. Its direct project `AGENTS.md` support is version/settings-dependent; no global `AGENTS.md` discovery is assumed. Cursor User Rules must be configured in the IDE separately; Qoder IDE global inheritance is not assumed. No speculative rule paths are created for either IDE.

Edit `agents/AGENTS.md` here to update every linked harness. After syncing the repository to a new machine, run the installer there. Start a new agent session to pick up changes, or use Pi `/reload`. The guidance recommends installed CLIs with portable fallbacks; the devbox installer does not install those CLIs.

## Headless devbox

The devbox installer deploys portable Git, tmux, worktree tooling, and shared agent instructions. It does not install macOS applications or copy credentials:

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
sh -n install.sh devbox/install.sh agents/install.sh bin/dotfiles-check
brew bundle check --file=Brewfile
dotfiles-check
```

## Privacy

Do not track credentials, auth files, shell history, `.env` files, or mutable agent state. `.claude.json`, `.codex/`, `.claude/`, `.agents/`, and Pi agent settings remain machine-local. Store only deliberately authored, credential-free agent instructions, skills, or hooks outside those state directories before adding them explicitly. Shared global instructions live in `agents/AGENTS.md`; session logs and machine-local backups are not tracked.

Before staging:

```sh
git status --short
git diff --check
```

Stage explicit paths rather than the entire home directory.
