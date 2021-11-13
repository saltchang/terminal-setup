#! /bin/bash

# --------> Quickly update Git (for Ubuntu) ------------------------------------
update_git() {
    printf "\nCurrent %s\n\n" "$(git --version)"

    printf "Start to update Git...\n\n"

    sudo add-apt-repository ppa:git-core/ppa -y &&
        sudo apt-get update &&
        sudo apt-get install git -y

    printf "\nCurrent %s\n\n" "$(git --version)"
    printf "Git updated successfully.\n"
}

# --------> Quickly update Git (for macOS) ------------------------------------
update_git() {
    printf "\nCurrent %s\n\n" "$(git --version)"

    printf "Start to update Git...\n\n"

    brew update && brew upgrade git

    printf "\nCurrent %s\n\n" "$(git --version)"
    printf "Git updated successfully.\n"
}
