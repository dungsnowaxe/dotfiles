# Dotfiles agent guidance

This repository manages a small, personal macOS development setup.

## Privacy

- Never read or print secrets, API keys, tokens, credentials, auth stores, shell history, or `.env` values.
- Treat application state such as `.claude.json`, `.codex/`, and `.pi/` as private and untracked.
- Inspect only key names or redacted structure when configuration shape is required.

## Working rules

- Prefer built-in macOS and shell features over new dependencies.
- Keep changes portable across Apple Silicon Macs.
- Keep configuration minimal; do not add speculative aliases, agents, plugins, or MCP servers.
- Use `./install.sh` for deployment. Do not add manual copy instructions.
- Stage explicit files; never recommend `git add .` from the home directory.

## Checks

Run the smallest relevant checks:

```sh
zsh -n .zshrc .zprofile
sh -n install.sh
brew bundle check --file=Brewfile
```
