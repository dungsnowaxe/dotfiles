## Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

export EDITOR="vim"
export GIT_EDITOR="vim"
export HOMEBREW_NO_ENV_HINTS=1
eval "$(~/.local/bin/mise activate zsh)"

# completions first
autoload -U compinit && compinit

# zoxide
eval "$(zoxide init zsh)"
alias cd="z"

# fzf
eval "$(fzf --zsh)"

# plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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

# Use fd as fzf source
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

show_file_or_dir_preview='
if [ -d {} ]; then
  eza --tree --color=always {} | head -200
else
  bat -n --color=always --line-range :500 {}
fi
'

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)
      fzf --preview 'eza --tree --color=always {} | head -200' "$@"
      ;;
    export|unset)
      fzf --preview "eval 'echo \${}'" "$@"
      ;;
    ssh)
      fzf --preview 'dig {}' "$@"
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


# Starship last
eval "$(starship init zsh)"
