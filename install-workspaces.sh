#!/bin/bash

PROJECTS_DIR="$HOME/projects"

WORKSPACES_FOLDER_REL="workspaces"
WORKSPACES_FOLDER="$(pwd)/$WORKSPACES_FOLDER_REL"

for i in "$@"; do
    case $i in
    -f | --force)
        FORCE_REMOVE_WORKSPACES=YES
        shift
        ;;
    *) ;;
    esac
done

[ ! -e "$WORKSPACES_FOLDER" ] && echo "Folder not found: \"./$WORKSPACES_FOLDER_REL\". You may be in the wrong directory >>> Exit 1" && exit 1

chmod 755 "$WORKSPACES_FOLDER"
find "$WORKSPACES_FOLDER" -type f -exec chmod 644 {} \;

ORIGIN_WORKSPACES_FOLDER="$PROJECTS_DIR/workspaces"

echo "$ORIGIN_WORKSPACES_FOLDER"

[ -e "$ORIGIN_WORKSPACES_FOLDER" ] && [ ! $FORCE_REMOVE_WORKSPACES ] && echo "Origin folder exists: \"$ORIGIN_WORKSPACES_FOLDER\". If you want to continue the process, please remove the origin folder manually or run this script with '-f | --force' flag. >>> Exit 1" && exit

rm -rf "$ORIGIN_WORKSPACES_FOLDER" && echo "Removed original workspaces folder >>> Done"

ln -s "$WORKSPACES_FOLDER" "$PROJECTS_DIR" && echo "Created a new symbolic link from $ORIGIN_WORKSPACES_FOLDER to $WORKSPACES_FOLDER >>> Done"

echo "Please restart your terminal or run \`source ~/.zshrc\` to reload .zshrc"
