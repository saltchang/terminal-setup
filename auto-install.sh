#!/bin/bash

case $(uname) in
Darwin)
    OS_NAME=$MACOS
    ;;

Linux)
    OS_NAME=$LINUX
    ;;
esac

# ===> Prompt User for the repo to clone ===========================================================
printf "Please enter the terminal-setup github repo to clone (default: saltchang/terminal-setup): \n> "
read -r REPO

if [ -z "$REPO" ]; then
    REPO="saltchang/terminal-setup"
fi
# ==================================================================================================

# ===> Basic Setup By System =======================================================================
case $OS_NAME in
"$MACOS")
    if [ -x "$(command -v brew)" ]; then
        echo "Homebrew is already installed"
    else
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        echo "eval \"\$(/opt/homebrew/bin/brew shellenv)\"" >>"$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # install coreutils if it's not installed in homebrew
    if [ -x "$(command -v greadlink)" ]; then
        echo "coreutils is already installed"
    else
        echo "Installing coreutils..."
        brew install coreutils
    fi
    ;;
*) ;;
esac

# ===> Install Fonts ===============================================================================
# download and install font if it's not installed: Meslo & Fira Code
case $OS_NAME in
"$MACOS")
    if [ -f "/Library/Fonts/MesloLGLNerdFont-Regular.ttf" ]; then
        echo "Meslo is already installed"
    else
        curl -s -L -o /tmp/Meslo.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip
        unzip /tmp/Meslo.zip -d /tmp/Meslo
        cp /tmp/Meslo/*.ttf /Library/Fonts
    fi

    if [ -f "/Library/Fonts/FiraCode-Regular.ttf" ]; then
        echo "Fira Code is already installed"
    else
        curl -s -L -o /tmp/FiraCode_v6.2.zip https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip
        unzip /tmp/FiraCode_v6.2.zip -d /tmp/FiraCode
        cp /tmp/FiraCode/ttf/*.ttf /Library/Fonts
    fi
    ;;
"$LINUX")
    if [ -f "/usr/local/share/fonts/MesloLGLNerdFont-Regular.ttf" ]; then
        echo "Meslo is already installed"
    else
        curl -s -L -o /tmp/Meslo.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip
        unzip /tmp/Meslo.zip -d /tmp/Meslo
        sudo cp /tmp/Meslo/*.ttf /usr/local/share/fonts
    fi

    if [ -f "/usr/local/share/fonts/FiraCode-Regular.ttf" ]; then
        echo "Fira Code is already installed"
    else
        sudo apt install fonts-firacode
        sudo fc-cache -f -v
    fi
    ;;
*) ;;
esac
# ==================================================================================================

# ===> Setup zsh ===================================================================================
# install zsh if it's not installed
if [ -x "$(command -v zsh)" ]; then
    echo "zsh is already installed"
else
    case $OS_NAME in
    "$MACOS")
        brew install zsh
        ;;
    "$LINUX")
        sudo apt update && sudo apt -y install zsh
        ;;
    *) ;;
    esac
fi

# set zsh as default shell if not
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
fi
# ==================================================================================================

# ===> Clone and setup =============================================================================
mkdir -p "$HOME/projects/personal"
cd "$HOME/projects/personal" || exit 1

if [ -d "$HOME/projects/personal/terminal-setup" ]; then
    echo "terminal-setup is already cloned"
else
    # check if git ssh key is setup
    if [ -f "$HOME/.ssh/id_rsa" ] || [ -f "$HOME/.ssh/id_ed25519" ]; then
        git clone "git@github.com:$REPO.git" >/dev/null 2>&1 || echo "Failed to clone terminal-setup via ssh, try https" && git clone "https://github.com/$REPO.git"
    else
        git clone "https://github.com/$REPO.git"
    fi
fi

cd terminal-setup || exit 1

./install.sh
