# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("/Users/snowaxe/.zsh/completions" $fpath)
autoload -Uz compinit
compinit
# OPENSPEC:END

## Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export ANDROID_HOME=$HOME/Library/Android/sdk

# Keep PATH entries unique across nested/reloaded shells.
typeset -U path PATH
path+=(
  "$ANDROID_HOME/emulator"
  "$ANDROID_HOME/platform-tools"
)

export EDITOR="vim"
export GIT_EDITOR="vim"
export HOMEBREW_NO_ENV_HINTS=1

# completions first
autoload -U compinit && compinit

# zoxide
eval "$(zoxide init zsh)"
alias cd="z"

# fzf
eval "$(fzf --zsh)"

# plugins
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# aliases
alias ls="eza"
alias ll="eza -la"
alias la="eza -la"
alias lt="eza --tree"
alias cat="bat"
alias c="cursor ."
alias cc="claude"
alias op="opencode"
alias gwt="git worktree list"

take() {
  mkdir -p "$1" && cd "$1"
}

reload() {
  exec zsh
}

# Start Pi in a named Git worktree: pi -w feature-name [pi options]
pi() {
  if [[ "${1:-}" == "-w" || "${1:-}" == "--worktree" ]]; then
    shift
    "$HOME/.local/bin/pi-worktree" "$@"
  else
    command pi "$@"
  fi
}

# Use fd as fzf source while excluding credential-bearing and generated trees.
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix \
  --exclude .git \
  --exclude node_modules \
  --exclude .env \
  --exclude ".env.*" \
  --exclude .ssh \
  --exclude .gnupg \
  --exclude Keychains'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type=d"

_fzf_compgen_path() {
  fd --hidden \
    --exclude .git \
    --exclude node_modules \
    --exclude .env \
    --exclude '.env.*' \
    --exclude .ssh \
    --exclude .gnupg \
    --exclude Keychains \
    . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden \
    --exclude .git \
    --exclude node_modules \
    --exclude .env \
    --exclude '.env.*' \
    --exclude .ssh \
    --exclude .gnupg \
    --exclude Keychains \
    . "$1"
}

show_file_or_dir_preview='
candidate={}
case "/$candidate/" in
  */.*/*)
    printf "Preview disabled for hidden paths.\n"
    exit 0
    ;;
esac
candidate_name=${candidate##*/}
case "$candidate_name" in
  *credential*|*secret*|*token*|*.pem|*.key|auth.json|*.p12|*.mobileprovision)
    printf "Preview disabled for potentially sensitive files.\n"
    exit 0
    ;;
esac
if [ -d "$candidate" ]; then
  eza --tree --color=always -- "$candidate" | head -200
else
  bat -n --color=always --line-range :500 -- "$candidate"
fi
'

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview '$show_file_or_dir_preview'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)
      fzf --preview "$show_file_or_dir_preview" "$@"
      ;;
    export|unset)
      fzf --no-preview "$@"
      ;;
    ssh)
      fzf --no-preview "$@"
      ;;
    *)
      fzf --preview "$show_file_or_dir_preview" "$@"
      ;;
  esac
}

bindkey '^[^?' vi-backward-kill-word
bindkey '^[^H' vi-backward-kill-word
bindkey '^[b' vi-backward-word
bindkey '^[f' vi-forward-word
bindkey '^[[1;3D' vi-backward-word
bindkey '^[[1;3C' vi-forward-word


# Initialize prompt first, then let mise make project tools authoritative.
eval "$(starship init zsh)"
eval "$("$HOME/.local/bin/mise" activate zsh)"

# Added by Devin
export PATH="/Users/snowaxe/.codeium/windsurf/bin:$PATH"
