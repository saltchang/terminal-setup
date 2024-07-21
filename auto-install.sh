#!/bin/bash

# ===> Colors ======================================================================================
GREEN="\033[32m"
NC="\033[0m"
# ==================================================================================================

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

# ===> Prompt User for the repo to clone ===========================================================
printf "Please enter the terminal-setup github repo to clone (default: saltchang/terminal-setup): \n> "
read -r REPO </dev/tty

if [ -z "$REPO" ]; then
    REPO="saltchang/terminal-setup"
fi
# ==================================================================================================

# ===> Prompt User for installing Pnpm =============================================================
printf "\nDo you want to install pnpm? (y/n, default: y): \n> "
read -r INSTALL_PNPM </dev/tty

if [ -z "$INSTALL_PNPM" ]; then
    INSTALL_PNPM="y"
fi
# ==================================================================================================

echo
echo "Check and install necessary stuffs..."
echo

# ===> Basic Setup By System =======================================================================
case $OS_NAME in
"$MACOS")
    if ! [ -x "$(command -v brew)" ]; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    echo -e "${GREEN}homebrew is already installed${NC}"

    # install coreutils if it's not installed
    if ! [ -x "$(command -v greadlink)" ]; then
        echo "Installing coreutils..."
        brew install coreutils
    fi
    echo -e "${GREEN}coreutils is already installed${NC}"

    # install jump if it's not installed
    if ! [ -x "$(command -v jump)" ]; then
        echo "Installing jump..."
        brew install jump
    fi
    echo -e "${GREEN}jump is already installed${NC}"

    # install python3 if it's not installed via homebrew
    BREW_PYTHON_PATH=$(brew --prefix python3 2>/dev/null)
    if ! [ -x "$(command -v python3)" ] || [ -z "$BREW_PYTHON_PATH" ]; then
        echo "Installing python3..."
        brew install python3
    fi
    echo -e "${GREEN}python3 is already installed via homebrew${NC}"

    # install pipx if it's not installed
    if ! [ -x "$(command -v pipx)" ]; then
        echo "Installing pipx..."
        brew install pipx
    fi
    echo -e "${GREEN}pipx is already installed${NC}"
    ;;
"$LINUX")
    # install jump if it's not installed
    if ! [ -x "$(command -v jump)" ]; then
        sudo snap install jump
    fi
    echo -e "${GREEN}jump is already installed${NC}"
    ;;
*) ;;
esac
# ==================================================================================================

# ===> Install Fonts ===============================================================================
# download and install font if it's not installed: Meslo & Fira Code
case $OS_NAME in
"$MACOS")
    if ! [ -f "/Library/Fonts/MesloLGLNerdFont-Regular.ttf" ]; then
        echo "Installing Meslo..."
        curl -s -L -o /tmp/Meslo.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip
        unzip /tmp/Meslo.zip -d /tmp/Meslo
        cp /tmp/Meslo/*.ttf /Library/Fonts
    fi
    echo -e "${GREEN}font \"Meslo\" is already installed${NC}"

    if ! [ -f "/Library/Fonts/FiraCode-Regular.ttf" ]; then
        curl -s -L -o /tmp/FiraCode_v6.2.zip https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip
        unzip /tmp/FiraCode_v6.2.zip -d /tmp/FiraCode
        cp /tmp/FiraCode/ttf/*.ttf /Library/Fonts
    fi
    echo -e "${GREEN}font \"Fira Code\" is already installed${NC}"
    ;;
"$LINUX")
    if ! [ -f "/usr/local/share/fonts/MesloLGLNerdFont-Regular.ttf" ]; then
        curl -s -L -o /tmp/Meslo.tar.xz https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.tar.xz
        mkdir -p /tmp/Meslo
        tar xvf /tmp/Meslo.tar.xz -C /tmp/Meslo
        sudo cp /tmp/Meslo/*.ttf /usr/local/share/fonts
    fi
    echo -e "${GREEN}font \"Meslo\" is already installed${NC}"

    if ! [ -f "/usr/local/share/fonts/FiraCode-Regular.ttf" ]; then
        sudo apt install fonts-firacode
        sudo fc-cache -f -v
    fi
    echo -e "${GREEN}font \"Fira Code\" is already installed${NC}"
    ;;
*) ;;
esac
# ==================================================================================================

# ===> Install packages ============================================================================
# Install pnpm if it's not installed
if [ "$INSTALL_PNPM" = "y" ]; then
    if ! [ -x "$(command -v pnpm)" ]; then
        echo "Installing pnpm..."
        curl -fsSL https://get.pnpm.io/install.sh | sh -
    fi
    echo -e "${GREEN}pnpm is already installed${NC}"
fi
# ==================================================================================================

# ===> Setup zsh ===================================================================================
# install zsh if it's not installed
if ! [ -x "$(command -v zsh)" ]; then
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
echo -e "${GREEN}zsh is already installed${NC}"

# set zsh as default shell if not
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
fi
echo -e "${GREEN}zsh is already set as default shell${NC}"
# ==================================================================================================

# ===> Clone and setup =============================================================================
mkdir -p "$HOME/projects/personal"
cd "$HOME/projects/personal" || exit 1

if [ -d "$HOME/projects/personal/terminal-setup" ]; then
    echo -e "${GREEN}terminal-setup is already cloned${NC}"
else
    echo "Cloning terminal-setup..."
    # check if git ssh key is setup
    if [ -f "$HOME/.ssh/id_rsa" ] || [ -f "$HOME/.ssh/id_ed25519" ]; then
        git clone "git@github.com:$REPO.git" || (echo -e "\nFailed to clone the repo via ssh, try https..\n" && git clone "https://github.com/$REPO.git")
    else
        git clone "https://github.com/$REPO.git"
    fi
fi

cd terminal-setup || exit 1

echo

./install.sh
