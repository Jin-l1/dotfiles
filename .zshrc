alias vi="nvim"
alias lvi="lvim"
alias cls="printf '\33c\e[3J'"

# flutter
if hash fvm 2>/dev/null; then
  alias flutter='fvm flutter'
  alias dart='fvm dart'
  alias killFvmVMs="kill $(ps aux | grep flutter | grep -v grep | awk '{print $2}')"
fi

PS1="%~ %(!.#.:)) "

export STM32_PRG_PATH=/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin

# print md5 fingerprint
fingerprint() {
  pubkeypath="$1"
  ssh-keygen -E md5 -lf "$pubkeypath" | awk '{ print $2 }' | cut -c 5-
}

function mov_to_mp4() {
  # arg1: *.mov, arg2: output.mp4
  ffmpeg -i $1 -vcodec h264 -acodec mp2 $2
}

function heic_to_jpeg() {
  # arg1: "*.heic, arg2: output.jpg
  sips -s format jpeg $1 --out $2
}

# adb helper
if hash adb 2>/dev/null; then
  function adb {
    adb_op=$1
    if [ "$adb_op" = "mirror" ]; then
      ! hash scrcpy 2>/dev/null && >&2 echo "scrcpy not installed. Abort!" && return
      [ -z "$(adb devices | grep -v 'List of devices attached')" ] && >&2 echo "error: no adb devices found." && return
      scrcpy --video-bit-rate 4M --max-size 1280 --max-fps 60
    elif [ "$adb_op" = "record" ]; then
      ! hash scrcpy 2>/dev/null && >&2 echo "scrcpy not installed. Abort!" && return
      [ -z "$(adb devices | grep -v 'List of devices attached')" ] && >&2 echo "error: no adb devices found." && return
      outfile=~/Downloads/screenrecord`ls ~/Downloads/screenrecord* 2>/dev/null | wc -l | tr -d ' '`.mp4
      scrcpy --video-bit-rate 4M --max-size 1280 --max-fps 60 --record=$outfile
      echo "=> output to $outfile"
    elif [ "$adb_op" = "snap" ]; then
      [ -z "$(adb devices | grep -v 'List of devices attached')" ] && >&2 echo "error: no adb devices found." && return
      outfile=~/Downloads/screencap`ls ~/Downloads/screencap* 2>/dev/null | wc -l | tr -d ' '`.png
      adb exec-out screencap -p > $outfile
      echo "=> output to $outfile"
    elif [ "$adb_op" = "open-url" ]; then
      adb shell am start -a android.intent.action.VIEW -d "$2"
    else
      command adb "$@"
    fi
  }
fi
