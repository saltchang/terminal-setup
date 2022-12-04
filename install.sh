#!/bin/bash

ZSHRC_SOURCE_REL="dotfiles/.zshrc"
ZSHRC_SOURCE="$(pwd)/$ZSHRC_SOURCE_REL"

ANTIGEN_PATH="$HOME/.antigen"
ANTIGEN_EXEC="$ANTIGEN_PATH/antigen.zsh"

for i in "$@"; do
    case $i in
    --antigen)
        INSTALL_ANTIGEN=YES
        shift
        ;;
    -k | --insecure)
        INSECURE=YES
        shift
        ;;
    *) ;;
    esac
done

[ ! -e "$ZSHRC_SOURCE" ] && echo "File not found: \"./$ZSHRC_SOURCE_REL\". You may be in the wrong directory >>> Exit 1" && exit 1

chmod 600 "$ZSHRC_SOURCE"

ZSHRC_FILE="$HOME/.zshrc"

rm "$ZSHRC_FILE" 2>/dev/null && echo "Removed original .zshrc >>> Done"

ln -s "$ZSHRC_SOURCE" "$ZSHRC_FILE" && echo "Created a new symbolic link from $ZSHRC_FILE to $ZSHRC_SOURCE >>> Done"

if [ $INSTALL_ANTIGEN ]; then
    mkdir -vp "$ANTIGEN_PATH"
    rm "$ANTIGEN_EXEC" 2>/dev/null && echo "Removed original antigen >>> Done"
    if [ $INSECURE ]; then
        curl -skL git.io/antigen >"$ANTIGEN_EXEC"
        echo "Installed antigen (insecure) >>> Done"
    else
        curl -sL git.io/antigen >"$ANTIGEN_EXEC"
        echo "Installed antigen >>> Done"
    fi
fi

echo "Please restart your terminal or run \`source ~/.zshrc\` to reload .zshrc"
