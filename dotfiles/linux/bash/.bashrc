case $- in
  *i*) ;;
  *) return ;;
esac

export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less -FRX"

HISTFILE="$HOME/.bash_history"
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups

shopt -s autocd
shopt -s checkwinsize
shopt -s histappend

alias l='ls -CF'
alias la='ls -A'
alias ll='ls -lah'

if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  alias fd='fdfind'
fi

if [ -f "$HOME/.config/dev-environment/dotnet.sh" ]; then
  . "$HOME/.config/dev-environment/dotnet.sh"
fi

if [ -f "$HOME/.config/dev-environment/private/dotfiles/linux/bash/.bashrc" ]; then
  . "$HOME/.config/dev-environment/private/dotfiles/linux/bash/.bashrc"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi
