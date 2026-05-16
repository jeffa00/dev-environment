export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

