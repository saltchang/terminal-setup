#!/bin/bash

# ===> Colors ======================================================================================
GREEN="\033[32m"
ERROR="\033[31m"
NC="\033[0m"
# ==================================================================================================

echo
echo "Setting up Alacritty..."

ALACRITTY_CONFIG_SOURCE_REL="terminal-config/alacritty/alacritty.toml"
ALACRITTY_CONFIG_SOURCE="$(pwd)/$ALACRITTY_CONFIG_SOURCE_REL"

[ ! -e "$ALACRITTY_CONFIG_SOURCE" ] && echo -e "${ERROR}File not found: \"./$ALACRITTY_CONFIG_SOURCE\". You may be in the wrong directory >>> Exit 1${NC}" && exit 1

chmod 600 "$ALACRITTY_CONFIG_SOURCE"

ALACRITTY_CONFIG_DIR="$HOME/.config/alacritty"

[ ! -d "$ALACRITTY_CONFIG_DIR" ] && mkdir -p "$ALACRITTY_CONFIG_DIR" && echo -e "${GREEN}Created new directory: $ALACRITTY_CONFIG_DIR${NC}"

ALACRITTY_CONFIG_FILE="$HOME/.config/alacritty/alacritty.toml"

echo "Check and remove original file and directory..."
echo

[ -e "$ALACRITTY_CONFIG_FILE" ] && rm "$ALACRITTY_CONFIG_FILE" 2>/dev/null && echo -e "${GREEN}Removed original alacritty config file${NC}"

echo
echo "Check and create new symbolic link..."
echo

ln -s "$ALACRITTY_CONFIG_SOURCE" "$ALACRITTY_CONFIG_FILE" && echo -e "${GREEN}Created a new symbolic link from $ALACRITTY_CONFIG_FILE to $ALACRITTY_CONFIG_SOURCE${NC}"

echo

echo "Successfully set up Alacritty."
