#!/bin/bash
set -e

echo "Downloading DXVK 2.7.1..."
curl -L https://github.com/doitsujin/dxvk/releases/latest/download/dxvk-2.7.1.tar.gz -o dxvk.tar.gz

echo "Extracting..."
tar -xzf dxvk.tar.gz
cd dxvk-*

echo "Copying DLLs..."
export WINEPREFIX=~/.wine
cp x64/*.dll $WINEPREFIX/drive_c/windows/system32
cp x32/*.dll $WINEPREFIX/drive_c/windows/syswow64

rm -rf dxvk*

echo
echo "Add dll overrides for d3d8, d3d9, d3d10core, d3d11 and dxgi"
echo "in the Libraries tab of winecfg (use Native then Builtin option)"
echo
echo "Press Enter to continue..."
read -r

winecfg
