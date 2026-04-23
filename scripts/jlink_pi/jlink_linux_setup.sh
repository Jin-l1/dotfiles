#!/bin/bash

set -e

[[ "$(uname)" == "Linux" ]] || { echo "This script is only intended to be run on Linux. Exiting."; exit 1; }
[[ "$EUID" -ne 0 ]] && { echo "This script must be run as root. Exiting."; exit 1; }

hash JLinkRemoteServer 2>/dev/null && { 
  echo "J-Link Remote Server is already installed. Exiting."
  exit 0
}

ARCH=$(uname -m)
VERSION="V794e"

sudo apt update
sudo apt install -y \
  libxrender1 \
  libxcb-render0 \
  libxcb-render-util0 \
  libxcb-shape0 \
  libxcb-icccm4 \
  libxcb-keysyms1 \
  libxcb-image0 \
  libxkbcommon0 \
  libxkbcommon-x11-0 \
  libfontconfig1 \
  libfreetype6 \
  libsm6 \
  libice6 \
  curl

sudo dpkg --configure -a
sudo apt -y -f install

curl -L \
  -X POST \
  -d "accept_license_agreement=accepted" \
  -d "submit=Download software" \
  -o JLink_Linux_${VERSION}_${ARCH}.deb \
  "https://www.segger.com/downloads/jlink/JLink_Linux_${VERSION}_${ARCH}.deb"

sudo dpkg -i JLink_Linux_${VERSION}_${ARCH}.deb