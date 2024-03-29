#!/bin/bash
# shellcheck disable=SC2034

# ==================================================================================================

# Name:         .zshrc
# Description:   zsh configuration for macOS, Linux, and WSL

# ==================================================================================================

# ===> Terminal Setup Cache ========================================================================
TERMINAL_SETUP_CACHE="$HOME/.terminal-setup-cache"
# ==================================================================================================

# ===> Colors ======================================================================================
RED="\033[31m"
GREEN="\033[32m"
BLUE="\033[34m"
NC="\033[0m"
# ==================================================================================================

# ===> Auto Detect OS and Shell ====================================================================

MS="Microsoft"
UBUNTU="Ubuntu"
DEBIAN="Debian"
RHEL="RedHatEnterpriseServer"
LINUX="Linux"
MACOS="macOS"

ARM64="arm64"
X86_64="x86_64"

ZSH_SHELL_NAME="-zsh"

PROC_VERSION_PATH="/proc/version"

if [ -f $PROC_VERSION_PATH ]; then
    PROC_VERSION=$(cat $PROC_VERSION_PATH)
    if echo "$PROC_VERSION" | grep -iqF $MS; then
        SYS_IS_WSL=YES
    fi
fi

case $(uname) in

Darwin)
    OS_NAME=$MACOS

    case $(uname -m) in

    $ARM64)
        PROCESSOR_ARCHITECTURE=$ARM64
        ;;
    $X86_64)
        PROCESSOR_ARCHITECTURE=$X86_64
        ;;
    esac
    ;;

Linux)
    OS_NAME=$LINUX
    OS_INFO=$(lsb_release -a)

    case $OS_INFO in
    *"$UBUNTU"*)
        DISTRO_NAME=$UBUNTU
        ;;
    *"$DEBIAN"*)
        DISTRO_NAME=$DEBIAN
        ;;
    *"$RHEL"*)
        DISTRO_NAME=$RHEL
        ;;
    esac
    ;;
esac

# ===> Terminal Tab Title (Optional) ===============================================================
# DISABLE_AUTO_TITLE="true"
# ==================================================================================================

# ===> Language Configuration (Optional) ===========================================================
# --------------------------------------------------------------------------------------------------
# -------> Set All to Traditional Chinese (Taiwan) -------------------------------------------------
# export LC_ALL="zh_TW.UTF-8" # sudo locale-gen zh_TW.UTF-8

# -------> Set All to English (United States) ------------------------------------------------------
# export LC_ALL="en_US.UTF-8"

# -------> Set By Details --------------------------------------------------------------------------
export LANG="zh_TW.UTF-8"
# export LANG="en_US.UTF-8"

# Run `locale` to see the details of language configs

# export LC_CTYPE="zh_TW.UTF-8"
# export LC_NUMERIC="zh_TW.UTF-8"
# export LC_TIME="zh_TW.UTF-8"
# export LC_COLLATE="zh_TW.UTF-8"
# export LC_MONETARY="zh_TW.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
# export LC_PAPER="zh_TW.UTF-8"
# export LC_NAME="zh_TW.UTF-8"
# export LC_ADDRESS="zh_TW.UTF-8"
# export LC_TELEPHONE="zh_TW.UTF-8"
# export LC_MEASUREMENT="zh_TW.UTF-8"
# export LC_IDENTIFICATION="zh_TW.UTF-8"
# ==================================================================================================

# ===> Proxy (Optional) ============================================================================
# PROXY="http://proxy-web.company.com:80"
# NO_PROXY="localhost,127.0.0.1,.company.com"

# export PROXY=$PROXY
# export HTTP_PROXY=$PROXY
# export HTTPS_PROXY=$PROXY
# export ALL_PROXY=$PROXY
# export NO_PROXY=$NO_PROXY
# export proxy=$PROXY
# export http_proxy=$PROXY
# export https_proxy=$PROXY
# export all_proxy=$PROXY
# export no_proxy=$NO_PROXY
# ==================================================================================================

# ===> CA Certificate (Optional) ===================================================================
# CA_FILE="/usr/local/share/ca-certificates/certnew.crt"
# --------> For OpenSSL ----------------------------------------------------------------------------
# export SSL_CERT_FILE=$CA_FILE
# --------> For NodeJS -----------------------------------------------------------------------------
# export NODE_EXTRA_CA_CERTS=$CA_FILE
# ==================================================================================================

