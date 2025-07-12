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

# java
alias java11='export JAVA_HOME=$(/usr/libexec/java_home -v11)'
alias java17='export JAVA_HOME=$(/usr/libexec/java_home -v17)'
java17 2>/dev/null || true

# android
if [ -d "$BREW_PREFIX/share/android-sdk" ]; then
  export ANDROID_HOME="$BREW_PREFIX/share/android-sdk"
  export NDK_VERSION=27.2.12479018
  CMDLINE_TOOLS_VERSION=9.0
  add_to_path $ANDROID_HOME/emulator
  add_to_path $ANDROID_HOME/cmdline-tools/$CMDLINE_TOOLS_VERSION/bin
  add_to_path $ANDROID_HOME/platform-tools
  add_to_path $ANDROID_HOME/ndk/$NDK_VERSION
fi

# flutter / dart
if [ -x $BREW_PREFIX/bin/fvm ]; then
  add_to_path $HOME/.pub-cache/bin
fi
