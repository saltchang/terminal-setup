# .bash_profile
# By Salt Chang

# enables color in the terminal bash shell
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
# enables color for iTerm
export TERM=xterm-color
export TERM="xterm-color"
export PS1="\[\e[1;31m\]\u: \W \[\e[1;31m\]\$ \[\e[m\]"

# Alias

alias ll='ls -hlF'
alias la='ls -ahlF'
alias cp='cp -iv'
alias mv='mv -iv'
alias python='python3'
alias gogo='cl $GOPATH'
alias goco='cl ~/saltCode'
alias codego='cl $GOPATH/src/github.com/saltchang && code .'


# Shortcut command
alias f='open -a Finder ./'
alias c='clear'

# Replace "rm" command to trash for safety
alias rm='echo "Please use the command: \"junk\" for safety."'
junk() {
    mv "$1" ~/.Trash/
}

cl() {
    cd "$1" && la
}

clearTrash() {
    \rm -rf ~/.Trash/*
}
