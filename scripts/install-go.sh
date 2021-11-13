#!/bin/bash

# ==============================================================================

# File Name: install-go.sh

# ------------------------------------------------------------------------------

# Description: A simple Go Language installer

# ------------------------------------------------------------------------------

# Author: Salt Chang

# ------------------------------------------------------------------------------

# Author Email: me@saltchang.com

# ==============================================================================

# Text colors
GREEN='\033[0;32m'
LIGHT_BLUE='\033[1;34m'
DARK_GRAY='\033[1;30m'
ORANGE='\033[0;33m'
NORMAL='\033[0m'

go_select_from_versions() {

    cursor_on() {
        printf "\033[?25h"
    }

    cursor_off() {
        printf "\033[?25l"
    }

    trap "cursor_on; stty echo; printf '\n'; exit" 2 # Waiting for Ctrl+C signal to exit the function
    cursor_off

    clear # Clear terminal, ready to print options

    local options_count=$#

    local max_row
    max_row=$(tput lines) # Get max rows of terminal
    local init_id=0       # First index to select
    local shift_row=0     # Printed row to shift
    local init_row=1      # Position of irst row in terminal

    local top_padding_rows=1
    local bottom_padding_rows=1
    local total_padding_rows=$((top_padding_rows + bottom_padding_rows))

    local first_option_row=$((init_row + top_padding_rows))             # First row to print option
    local last_option_row=$((max_row - bottom_padding_rows - init_row)) # Last row to print option

    local middle_row=$((last_option_row / 2))

    local odd_fixed

    if [ $((last_option_row % 2)) -eq 0 ]; then
        odd_fixed=0
    else
        odd_fixed=1
    fi

    local selected_id=$((init_id))

    local limited_options

    [ $options_count -gt "$last_option_row" ] && limited_options=true

    update_displayed_options() {
        if [ $limited_options = true ]; then
            if [ $selected_id -gt "$middle_row" ]; then
                if [ $selected_id -ge $((options_count - middle_row)) ]; then
                    shift_row=$((options_count - middle_row - middle_row - odd_fixed))
                else
                    shift_row=$((selected_id - middle_row + total_padding_rows - first_option_row))
                fi
            else
                shift_row=0
            fi
        fi
    }

    while true; do
        clear
        local i=0

        command printf "${GREEN}? ${NORMAL}Please choose a ${LIGHT_BLUE}Go Version${NORMAL} from this list: ${DARK_GRAY}(Use up/down arrow key)${NORMAL}\n"

        for option; do
            if [ $i -gt $((shift_row - 1)) ] && [ $i -lt $((shift_row + last_option_row)) ]; then
                if [ $i -eq $selected_id ]; then
                    # Selected option
                    printf "${LIGHT_BLUE}\u276f %s${NORMAL}\n" "$option"
                else
                    printf "  %s\n" "$option"
                fi
            fi
            ((i++))
        done

        command printf " ${DARK_GRAY}(Move up and down to reveal more choices)${NORMAL}"

        on_click() {
            up=$(printf "\033[A")
            down=$(printf "\033[B")
            enter=$(printf "")

            read -r -s -n3 key 2>/dev/null >&2

            [ "$key" = "${up}" ] && echo up
            [ "$key" = "${down}" ] && echo down
            [ "$key" = "${enter}" ] && echo enter
        }

        case $(on_click) in
        up)
            ((selected_id--))
            [ $selected_id -lt $init_id ] && selected_id=$((options_count - 1))
            update_displayed_options
            ;;

        down)
            ((selected_id++))
            [ "$selected_id" -ge $options_count ] && selected_id=$init_id
            update_displayed_options
            ;;

        enter)
            break
            ;;

        esac
    done

    # Reset cursor
    cursor_on
    clear

    return $selected_id
}

go_try_user_profile() {
    if [ -z "${1-}" ] || [ ! -f "${1}" ]; then
        return 1
    fi
    echo "${1}"
}

