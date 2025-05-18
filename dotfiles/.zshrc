#!/usr/bin/env zsh

# ==================================================================================================

# Name:         .zshrc
# Description:   zsh configuration for macOS, Ubuntu/Debian, and WSL

# ==================================================================================================

# ===> Add deno completions to search path =========================================================
if [[ ":$FPATH:" != *":/home/saltchang/.zsh/completions:"* ]]; then export FPATH="/home/saltchang/.zsh/completions:$FPATH"; fi
# ==================================================================================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# See https://github.com/foxundermoon/vs-shell-format/issues/336
if [ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${USER}.zsh" ]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${USER}.zsh"
fi

# ===> Terminal Setup Cache ========================================================================
TERMINAL_SETUP_CACHE="$HOME/.terminal-setup-cache"
# ==================================================================================================

# ===> Colors ======================================================================================
RED="\033[31m"
GREEN="\033[32m"
BLUE="\033[34m"
NC="\033[0m"
# ==================================================================================================

# ===> Detect OS and Shell =========================================================================

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
# ==================================================================================================

# ===> Detect Terminal App =========================================================================
TERMINAL_APP=""
ITERM="iTerm.app"
APPLE_TERMINAL="Apple_Terminal"
ALACRITTY="alacritty"

case $OS_NAME in
"$MACOS")
    case $TERM_PROGRAM in
    $ITERM)
        TERMINAL_APP=$ITERM
        ;;
    $APPLE_TERMINAL)
        TERMINAL_APP=$APPLE_TERMINAL
        ;;
    $ALACRITTY)
        TERMINAL_APP=$ALACRITTY
        ;;
    esac
    ;;
"$LINUX")
    case $TERM_PROGRAM in
    $ALACRITTY)
        TERMINAL_APP=$ALACRITTY
        ;;
    esac
    ;;
esac
# ==================================================================================================

# ===> Language Configuration (Optional) ===========================================================
# --------------------------------------------------------------------------------------------------
# -------> Set All to Traditional Chinese (Taiwan) -------------------------------------------------
# export LC_ALL="zh_TW.UTF-8" # sudo locale-gen zh_TW.UTF-8

# -------> Set All to English (United States) ------------------------------------------------------
# export LC_ALL="en_US.UTF-8" # sudo locale-gen en_US.UTF-8

# -------> Set By Details --------------------------------------------------------------------------
# Run `locale` to see the details of language configs

export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
# export LANG="zh_TW.UTF-8"
export LC_CTYPE="en_US.UTF-8"
# export LC_CTYPE="zh_TW.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
# export LC_MESSAGES="zh_TW.UTF-8"
# ==================================================================================================

# ===> Bind Keys ===================================================================================
case $OS_NAME in
"$MACOS")
    case $TERMINAL_APP in
    "$ALACRITTY")
        bindkey '^[[1;9D' beginning-of-line
        bindkey '^[[1;9C' end-of-line
        bindkey '^B' backward-word
        bindkey '^F' forward-word
        ;;
    esac
    ;;
"$LINUX") ;;
esac

# Bind keys for history-substring-search
# See: https://github.com/zsh-users/zsh-history-substring-search/issues/110#issuecomment-650832313
function _bind_keys_for_history_substring_search() {
    case $OS_NAME in
    "$MACOS")
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
        ;;
    "$LINUX")
        # https://superuser.com/a/1296543
        # key dict is defined in /etc/zsh/zshrc
        bindkey "$key[Up]" history-substring-search-up
        bindkey "$key[Down]" history-substring-search-down
        ;;
    esac
}
# ==================================================================================================

# ===> Zinit & Prezto ==============================================================================
# See: https://github.com/zdharma-continuum/zinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Load Prezto
zi snippet PZT::modules/helper/init.zsh

# Load Prezto modules
zi ice wait'!' blockf \
    atclone"git clone -q --depth=1 https://github.com/sorin-ionescu/prezto.git external"
zi snippet PZTM::git/alias.zsh
zi ice wait'!' blockf \
    atclone"git clone -q --depth=1 https://github.com/sorin-ionescu/prezto.git external"
zi snippet PZTM::git

zi ice wait'!'
zi snippet PZT::modules/gnu-utility

zi ice wait'!'
zi snippet PZT::modules/utility

zi ice wait'!'
zi snippet PZT::modules/python

zi ice wait'!' lucid \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zi load zdharma-continuum/fast-syntax-highlighting

# Poetry completion setup
# only runs when poetry is installed
if command -v poetry &>/dev/null; then
    zi ice wait'!' lucid as"completion" id-as"poetry-completion" \
        atclone"poetry completions zsh > _poetry" \
        atpull"%atclone" \
        run-atpull \
        pick"_poetry" \
        nocompile
    zi light zdharma-continuum/null
fi

zi ice wait'!' lucid blockf
zi load zsh-users/zsh-completions

zi ice wait'!' lucid atload"!_bind_keys_for_history_substring_search"
zi load zsh-users/zsh-history-substring-search

zi ice wait'!' lucid atload"!_zsh_autosuggest_start"
zi load zsh-users/zsh-autosuggestions

# Load the theme
zi ice depth=1
zi light romkatv/powerlevel10k

zi snippet PZT::modules/prompt

# Manually load the configuration file of Prezto
source ${ZDOTDIR:-$HOME}/.zpreztorc
# ==================================================================================================

# ===> asdf (Optional) =============================================================================
if [ ! -d "$HOME/.asdf" ] || [ -z "$HOME/.asdf/asdf.sh" ]; then
    echo "Installing asdf..."
    rm -rf "$HOME/.asdf"
    git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf
fi