# ===> Powerlevel: Profile =========================================================================
POWERLEVEL9K_MODE="nerdfont-complete"
# ==================================================================================================

# ===> Powerlevel: Prompt Newline ==================================================================
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
# ==================================================================================================

# ===> Powerlevel: Prompt Elements =================================================================
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user host dir dir_writable newline vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    pyenv omzsh_prompt_node_version node_version go_version dotnet_version package newline
    status history time os_icon
)
# ==================================================================================================

# ===> Powerlevel: Prompt Prefix ===================================================================

case $OS_NAME in
"$MACOS")
    POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="\u2570\u2500\u27A4 "
    ;;
"$LINUX")
    POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="\u2570\u2500\u2B9E "
    POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="\u256D\u2500"
    ;;
esac
# ==================================================================================================

# ===> Powerlevel (For Linux) ======================================================================
case $OS_NAME in
"$MACOS")
    POWERLEVEL9K_OS_ICON_FOREGROUND="255"
    POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"
    ;;
"$LINUX")
    # Segment
    POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\uE0B0'
    POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\uE0B2'

    # Icon
    POWERLEVEL9K_OS_ICON_BACKGROUND="233"
    case $DISTRO_NAME in
    "$UBUNTU")
        POWERLEVEL9K_OS_ICON_FOREGROUND="202" # For Ubuntu
        ;;

    "$DEBIAN")
        POWERLEVEL9K_OS_ICON_FOREGROUND="204" # For Debian
        ;;

    "$RHEL")
        POWERLEVEL9K_LINUX_ICON="\uF316"      # For RedHat
        POWERLEVEL9K_OS_ICON_FOREGROUND="197" # For Redhat
        ;;
    esac

    # Other
    POWERLEVEL9K_STATUS_BACKGROUND="059"
    ;;
esac

# ==================================================================================================

# ===> Powerlevel: Other Config (For All) ==========================================================
POWERLEVEL9K_STATUS_CROSS=true
POWERLEVEL9K_STATUS_OK=true

POWERLEVEL9K_TIME_BACKGROUND="179"
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"

POWERLEVEL9K_DIR_FOREGROUND="017"
POWERLEVEL9K_DIR_BACKGROUND="116"

POWERLEVEL9K_USER_FOREGROUND="208"
POWERLEVEL9K_USER_BACKGROUND="229"

POWERLEVEL9K_STATUS_OK_FOREGROUND="156"
POWERLEVEL9K_STATUS_ERROR_FOREGROUND="160"
POWERLEVEL9K_STATUS_HIDE_SIGNAME=true
POWERLEVEL9K_STATUS_SHOW_PIPESTATUS=false

POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="208"
POWERLEVEL9K_VCS_BACKGROUND="078"
# ==================================================================================================

# ===> Antigen =====================================================================================
# See: https://github.com/zsh-users

ADOTDIR="$HOME/.antigen"
ANTIGEN_ZSH="$ADOTDIR/antigen.zsh"
ANTIGEN_LOG="$ADOTDIR/antigen.log"
_ANTIGEN_CACHE_ENABLED="false"

[ ! -d "$ADOTDIR" ] && mkdir "$ADOTDIR"
[ ! -f "$ANTIGEN_ZSH" ] && curl -L git.io/antigen >"$ANTIGEN_ZSH"

# shellcheck source=/dev/null
[ -s "$ANTIGEN_ZSH" ] && source "$ANTIGEN_ZSH"

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle emoji
antigen bundle gh
antigen bundle gnu-utils

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle lukechilds/zsh-nvm

# workaround for https://github.com/zsh-users/antigen/issues/675theme_antigen() {
THEME=romkatv/powerlevel10k
antigen list | grep $THEME
if [ $? -ne 0 ]; then echo "Launch antigen" && antigen theme $THEME; fi

antigen apply
# ==================================================================================================

# ===> Base Directory of Projects ==================================================================
PROJS_BASE=$HOME/projects
[ ! -d "$PROJS_BASE" ] && mkdir -p "$PROJS_BASE"
[ ! -d "$PROJS_BASE/work" ] && mkdir -p "$PROJS_BASE/work"
[ ! -d "$PROJS_BASE/personal" ] && mkdir -p "$PROJS_BASE/personal"
[ ! -d "$PROJS_BASE/games" ] && mkdir -p "$PROJS_BASE/games"
[ ! -d "$PROJS_BASE/archived" ] && mkdir -p "$PROJS_BASE/archived"
[ ! -d "$PROJS_BASE/lib" ] && mkdir -p "$PROJS_BASE/lib"
# ==================================================================================================

