eval "$($BREW_PREFIX/bin/brew shellenv)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f $BREW_PREFIX/etc/profile.d/z.sh ] && source $BREW_PREFIX/etc/profile.d/z.sh