. "$HOME/.asdf/asdf.sh"

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# check if asdf-nodejs plugin is installed
if ! asdf plugin list | grep -q "nodejs"; then
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
fi

# append "legacy_version_file = yes" to ~/.asdfrc to enable legacy version file if needed
if [ -f "$HOME/.asdfrc" ]; then
    if ! grep -q "legacy_version_file = yes" "$HOME/.asdfrc"; then
        echo "legacy_version_file = yes" >>"$HOME/.asdfrc"
    fi
else
    echo "legacy_version_file = yes" >"$HOME/.asdfrc"
fi
# ==================================================================================================

# ===> Base Directory of Projects ==================================================================
PROJS_BASE=$HOME/projects
[ ! -d "$PROJS_BASE" ] && mkdir -p "$PROJS_BASE"
[ ! -d "$PROJS_BASE/work" ] && mkdir -p "$PROJS_BASE/work"
[ ! -d "$PROJS_BASE/personal" ] && mkdir -p "$PROJS_BASE/personal"
[ ! -d "$PROJS_BASE/libs" ] && mkdir -p "$PROJS_BASE/libs"
# ==================================================================================================

# ===> Alias: Editor ===============================================================================
# VSCode (Setup required)
# https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line
alias edit='code' # VSCode

# alias edit='vim'
# alias vi='vim'
# ==================================================================================================

# ===> Alias: Basic Command ========================================================================
alias ls='echo && ls -hF --color=always'
alias ll='ls -l --time-style=long-iso --group-directories-first'
alias la='ll -a'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'
alias rm='rm -I -v --preserve-root'
alias mkdir='mkdir -pv'
alias ssh='ssh -v -tt -A' # Use '-vvv' for top-level verbose
alias ping='ping -c 5'
alias sudo='nocorrect sudo '
# ==================================================================================================

# ===> Functions: Shortcut =========================================================================
cl() {
    cd "$1" && la
}

home() {
    cl "$HOME"
    printf "\nWelcome home!\n\n"
}

gow() {
    cl "$PROJS_BASE/work"
    printf "\nOK, ready to work :)\n\n"
}

gop() {
    cl "$PROJS_BASE/personal"
    printf "\nOK, ready to do something amazing :)\n\n"
}

gol() {
    cl "$PROJS_BASE/libs"
    printf "\nHere are the third-party libraries :)\n\n"
}

# open with cursor
co() {
    if [ $SYS_IS_WSL ]; then
        if [ $# -gt 1 ]; then
            echo "Usage: \`co <path>\` or \`co\`"
        elif [ $# -eq 1 ]; then
            cursor --folder-uri "vscode-remote://wsl+${WSL_DISTRO_NAME}$1"
        else
            cursor --folder-uri "vscode-remote://wsl+${WSL_DISTRO_NAME}${PWD}"
        fi
    else
        if [ $# -gt 0 ]; then
            cursor "$@"
        else
            cursor .
        fi
    fi
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
alias go-rc-repo="cd $PROJS_BASE/personal/terminal-setup"
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

# ===> Python ======================================================================================
# --------> pyenv ----------------------------------------------------------------------------------
# to install pyenv run the following command
# curl https://pyenv.run | bash
export PYENV_ROOT="$HOME/.pyenv"
addToPATH "$PYENV_ROOT/bin"

# init pyenv if pyenv is installed
if [ -d "$PYENV_ROOT/bin" ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# Please remember to check the suggested build environment before installing Python versions with pyenv
# See: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
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

# ===> Zsh hooks ===================================================================================
# ---> Set terminal title to current directory -----------------------------------------------------

autoload -Uz add-zsh-hook

function set-title() {
    local window_title="\033]0;${PWD##*/}\007"
    echo -ne "$window_title"
}

add-zsh-hook precmd set-title
# --------------------------------------------------------------------------------------------------

# ---> Automatically use the correct node version if exists ----------------------------------------
autoload -U add-zsh-hook
load-node-version() {
    local asdf_node_version="$(asdf current nodejs 2>/dev/null | awk '{print $2}')"
    local directory_node_version=""
    local legacy_nvmrc_node_version=""

    if [ -f ".tool-versions" ]; then
        directory_node_version="$(cat .tool-versions | grep nodejs | awk '{print $2}')"
    elif [ -f ".nvmrc" ]; then
        # with legacy .nvmrc support
        legacy_nvmrc_node_version="$(cat .nvmrc)"
    fi

    local target_version="${directory_node_version:-$legacy_nvmrc_node_version}"

    if [ -n "$target_version" ]; then
        if [ "$asdf_node_version" != "$target_version" ]; then
            if ! asdf list nodejs | grep -q "$target_version"; then
                echo "Node version $target_version not installed. Installing..."
                asdf install nodejs "$target_version"
            fi
            asdf local nodejs "$target_version"
        fi
    fi
}
add-zsh-hook chpwd load-node-version
load-node-version
# --------------------------------------------------------------------------------------------------
# ==================================================================================================

# ===> Go ==========================================================================================
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
addToPATH $GOPATH/bin
addToPATH $GOROOT/bin:$PATH
# ==================================================================================================

# ===> Deno ========================================================================================
. "$HOME/.deno/env"
# ==================================================================================================

# ===> Path Configuration ==========================================================================
export PATH
typeset -U path # remove duplicates in $PATH
# ==================================================================================================

if [ "$0" = "$ZSH_SHELL_NAME" ]; then # don't run when source .zshrc
    # change directory to $HOME
    cd "$HOME" || exit
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# original code is `(( ! ${+functions[p10k]} )) || p10k finalize`,
# but the shell-format doesn't support the syntax of zsh
if type p10k >/dev/null 2>&1; then
    p10k finalize
fi

# ==================================================================================================
# End of File
# ==================================================================================================
