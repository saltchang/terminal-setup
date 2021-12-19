#!/bin/bash

ZSHRC_SOURCE=$(readlink -f "./dotfiles/.zshrc")
chmod 600 "$ZSHRC_SOURCE"

ZSHRC_FILE="$HOME/.zshrc"

rm "$ZSHRC_FILE"
ln -s "$ZSHRC_SOURCE" "$ZSHRC_FILE"
