#!/bin/bash

TERMINAL_SETUP_LOCAL_DIR="$HOME/.local/terminal-setup/"
TERMINAL_SETUP_LOCAL_BIN_DIR="$TERMINAL_SETUP_LOCAL_DIR/bin"
TERMINAL_SETUP_REPO_BIN_DIR="$(pwd)/bin"

ZSHRC_SOURCE_REL="dotfiles/.zshrc"
ZSHRC_SOURCE="$(pwd)/$ZSHRC_SOURCE_REL"

P10K_SOURCE_REL="dotfiles/.p10k.zsh"
P10K_SOURCE="$(pwd)/$P10K_SOURCE_REL"

[ ! -d "$TERMINAL_SETUP_REPO_BIN_DIR" ] && echo "Directory not found: \"$TERMINAL_SETUP_REPO_BIN_DIR\". You may be in the wrong directory >>> Exit 1" && exit 1

[ ! -e "$ZSHRC_SOURCE" ] && echo "File not found: \"./$ZSHRC_SOURCE_REL\". You may be in the wrong directory >>> Exit 1" && exit 1

[ ! -e "$P10K_SOURCE" ] && echo "File not found: \"./$P10K_SOURCE_REL\". You may be in the wrong directory >>> Exit 1" && exit 1

chmod 600 "$ZSHRC_SOURCE"

chmod 600 "$P10K_SOURCE"

ZSHRC_FILE="$HOME/.zshrc"

P10KZSH_FILE="$HOME/.p10k.zsh"

[ -e "$P10KZSH_FILE" ] && rm "$P10KZSH_FILE" 2>/dev/null && echo "Removed original .p10k.zsh >>> Done"

[ -e "$ZSHRC_FILE" ] && rm "$ZSHRC_FILE" 2>/dev/null && echo "Removed original .zshrc >>> Done"

[ -d "$TERMINAL_SETUP_LOCAL_BIN_DIR" ] && rm -rf "$TERMINAL_SETUP_LOCAL_BIN_DIR" 2>/dev/null && echo "Removed original directory: $TERMINAL_SETUP_LOCAL_BIN_DIR >>> Done"

[ ! -d "$TERMINAL_SETUP_LOCAL_DIR" ] && mkdir -p "$TERMINAL_SETUP_LOCAL_DIR" && echo "Created new directory: $TERMINAL_SETUP_LOCAL_DIR >>> Done"

ln -s "$TERMINAL_SETUP_REPO_BIN_DIR" "$TERMINAL_SETUP_LOCAL_BIN_DIR" && echo "Created a new symbolic link from $TERMINAL_SETUP_LOCAL_BIN_DIR to $TERMINAL_SETUP_REPO_BIN_DIR >>> Done"

ln -s "$ZSHRC_SOURCE" "$ZSHRC_FILE" && echo "Created a new symbolic link from $ZSHRC_FILE to $ZSHRC_SOURCE >>> Done"

ln -s "$P10K_SOURCE" "$P10KZSH_FILE" && echo "Created a new symbolic link from $P10KZSH_FILE to $P10K_SOURCE >>> Done"

echo "Please restart your terminal or run \`source ~/.zshrc\` to reload .zshrc"
