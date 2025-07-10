alias vi="nvim"
alias lvi="lvim"
alias cls="printf '\33c\e[3J'"

PS1="%~ %(!.#.:)) "

fingerprint() {
  pubkeypath="$1"
  ssh-keygen -E md5 -lf "$pubkeypath" | awk '{ print $2 }' | cut -c 5-
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export STM32_PRG_PATH=/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin