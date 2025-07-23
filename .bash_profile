[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f $BREW_PREFIX/etc/profile.d/z.sh ] && source $BREW_PREFIX/etc/profile.d/z.sh
[ -d $BREW_PREFIX/Caskroom/gcloud-cli ] && \
  source $BREW_PREFIX/Caskroom/gcloud-cli/latest/google-cloud-sdk/path.bash.inc && \
  source $BREW_PREFIX/Caskroom/gcloud-cli/latest/google-cloud-sdk/completion.bash.inc

export STM32_PRG_PATH=/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin
