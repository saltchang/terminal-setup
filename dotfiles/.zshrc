#!/usr/bin/env zsh
# shellcheck disable=SC2034

# ==================================================================================================

# Name:         .zshrc
# Description:   zsh configuration for macOS, Linux, and WSL

# ==================================================================================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# See https://github.com/foxundermoon/vs-shell-format/issues/336
if [ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${USER}.zsh" ]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${USER}.zsh"
fi

unset prompt_cr

# ===> Terminal Setup Cache ========================================================================
TERMINAL_SETUP_CACHE="$HOME/.terminal-setup-cache"
# ==================================================================================================

# ===> Terminal Setup Bin ========================================================================
TERMINAL_SETUP_LOCAL_BIN_DIR="$HOME/.local/terminal-setup/bin"
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

# ===> Zinit & Prezto ==============================================================================
# See: https://github.com/zdharma-continuum/zinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

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

zi ice wait'!' lucid \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zi load zdharma-continuum/fast-syntax-highlighting

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

# Fix git reset HEAD^: zsh: no matches found: HEAD^
setopt NO_NOMATCH
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

# --------> Load bins of terminal-setup ------------------------------------------------------------
addToPATH "$TERMINAL_SETUP_LOCAL_BIN_DIR"

# --------> Basic Binary ---------------------------------------------------------------------------
addToPATH "$HOME/bin"
addToPATH "$HOME/.local/bin"
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
    alias ls='ls -hF --color=always'
    alias ll='ls -l --time-style=long-iso --group-directories-first'
    alias rm='rm -iv'
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

odg() {
    local TEMP_FILE=$(mktemp)
    select_menu --prompt="Which project would you like to go?" --options="IXT Core,IXT Launchpad,IXT Ecosystem,IXT FE Tools,Quit" --tmp-file=$TEMP_FILE --no-output
    local SELECTED_PROJ=$(cat "$TEMP_FILE")
    rm -f "$tmp_file"

    case $SELECTED_PROJ in
    "IXT Launchpad")
        cd "$PROJS_BASE/work/ixt-launchpad-web" || return
        echo "\nOK, you are ready to work on IXT Launchpad :)"
        ;;
    "IXT Ecosystem")
        cd "$PROJS_BASE/work/ixt-ecosystem-web" || return
        echo "\nOK, you are ready to work on IXT Ecosystem :)"
        ;;
    "IXT Core")
        cd "$PROJS_BASE/work/ixt-web" || return
        echo "\nOK, you are ready to work on IXT Core :)"
        ;;
    "IXT FE Tools")
        cd "$PROJS_BASE/work/ixt-frontend-tools" || return
        echo "\nOK, you are ready to work on IXT Frontend Tools :)"
        ;;
    "Quit")
        return
        ;;
    *)
        echo "Invalid option: $SELECTED_PROJ"
        ;;
    esac
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

# ===> Python (Optional) ===========================================================================
alias python='python3'
# for Python 3.11 workaround
# export PATH="$(brew --prefix)/opt/python@3.11/libexec/bin:$PATH"
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

# ===> Automatically use the correct node version if exists, with legacy .nvmrc support =============
# ===> Installs the node version if not already installed ==========================================
autoload -U add-zsh-hook
load-node-version() {
    local asdf_node_version="$(asdf current nodejs 2>/dev/null | awk '{print $2}')"
    local directory_node_version=""
    local legacy_nvmrc_node_version=""

    if [ -f ".tool-versions" ]; then
        directory_node_version="$(cat .tool-versions | grep nodejs | awk '{print $2}')"
    elif [ -f ".nvmrc" ]; then
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
# ==================================================================================================

typeset -U path                       # remove duplicates in $PATH
if [ "$0" = "$ZSH_SHELL_NAME" ]; then # don't run when source .zshrc

    # update & upgrade packages once shell launched
    # { [ $DISTRO_NAME = $UBUNTU ] || [ $OS_NAME = $MACOS ]; } && unu

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
