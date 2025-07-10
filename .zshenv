# Add directories to the PATH and prevent to add the same directory multiple times upon shell reload.
add_to_path() {
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}

# Language environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Environment aliases
if /usr/bin/pgrep -q oahd; then
  alias intel='env /usr/bin/arch -x86_64 /bin/zsh -l'
  alias arm='env /usr/bin/arch -arm64 /bin/zsh -l'
fi

# Homebrews
if [ "$(arch)" = "arm64" ]; then
  export BREW_PREFIX=$(/opt/homebrew/bin/brew --prefix)
else
  export BREW_PREFIX=$(/usr/local/bin/brew --prefix)
fi

# Misc aliases
alias py='python'
alias py3='python3'
alias pypath="export PYTHONPATH=$PYTHONPATH:$(pwd)"

# lvim
add_to_path $HOME/.local/bin

# tmux
export TMUX_PLUGIN_MANAGER_PATH="~/.config/tmux/plugins"

# rust cargo
[ -d "$HOME/.cargo" ] && . "$HOME/.cargo/env" || true;