go_detect_user_profile() {
    if [ -n "${PROFILE}" ] && [ -f "${PROFILE}" ]; then
        echo "${PROFILE}"
        return
    fi

    local DETECTED
    DETECTED=''

    if [ "${SHELL#*bash}" != "$SHELL" ]; then
        if [ -f "$HOME/.bash_profile" ]; then
            DETECTED="$HOME/.bash_profile"
        elif [ -f "$HOME/.bashrc" ]; then
            DETECTED="$HOME/.bashrc"
        fi
    elif [ "${SHELL#*zsh}" != "$SHELL" ]; then
        if [ -f "$HOME/.zshrc" ]; then
            DETECTED="$HOME/.zshrc"
        fi
    fi

    if [ -z "$DETECTED" ]; then
        for EACH_PROFILE in ".profile" ".bashrc" ".bash_profile" ".zshrc"; do
            if DETECTED="$(go_try_user_profile "${HOME}/${EACH_PROFILE}")"; then
                break
            fi
        done
    fi

    if [ -n "$DETECTED" ]; then
        echo "$DETECTED"
    fi
}

go_install_package() {
    local GO_USER_PROFILE
    GO_USER_PROFILE="$(go_detect_user_profile)"

    local TEMP_VERSIONS
    TEMP_VERSIONS=$(mktemp)

    echo
    echo "Fetch available versions fo Go..."
    echo

    curl -sL "https://golang.org/dl/#stable" | grep -P -o "(?<=go)\d+\.\d+(rc|beta)?\d?\.?(rc|beta)?\d+?(?=.linux-amd64.tar.gz)" | sort -u -t. -k 1,1nr -k 2,2nr -k 3,3nr | uniq >"$TEMP_VERSIONS"

    mapfile -t GO_VERSIONS_ARRAY <"$TEMP_VERSIONS"

    go_select_from_versions "${GO_VERSIONS_ARRAY[@]}"
    selected_index=$?
    selected_version=${GO_VERSIONS_ARRAY[$selected_index]}

    echo "You selected the Go version: $selected_version"
    echo
    echo "Start downloading the package..."
    echo

    TEMP_ARCHIVE=$(mktemp "/tmp/go${selected_version}.linux-amd64.tar.gz.XXXXXX") || exit 1

    curl -L "https://golang.org/dl/go${selected_version}.linux-amd64.tar.gz" -o "$TEMP_ARCHIVE"

    echo
    echo "Start removing old version of Go..."
    echo

    sudo rm -rfv /usr/local/go

    RC=$?
    if [ $RC -ne 0 ]; then
        echo
        echo "Failed to remove old version..."
        echo "Install Go Language failed!"
        echo
        echo "exit $RC"
        exit $RC
    fi

    echo
    echo "Start installing the package..."

    sudo tar -C /usr/local -xzvf "$TEMP_ARCHIVE"

    RC=$?
    if [ $RC -ne 0 ]; then
        echo
        echo "Failed to install the package..."
        echo "Install Go Language failed!"
        echo
        echo "exit $RC"
        exit $RC
    fi

    echo

    # Add Go into PATH
    local GO_SOURCE_PATH
    # shellcheck disable=SC2016
    GO_SOURCE_PATH='export PATH=$PATH:/usr/local/go/bin'

    if [ -z "${GO_USER_PROFILE-}" ]; then
        command printf "${ORANGE}User profile not found.${NORMAL}\n"
        command printf "${ORANGE}Please add the following lines to your profile manually:${NORMAL}\n"
        command printf "\n${ORANGE}${GO_SOURCE_PATH}${NORMAL}\n"
        echo
    else
        if ! command grep -qc '/usr/local/go/bin' "$GO_USER_PROFILE"; then
            command printf "${GREEN}Adding Go to your PATH...${NORMAL}"
            command printf "\n${GO_SOURCE_PATH}\n" >>"$GO_USER_PROFILE"
        else
            command printf "${GREEN}Go has already added in your PATH.${NORMAL}\n"
        fi
    fi

    echo

    command printf "If the ${LIGHT_BLUE}\`go\`${NORMAL} command is not found, please try adding the following line to your shell profile:\n"
    command printf "\n${ORANGE}${GO_SOURCE_PATH}${NORMAL}\n\n"

    echo "┌──────────────────────────────────────────────────────────────────────────────┐"
    echo "│                                                                              │"
    command printf "│                     ${LIGHT_BLUE}Go Language ${GREEN}installed sucessfully!${NORMAL}                       │\n"
    echo "│                                                                              │"
    command printf "│           Please run ${LIGHT_BLUE}\`go version\`${NORMAL} to see the current version of Go.          │\n"
    echo "│                                                                              │"
    echo "└──────────────────────────────────────────────────────────────────────────────┘"
    echo
}

go_install_package
