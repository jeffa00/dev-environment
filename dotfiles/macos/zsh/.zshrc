export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less -FRX"

HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt AUTO_CD
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

autoload -Uz compinit
compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"

zstyle ':completion:*' menu select
bindkey -e

alias l='ls -CF'
alias la='ls -A'
alias ll='ls -lah'

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

