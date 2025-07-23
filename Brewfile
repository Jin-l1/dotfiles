# Taps
tap "facebook/fb" # idb-companion

# Binaries
brew "cask"   # brew install GUI apps
brew "fzf"    # fuzzy finder (term back search history)
brew "z"      # fuzzy quick cd
brew "zsh-autosuggestions" # zsh intellisense
brew "shfmt"  # sh formatter
brew "tmux"   # terminal multiplexer
brew "lua"    # used by neovim
brew "neovim"
brew "ack"    # text search files recursive in tree
brew "node", link: :overwrite
brew "python@3.13", link: :overwrite
brew "pipx"   # pip venv manager for system pkgs
brew "ruby", link: :overwrite
brew "ripgrep"  # search tool like grep
brew "git"    # repo management
brew "tig"    # text-mode interface git
brew "tree"   # folder tree
brew "jq"     # json
brew "yq"     # yaml
brew "expect" # bash gaurd tool
brew "just"   # makefile without the files
brew "ffmpeg" # video/audio encoding
brew "telnet"
#brew 'mackup' # sync app configs
brew "mas"    # mac app store

# Development
#brew "protobuf"
#brew "buf"       # protos breaking change linter
brew "lcov"       # gcc graphical coverage
# - Arduino
brew "arduino-cli"
cask "arduino-ide"  # req. config for arduino-cli
cask "saleae-logic" # usb logic analyzer
# - Nordic
brew "doxygen"        # C doc gen
cask "segger-jlink"   # JLink tool
cask "segger-embedded-studio-for-arm"
cask "nordic-nrf-command-line-tools"  # nrfjprog
cask "nrfutil"                        # nrfutil
cask "nrf-connect"
# - Android
#brew "openjdk@11", postinstall: "sudo ln -sfn /usr/local/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk"
#brew "openjdk@17", postinstall: "sudo ln -sfn /usr/local/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk"
#brew "maven"
#brew "gradle"
#cask "android-sdk"
#cask "android-studio"
#brew "srccpy"      # screen cpy
#brew "pidcat"      # colorised logcat
# - iOS
brew "aria2"        # speed up xcodes downloads
brew "xcodes"       # xcodes installer
brew "idb-companion", postinstall: "${HOMEBREW_PREFIX}/bin/pipx install fb-idb" # iOS debug bridge
#brew "swift-protobuf"
# - Flutter
#brew "fvm"         # flutter versions manager
# - Python
#cask "pycharm-ce"
# - Misc
cask "visual-studio-code"
cask "zed"
cask "google-cloud-sdk", postinstall: "${HOMEBREW_PREFIX}/bin/gcloud components update"
cask "docker"
brew "docker-completion"

# - VSCode extensions
vscode "github.copilot"
vscode "github.copilot-chat"
vscode "ms-vscode.cmake-tools"
vscode "ms-vscode.cpptools"
vscode "ms-vscode.cpptools-extension-pack"
vscode "ms-vscode.cpptools-themes"
vscode "ms-vscode.vscode-serial-monitor"
vscode "vscode-arduino.vscode-arduino-community"
vscode "vscodevim.vim"

# Apps
cask "logi-options+"   # MX3 mouse
cask "arc"             # private browser
cask "rectangle"       # window snap
cask "flycut"          # cpy/paste board manager
cask "ghostty"         # terminal app
cask "github"          # github desktop
cask "kicad"           # schematics / PCB brd view
cask "slack"           # comms
#cask "gimp"           # graphics editing
#cask "figma"          # UX/UI
cask "stats"           # task bar CPU, network, etc stats
cask "displaylink"     # non-thunderbold usb-c dock support
#cask "sonos"
#cask "spotify"