# ===> Path ========================================================================================
# --------> Avoid repeated PATH statements ---------------------------------------------------------
addToPATH() {
    case ":$PATH:" in
    *":$1:"*) : ;;        # already there
    *) PATH="$1:$PATH" ;; # or PATH="$PATH:$1"
    esac
}

# --------> Basic Binary ---------------------------------------------------------------------------
addToPATH "$HOME/bin"
addToPATH "/usr/local/bin"

# --------> For Yarn (Optional) --------------------------------------------------------------------
addToPATH "$HOME/.yarn/bin"

# --------> For Godot (Optional) -------------------------------------------------------------------
# export GODOT4_BIN=/Applications/Godot.app/Contents/MacOS/Godot

# --------> For Laravel (Optional) -----------------------------------------------------------------
addToPATH "$HOME/.composer/vendor/bin"

# --------> For Pyenv (Optional) -------------------------------------------------------------------
# export PYENV_ROOT="$HOME/.pyenv"
# addToPATH "$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init --path)"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# --------> Go (Optional) --------------------------------------------------------------------------
export GOPATH="$HOME/go"
[ ! -d "$GOPATH" ] && mkdir -p "$GOPATH"
addToPATH "$GOPATH/bin"

# if [ -x "$(command -v go)" ]; then
#     LATEST_GO_VERSION=$(curl -sL https://go.dev/dl/\#stable | grep -A10 'id="stable"' | grep -o 'id="go[0-9\.]*"' | grep -o 'go[0-9\.]*' | grep -o '[0-9\.]*')
#     CURRENT_GO_VERSION=$(go version | grep -o 'go[0-9\.]*' | grep -o '[0-9\.]*')
#     if [ "$CURRENT_GO_VERSION" != "$LATEST_GO_VERSION" ]; then
#         echo
#         echo "Go update available! ${RED}$CURRENT_GO_VERSION${NC} → ${GREEN}$LATEST_GO_VERSION${NC}"
#         echo
#     fi
# fi
# --------> Export PATH ----------------------------------------------------------------------------
export PATH
# ==================================================================================================

# ===> Alias: Editor ===============================================================================
# VSCode (Setup required)
# https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line
alias edit='code' # VSCode

# alias edit='vim'
# alias vi='vim'
# ==================================================================================================

# ===> Alias: Basic Command ========================================================================
case $OS_NAME in
"$MACOS")
    # alias ls='echo && ls -hF'
    # alias ll='ls -l'

    # if you see "command not found: gls" in macOS, run to install the requirement:
    # brew install c

    if hash gls 2>/dev/null; then
        alias ls='echo && gls -hF --color=always'
        alias ll='ls -l --time-style=long-iso --group-directories-first'
        alias rm='rm -iv'

    else
        echo
        echo "coreutils is not installed, please install it with: "
        echo
        echo "    $ brew install coreutils"
        echo
        echo "Then restart the terminal."
    fi
    ;;

"$LINUX")
    alias ls='echo && ls -hF --color=always'
    alias ll='ls -l --time-style=long-iso --group-directories-first'
    alias rm='rm -I -v --preserve-root'
    alias chown='chown --preserve-root'
    alias chmod='chmod --preserve-root'
    alias chgrp='chgrp --preserve-root'
    ;;
esac

alias la='ll -a'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'
alias mkdir='mkdir -pv'
alias ssh='ssh -v -tt -A' # Use '-vvv' for top-level verbose
alias ping='ping -c 5'
alias mk='make'
alias sudo='sudo '
alias codes='code-insiders'
# ==================================================================================================

# ===> Functions: Shortcut =========================================================================
cl() {
    cd "$1" && ls -l
}

home() {
    cl "$HOME"
    printf "\nWelcome home!\n\n"
}

goj() {
    cl "$PROJS_BASE"
    printf "\nOK, ready to do something amazing :)\n\n"
}

gow() {
    cl "$PROJS_BASE/work"
    printf "\nOK, ready to work :)\n\n"
}

gop() {
    cl "$PROJS_BASE/personal"
    printf "\nOK, ready to do something amazing :)\n\n"
}

