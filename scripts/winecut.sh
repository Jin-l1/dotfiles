#!/usr/bin/env bash
set -e

SELF=$(basename "${0%*\.sh}")

if [ $# -lt 2 ]; then
    echo "Usage: ${SELF} <exe_path> <app_output_name>"
    echo "Example:"
    echo "  ${SELF} \"$HOME/.wine/drive_c/Program Files (x86)/Saturn PCB Design/Saturn PCB Toolkit V8.44/PCB Toolkit V8.44.exe\" \"Saturn Toolkit\""
    exit 1
fi

EXE_PATH="$1"
APP_NAME="$2"
OUT_APP="/Applications/Wine/${APP_NAME}.app"

WINE_BIN="$(command -v wine)"

mkdir -p "/Applications/Wine"

TMP_SCRIPT="$(mktemp)"

cat > "$TMP_SCRIPT" <<EOF
on run
    set exePath to "$EXE_PATH"
    do shell script "$WINE_BIN " & quoted form of exePath & " >/dev/null 2>&1 &"
end run
EOF

# remove existing app if present
rm -rf "$OUT_APP"

osacompile -o "$OUT_APP" "$TMP_SCRIPT"

rm "$TMP_SCRIPT"

echo "Created: $OUT_APP"
