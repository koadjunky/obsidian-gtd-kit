#!/bin/bash

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/bin"

mkdir -p "$BIN_DIR"

install_copy() {
    local src="$REPO_DIR/scripts/$1"
    local dst="$BIN_DIR/$1"
    cp "$src" "$dst"
    chmod +x "$dst"
    echo "  installed: $dst"
}

echo "Installing obsidian-gtd-kit scripts to $BIN_DIR..."
install_copy obsidian-capture.sh

echo "Done. Run install.sh again after updates to sync."
