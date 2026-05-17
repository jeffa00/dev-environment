dev_environment_prepend_path() {
  case ":${PATH}:" in
    *":$1:"*) ;;
    *) PATH="$1${PATH:+:$PATH}" ;;
  esac
}

if [ -n "${WSL_DISTRO_NAME:-}" ] && [ -x /usr/bin/dotnet ]; then
  dev_environment_prepend_path "/usr/bin"
fi

if [ -x /opt/homebrew/opt/dotnet/libexec/dotnet ]; then
  DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
elif [ -x /usr/local/opt/dotnet/libexec/dotnet ]; then
  DOTNET_ROOT="/usr/local/opt/dotnet/libexec"
elif [ -x /usr/share/dotnet/dotnet ]; then
  DOTNET_ROOT="/usr/share/dotnet"
fi

if [ -n "${DOTNET_ROOT:-}" ]; then
  export DOTNET_ROOT
  dev_environment_prepend_path "$DOTNET_ROOT"
fi

dev_environment_prepend_path "$HOME/.dotnet/tools"

export PATH
unset -f dev_environment_prepend_path 2>/dev/null || true
