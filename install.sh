#!/usr/bin/bash
set -e

DEST_SHARE="/usr/local/share/cppref"
DEST_BIN="/usr/bin"

echo "Installing cppref..."

if [[ $EUID -ne 0 ]]; then
    echo "Please run as root (sudo $0)"
    exit 1
fi

mkdir -p "$DEST_SHARE"
mkdir -p "$DEST_BIN"

cp main.lua scan.lua "$DEST_SHARE/"
cp cppref cppref-scan "$DEST_BIN/"

chmod +x "$DEST_BIN/cppref" "$DEST_BIN/cppref-scan"

echo "Installation complete!"