gog() {
    cl "$PROJS_BASE/games"
    printf "\nOK, ready to do something amazing :)\n\n"
}

goa() {
    cl "$PROJS_BASE/archived"
    printf "\nHere are the archived projects :)\n\n"
}

gol() {
    cl "$PROJS_BASE/lib"
    printf "\nHere are the third-party libraries :)\n\n"
}

gogo() {
    cl "$GOPATH"
    printf "\nOK, you are ready to Go :)\n\n"
}

megu() {
    local MEGUMIIN_PROJ_DIR=$PROJS_BASE/personal/megumiin

    cl "$MEGUMIIN_PROJ_DIR"
    code .
    printf "\nOK, you are ready to megumiin :)\n\n"
}

if [ $SYS_IS_WSL ]; then
    # go to Windows Disk C
    win() {
        cd "/mnt/c" || exit
        printf "\nOK, you are now in disk: C!\n\n"
    }
    # open with Windows Explorer
    open() {
        explorer.exe "$1"
    }
fi

# ==================================================================================================

# ===> Alias: Update & Upgrade Packages ============================================================
case $OS_NAME in
"$MACOS")
    unu() {
        brew update -v && brew upgrade -v
    }
    ;;
"$LINUX")
    case $DISTRO_NAME in
    "$RHEL") ;;
    *)
        unu() {
            sudo apt-get update && sudo apt-get upgrade
        }
        ;;
    esac
    ;;
esac
# ==================================================================================================

# ===> Alias: Shortcut =============================================================================
alias c='clear'
alias edit-rc='edit $HOME/.zshrc'
alias go-rc-repo="cd $PROJS_BASE/personal/terminal-setup"
alias grr=go-rc-repo
alias edit-ssh='edit $HOME/.ssh/config'
alias source-rc='source $HOME/.zshrc'
alias paths='echo && echo -e ${PATH//:/\\n} | sort -n'
alias weather='curl wttr.in && echo && curl v2.wttr.in'

# --------> Git shortcuts --------------------------------------------------------------------------
# https://kapeli.com/cheat_sheets/Oh-My-Zsh_Git.docset/Contents/Resources/Documents/index

# Clear local branches (except main and develop)
# alias gclb='git branch | grep -v -e "main" -e "develop" | xargs git branch -D'
alias gclb='git branch \
| grep -v -w main \
| grep -v -w develop \
| grep -v -e $(git rev-parse --abbrev-ref HEAD) \
| grep -v -e " release-*" \
| grep -v -e " release/*" \
>/tmp/branches-to-clean && vim /tmp/branches-to-clean && xargs git branch -D </tmp/branches-to-clean'

alias gclmb='git branch --merged \
| grep -v -w main \
| grep -v -w develop \
| grep -v -e $(git rev-parse --abbrev-ref HEAD) \
| grep -v -e " release-*" \
| grep -v -e " release/*" \
>/tmp/merged-branches && vim /tmp/merged-branches && xargs git branch -d </tmp/merged-branches'

alias gfap='gfa && git pull'
alias gfapr='gfa && git pull --rebase'
alias gpuoc='git push -u origin $(git branch --show-current)'
# --------------------------------------------------------------------------------------------------

case $OS_NAME in
"$MACOS") ;;
"$LINUX")
    alias ffind='find * -type f | fzf' # sudo apt-get -y install fzf
    alias monitor='gotop -r 1s -a -s'  # https://github.com/xxxserxxx/gotop
    case $DISTRO_NAME in
    "$RHEL") ;;
    *)
        # sudo apt-get -y install ncdu
        alias mand='sudo ncdu --exclude /mnt -e --color=dark /'
        ;;
    esac
    ;;
esac

# --------> List all ports -------------------------------------------------------------------------
case $OS_NAME in
"$MACOS")
    alias ports='sudo lsof -iTCP -sTCP:LISTEN -n -P'
    ;;
"$LINUX")
    if [ -x "$(command -v netstat)" ]; then
        alias ports='netstat -tulanp'
    else
        case $DISTRO_NAME in
        "$RHEL") ;;
        *)
            echo "net-tools is not installed, please run 'sudo apt-get -y install net-tools' to install it."
            ;;
        esac
    fi
    ;;
esac
# ==================================================================================================

