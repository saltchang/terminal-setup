# Zsh configure
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir newline vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time os_icon)

POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="\u2570\u2500\u27A4 "

plugins=(git)

# export
export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export GOPATH=$HOME/saltCode/go

# Alias
alias ll='ls -hlF'
alias la='ls -ahlF'
alias cp='cp -iv'
alias mv='mv -iv'
alias python='python3'
alias home='cl ~ && echo "\nYou are home."'
alias gogo='cl $GOPATH && echo "\nOK, ready to Go."'
alias goco='cl ~/saltCode && echo "\nOK, ready to code."'
alias codego='cl $GOPATH/src/github.com/saltchang && code .'

# For Linux(Gnome)
alias n='nautilus'

# Shortcut command
alias c='clear'

junk() {
    mv "$1" ~/.Trash/
}

cl() {
    cd "$1" && ll
}

clearTrash() {
    \rm -rf ~/.Trash/*
}


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/salt/.sdkman"
[[ -s "/home/salt/.sdkman/bin/sdkman-init.sh" ]] && source "/home/salt/.sdkman/bin/sdkman-init.sh"

source $ZSH/oh-my-zsh.sh
