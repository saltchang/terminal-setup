OS_NAME=""
LINUX="Linux"
MACOS="macOS"

case $(uname) in
Darwin)
    OS_NAME=$MACOS
    ;;

Linux)
    OS_NAME=$LINUX
    ;;
esac

# ===> Homebrew (macOS only) =======================================================================
case $OS_NAME in
"$MACOS")
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ;;
esac
# ==================================================================================================

# ===> Jump ========================================================================================
eval "$(jump shell)"
# ==================================================================================================

# ===> SSH Agent (Optional) ========================================================================
SSH_KEY_FILE=$HOME/.ssh/id_ed25519

if ! [ "$(eval 'ps ax | grep "[s]sh-agent" | wc -l' 2>/dev/null)" -gt 0 ]; then
    eval "$(ssh-agent -s)"
    if [[ "$(ssh-add -l)" == "The agent has no identities." ]]; then
        ssh-add "$SSH_KEY_FILE"
    fi
    # Kill it on exit. You may not want this part.
    # trap "ssh-agent -k" EXIT
fi
# ==================================================================================================