# ===> Python 3 shortcut (Optional) ================================================================
alias python='python3'
# ==================================================================================================

# ===> PNPM (Optional) =============================================================================
export PNPM_HOME="$HOME/.pnpm"
addToPATH "$PNPM_HOME"
# ==================================================================================================

# ===> Docker (Optional) ===========================================================================
alias docker-all='docker ps -a --format "{{.Names}} ({{.ID}}): {{.Image}} ({{.Ports}})"'
alias docker-ls='docker ps --format "{{.Names}} ({{.ID}}): {{.Image}} ({{.Ports}})"'
# ==================================================================================================

# ===> Git (Optional) ==============================================================================
# --------> Global Configuration -------------------------------------------------------------------
GIT_EDITOR="vim"
# GIT_EDITOR="code"

git config --global pull.ff only              # set git pull --ff-only
git config --global init.defaultBranch main   # set default init branch
git config --global core.editor "$GIT_EDITOR" # set default editor

# --------> Quickly update Git ---------------------------------------------------------------------
update_git() {
    printf "\nCurrent %s\n\n" "$(git --version)"
    printf "Start to update Git...\n\n"
    case $OS_NAME in
    "$MACOS")
        brew list git || brew install git
        brew update && brew upgrade git &&
            printf "\nCurrent %s\n\n" "$(git --version)" &&
            printf "Git updated successfully.\n\n" &&
            source-rc
        ;;
    "$LINUX")
        case $DISTRO_NAME in
        "$RHEL") ;;
        *)
            sudo add-apt-repository ppa:git-core/ppa -y &&
                sudo apt-get update &&
                sudo apt-get install git -y &&
                printf "\nCurrent %s\n\n" "$(git --version)" &&
                printf "Git updated successfully.\n"
            ;;
        esac
        ;;
    esac
}
# ==================================================================================================

# ===> SSH Agent (Optional) ========================================================================
if [ "$0" = "$ZSH_SHELL_NAME" ]; then # don't run when source .zshrc
    # SSH_KEY_FILE=$HOME/.ssh/id_rsa
    SSH_KEY_FILE=$HOME/.ssh/id_ed25519

    if [ "$(eval 'ps ax | grep "[s]sh-agent" | wc -l' 2>/dev/null)" -gt 0 ]; then
        echo "ssh-agent is already running" >/dev/null
    else
        eval "$(ssh-agent -s)"
        if [[ "$(ssh-add -l)" == "The agent has no identities." ]]; then
            ssh-add "$SSH_KEY_FILE"
        fi
        # Kill it on exit. You may not want this part.
        # trap "ssh-agent -k" EXIT
    fi
fi
# ==================================================================================================

# ===> Docker Deamon (Optional for WSL) ============================================================
# if [ $SYS_IS_WSL ]; then
#     DOCKER_GROUP_NAME="docker"
#     if [ $(getent group $DOCKER_GROUP_NAME) ]; then # check if group docker is installed
#         DOCKER_DISTRO=$DISTRO_NAME                  # Run `wsl -l -q` in Powershell to see all distros
#         DOCKER_DIR=/mnt/wsl/shared-docker
#         DOCKER_SOCK="$DOCKER_DIR/docker.sock"
#         export DOCKER_HOST="unix://$DOCKER_SOCK"
#         if [ ! -S "$DOCKER_SOCK" ]; then
#             mkdir -p "$DOCKER_DIR"
#             chmod o=,ug=rwx "$DOCKER_DIR"
#             chgrp docker "$DOCKER_DIR"
#             /mnt/c/Windows/System32/wsl.exe -d $DOCKER_DISTRO sh -c "nohup sudo -b dockerd < /dev/null > $DOCKER_DIR/dockerd.log 2>&1"

#             # An symbolink config for VSCode
#             if [ ! -L "/run/docker.sock" ]; then
#                 sudo sh -c "ln -s $DOCKER_SOCK /run/docker.sock"
#             fi
#         fi
#     fi
# fi
# ==================================================================================================

