export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

if [ -f "$HOME/.config/dev-environment/private/dotfiles/linux/bash/.profile" ]; then
  . "$HOME/.config/dev-environment/private/dotfiles/linux/bash/.profile"
fi
