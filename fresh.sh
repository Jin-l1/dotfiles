#!/bin/sh

#set -e

msu_update() {
  search=$1
  echo "checking for $search updates..."
  # no-scan gets from history
  updates=$(softwareupdate -l --no-scan | awk -F'Label: ' '{print $2}' | awk NF)
  if grep -q "$search" <<< "$updates"; then
    update=$(echo "$updates" | grep "$search")
    echo "update found: $update"
    sudo softwareupdate -i --agree-to-license "$update"
    echo "update installed."
  else
    echo "no updates found for $search."
  fi
}

echo "Setting up Mac..."

# Link and source dotfiles
ln -sf $(pwd)/Brewfile ~/Brewfile
ln -sf $(pwd)/.bash_profile ~/.bash_profile
ln -sf $(pwd)/.bashrc ~/.bashrc
ln -sf $(pwd)/.zshenv ~/.zshenv
ln -sf $(pwd)/.zshrc ~/.zshrc
ln -sf $(pwd)/.zprofile ~/.zprofile
ln -sf $(pwd)/.fzf.bash ~/.fzf.bash
ln -sf $(pwd)/.fzf.zsh ~/.fzf.zsh
ln -sf $(pwd)/.gitconfig ~/.gitconfig
ln -sf $(pwd)/.gitignore_global ~/.gitignore_global
ln -sf $(pwd)/.tmux.conf ~/.tmux.conf

mkdir -p ~/.config/ghostty
ln -sf $(pwd)/.config/ghostty/config ~/.config/ghostty/config

# Check if Xcode Command Line Tools are installed
if ! xcode-select -p &>/dev/null; then
  echo "Xcode Command Line Tools not found. Installing..."
  xcode-select --install
else
  echo "Xcode Command Line Tools already installed."
  msu_update "Command Line Tools"
fi

# Rosetta 2
if ! /usr/bin/pgrep -q oahd; then
  echo "Rosetta 2 not found. Installing..."
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license
else
  echo 'Rosetta already installed.'
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  echo "Brew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  #echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update Homebrew recipes
echo "Updating brew things..."
brew update
brew upgrade
brew upgrade --casks

# Install all our dependencies with bundle (See Brewfile)
brew bundle check || brew bundle --file ./Brewfile

# Tmux setup
tmux start-server \; source-file ~/.tmux.conf
if [ ! -d ~/.tmux/plugins/tpm ]; then
  echo "Installing tmux plugins..."
  mkdir -p ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  export TMUX_PLUGIN_MANAGER_PATH="${HOME}/.tmux/plugins"
else
  echo "Updating tmux plugins..."
  (cd ~/.tmux/plugins/tpm; git pull)
fi
~/.tmux/plugins/tpm/scripts/install_plugins.sh # install new plugins
~/.tmux/plugins/tpm/bin/update_plugins all # update old plugins

# Neovim setup
if [ ! -d ~/.vim ]; then
  echo "Installing vimfiles by luan..."
  mkdir -p ~/.config/vimfile_by_luan
  python3 -m venv ~/.config/vimfile_by_luan/venv
  git clone https://github.com/luan/vimfiles ~/.vim
  (cd ~/.vim; git checkout master; git pull -r)
  # set nvim python to venv and disable deoplete
  echo "let g:python3_host_prog = expand('~/.config/vimfile_by_luan/venv/bin/python3')" > ~/.vimrc.local.before
  echo "let g:deoplete#enable_at_startup - 0   \" disable deoplete" > ~/.vimrc.local
  # fix nvim guioptions (legacy) and pastetoggle cmds
  sed -i '' -E 's/^(set guioptions=.*)/\"\1/g' ~/.vim/config/basic.vim
  sed -i '' -r 's/^(set pastetoggle=.*)/\"\1/g' ~/.vim/config/bindings.vim
  git commit -a -m "tmp-fix: guioptions (legacy) pastetoggle bindings"
else
  echo "Updating neovim plugins..."
  (cd ~/.vim; git pull -r)
fi
(
  cd ~/.vim
  source ~/.config/vimfile_by_luan/venv/bin/activate
  sudo ./update
)

# STM32CubeProgrammer
#if [ -d "$STM32_PRG_PATH" ]; then
#  sudo ln -sf $STM32_PRG_PATH/STM32_Programmer_CLI /usr/local/bin/STM32_Programmer_CLI
#  sudo ln -sf $STM32_PRG_PATH/STM32_Programmer_CLI /usr/local/bin/stm32prog
#fi

# git ssh creds
if [ ! -f ~/.ssh/id_github ]; then
  echo "Generating git ssh key..."
  .gitssh
fi

# Set macOS preferences - we will run this last because this will reload the shell
echo "Configuring macos settings..."
source ./.macos
