#!/bin/bash
# shellcheck disable=SC2034

# ==================================================================================================

# Name:         .zshrc
# Description:   zsh configuration for macOS, Linux, and WSL

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
antigen bundle docker
antigen bundle emoji
antigen bundle gh
antigen bundle gnu-utils

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle lukechilds/zsh-nvm

theme_antigen() {
    antigen theme romkatv/powerlevel10k
}

if [ "$0" = $ZSH_SHELL_NAME ]; then # don't run when source .zshrc
    echo "Launch antigen"
    theme_antigen
fi

antigen apply
# ==================================================================================================

# ===> Base Directory of Projects ==================================================================
PROJS_BASE=$HOME/projects
[ ! -d "$PROJS_BASE" ] && mkdir -p "$PROJS_BASE"
[ ! -d "$PROJS_BASE/work" ] && mkdir -p "$PROJS_BASE/work"
[ ! -d "$PROJS_BASE/personal" ] && mkdir -p "$PROJS_BASE/personal"
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

# --------> For Laravel (Optional) -----------------------------------------------------------------
addToPATH "$HOME/.composer/vendor/bin"

# --------> For Pyenv (Optional) -------------------------------------------------------------------
# export PYENV_ROOT="$HOME/.pyenv"
# addToPATH "$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init --path)"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# --------> Go Language (Optional) -----------------------------------------------------------------
export GOPATH="$HOME/go"
[ ! -d "$GOPATH" ] && mkdir -p "$GOPATH"
addToPATH "$GOPATH/bin"

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
    printf "\nWelcome home!\n"
}

goj() {
    cl "$PROJS_BASE"
    printf "\nOK, ready to do something amazing :)\n"
}

gow() {
    cl "$PROJS_BASE/work"
    printf "\nOK, ready to work :)\n"
}

gop() {
    cl "$PROJS_BASE/personal"
    printf "\nOK, ready to do something amazing :)\n"
}

goa() {
    cl "$PROJS_BASE/archived"
    printf "\nHere are the archived projects :)\n"
}

gol() {
    cl "$PROJS_BASE/lib"
    printf "\nHere are the third-party libraries :)\n"
}

gogo() {
    cl "$GOPATH"
    printf "\nOK, you are ready to Go :)\n"
}

megu() {
    local MEGUMIIN_PROJ_DIR=$PROJS_BASE/personal/megumiin

    cl "$MEGUMIIN_PROJ_DIR"
    code .
    printf "\nOK, you are ready to megumiin :)\n"
}

if [ $SYS_IS_WSL ]; then
    # go to Windows Disk C
    win() {
        cd "/mnt/c" || exit
        printf "\nOK, you are now in disk: C!\n"
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
alias edit-ssh='edit $HOME/.ssh/config'
alias source-rc='source $HOME/.zshrc'
alias paths='echo && echo -e ${PATH//:/\\n} | sort -n'
alias weather='curl wttr.in && echo && curl v2.wttr.in'

# --------> Git shortcuts -------------------------------------------------------------------------
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
# alias python='python3'
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

typeset -U path                       # remove duplicates in $PATH
if [ "$0" = "$ZSH_SHELL_NAME" ]; then # don't run when source .zshrc

    # update & upgrade packages once shell launched
    # { [ $DISTRO_NAME = $UBUNTU ] || [ $OS_NAME = $MACOS ]; } && unu

    # change directory to $HOME
    cd "$HOME" || exit
fi

# ==================================================================================================
# End of File
# ==================================================================================================