# ===> Check Git Version ===========================================================================
function git() {
    local LAST_CHECK_TIME=0
    local LAST_CHECK_FILE="${TERMINAL_SETUP_CACHE}/.git_last_check"

    local CHECK_INTERVAL_DAYS=1
    local CHECK_INTERVAL=$((60 * 60 * 24 * ${CHECK_INTERVAL_DAYS})) # 60s * 60m * 24h * n days

    local CURRENT_TIME=$(date +%s)

    local SHOULD_FIRST_CHECK=NO

    if [[ -f $LAST_CHECK_FILE ]]; then
        LAST_CHECK_TIME=$(cat $LAST_CHECK_FILE)
    else
        mkdir -p ${TERMINAL_SETUP_CACHE} >/dev/null 2>&1
        SHOULD_FIRST_CHECK=YES
    fi

    if [[ $((CURRENT_TIME - LAST_CHECK_TIME)) -gt ${CHECK_INTERVAL} || ${SHOULD_FIRST_CHECK} == 'YES' ]]; then
        echo -e "\nChecking Git version..."

        local LOCAL_GIT_VERSION=$(command git --version | cut -d ' ' -f 3)
        local LATEST_GIT_VERSION=$(curl --silent https://mirrors.edge.kernel.org/pub/software/scm/git/ | grep tar | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | sort --version-sort | tail -1)

        if [[ $(echo "$LOCAL_GIT_VERSION $LATEST_GIT_VERSION" | tr ' ' '\n' | sort -Vr | head -n 1) != "$LOCAL_GIT_VERSION" ]]; then
            echo -e "New version of Git is available! ${RED}${LOCAL_GIT_VERSION}${NC} → ${GREEN}${LATEST_GIT_VERSION}${NC}"
            echo -e "Run the command: ${BLUE}update_git${NC} to update it."
        else
            echo -e "Your current Git version ${GREEN}${LOCAL_GIT_VERSION}${NC} is up to date."
        fi

        echo
    fi

    echo ${CURRENT_TIME} >${LAST_CHECK_FILE}

    command git "$@"
}
# ==================================================================================================

# ===> Check Rust Version ==========================================================================
function cargo() {
    local LAST_CHECK_TIME=0
    local LAST_CHECK_FILE="${TERMINAL_SETUP_CACHE}/.rust_last_check"

    local CHECK_INTERVAL_DAYS=1
    local CHECK_INTERVAL=$((60 * 60 * 24 * ${CHECK_INTERVAL_DAYS})) # 60s * 60m * 24h * n days

    local CURRENT_TIME=$(date +%s)

    local SHOULD_FIRST_CHECK=NO

    if [[ -f $LAST_CHECK_FILE ]]; then
        LAST_CHECK_TIME=$(cat $LAST_CHECK_FILE)
    else
        mkdir -p ${TERMINAL_SETUP_CACHE} >/dev/null 2>&1
        SHOULD_FIRST_CHECK=YES
    fi

    if [[ $((CURRENT_TIME - LAST_CHECK_TIME)) -gt ${CHECK_INTERVAL} || ${SHOULD_FIRST_CHECK} == 'YES' ]]; then
        echo -e "\nChecking Rust version..."

        local LOCAL_RUST_VERSION=$(command rustc --version | cut -d ' ' -f 2)
        local LATEST_RUST_VERSION=$(curl --silent https://github.com/rust-lang/rust/tags | grep /rust-lang/rust/releases/tag/ | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | sort --version-sort | tail -1)

        if [[ $(echo "$LOCAL_RUST_VERSION $LATEST_RUST_VERSION" | tr ' ' '\n' | sort -Vr | head -n 1) != "$LOCAL_RUST_VERSION" ]]; then
            echo -e "New version of Rust is available! ${RED}${LOCAL_RUST_VERSION}${NC} → ${GREEN}${LATEST_RUST_VERSION}${NC}"
            echo -e "Run the command: ${BLUE}rustup update${NC} to update it."
        else
            echo -e "Your current Rust version ${GREEN}${LOCAL_RUST_VERSION}${NC} is up to date."
        fi

        echo
    fi

    echo ${CURRENT_TIME} >${LAST_CHECK_FILE}

    command cargo "$@"
}
# ==================================================================================================

typeset -U path                       # remove duplicates in $PATH
if [ "$0" = "$ZSH_SHELL_NAME" ]; then # don't run when source .zshrc

    # update & upgrade packages once shell launched
    # { [ $DISTRO_NAME = $UBUNTU ] || [ $OS_NAME = $MACOS ]; } && unu

    # change directory to $HOME
    # cd "$HOME" || exit

    cd "$PROJS_BASE/personal" || exit
fi

# ==================================================================================================
# End of File
# ==================================================================================================
