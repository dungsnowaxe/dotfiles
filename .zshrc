## Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

export EDITOR="cursor"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

eval "$(starship init zsh)"

# zoxide
alias cd="z"
eval "$(zoxide init zsh)"

# eza
alias ls="eza"
alias ll="eza -la"
alias la="eza -la"
alias lt="eza --tree"

# bat
alias cat="bat"

# alias
alias c="cursor ."
alias cc="claude"
alias op="opencode"
alias gwt="git worktree list"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

mkcd() {
  mkdir -p "$1" && cd "$1"
}

take() {
  mkdir -p "$1"
  cd "$1"
}

reload() {
  source ~/.zshrc
}