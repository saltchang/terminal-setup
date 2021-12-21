#!/bin/bash

ZSHRC_SOURCE_REL="dotfiles/.zshrc"
ZSHRC_SOURCE="$(pwd)/$ZSHRC_SOURCE_REL"

[ ! -e "$ZSHRC_SOURCE" ] && echo "File not found: \"./$ZSHRC_SOURCE_REL\". You may be in the wrong directory >>> Exit 1" && exit 1

chmod 600 "$ZSHRC_SOURCE"

ZSHRC_FILE="$HOME/.zshrc"

rm "$ZSHRC_FILE" 2>/dev/null && echo "Removed original .zshrc >>> Done"

ln -s "$ZSHRC_SOURCE" "$ZSHRC_FILE" && echo "Created a new sybolic link from $ZSHRC_FILE to $ZSHRC_SOURCE >>> Done"

echo "Please restart your terminal or run \"source-rc\" to reload .zshrc"
