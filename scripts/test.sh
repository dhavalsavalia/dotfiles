#!/bin/bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

check_command() {
    if ! command_exists "$1"; then
        error "$1 is not installed"
        exit 1
    else
        log "$1 is installed"
    fi
}

check_file() {
    if [ ! -f "$1" ]; then
        error "File $1 does not exist"
        exit 1
    else
        log "File $1 exists"
    fi
}

check_directory() {
    if [ ! -d "$1" ]; then
        error "Directory $1 does not exist"
        exit 1
    else
        log "Directory $1 exists"
    fi
}

check_brew_packages() {
    local profile="$1"
    local brew_dir="$DOTFILES_DIR/.data/homebrew"
    local combined_file="$brew_dir/Brewfile.combined"

    if [ ! -f "$combined_file" ]; then
        error "Combined Brewfile does not exist"
        exit 1
    fi

    log "Checking Homebrew packages for profile: $profile"
    while IFS= read -r line; do
        if [[ "$line" =~ ^brew\ \"([^\"]+)\" ]]; then
            package="${BASH_REMATCH[1]}"
            if ! brew list --formula | grep -q "^$package\$"; then
                error "Homebrew package $package is not installed"
                exit 1
            else
                log "Homebrew package $package is installed"
            fi
        elif [[ "$line" =~ ^cask\ \"([^\"]+)\" ]]; then
            package="${BASH_REMATCH[1]}"
            if ! brew list --cask | grep -q "^$package\$"; then
                error "Homebrew cask $package is not installed"
                exit 1
            else
                log "Homebrew cask $package is installed"
            fi
        fi
    done < "$combined_file"
}

test_dotfiles_setup() {
    local profile="$1"
    log "Testing dotfiles setup for profile: $profile..."

    # Check stow
    check_command "stow"
    check_directory "$HOME/.config"
    check_file "$HOME/.zshenv"
    check_file "$HOME/.zshrc"

    # Check Homebrew and packages
    check_command "brew"
    check_brew_packages "$profile"

    # Check LunarVim
    check_command "lvim"

    # Check tmux and tmuxifier
    check_command "tmux"
    check_directory "$XDG_CONFIG_HOME/tmux/plugins/tpm"
    check_directory "$XDG_CONFIG_HOME/tmuxifier"

    log "Dotfiles setup test completed successfully!"
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [ -z "$1" ]; then
        error "Profile must be specified as the first argument"
        exit 1
    fi
    test_dotfiles_setup "$1"
fi
