#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES_DIR

# Define the default packages variable
DEFAULT_PACKAGES="aerospace alacritty fzf-git.sh git lazygit linearmouse local_scripts lvim nvim ripgrep starship tmux zellij zsh"

setup_stow() {
    local packages=("$@")
    log "Setting up stow symlinks..."

    # Ensure stow is installed
    if ! command_exists "stow"; then
        error "stow is not installed. Please install stow first using brew."
        exit 1
    fi

    # Use default packages if no arguments are provided
    if [ ${#packages[@]} -eq 0 ]; then
        packages=($DEFAULT_PACKAGES)
    fi

    # Stow the specified packages
    for package in "${packages[@]}"; do
        if [ -d "$DOTFILES_DIR/$package" ]; then
            execute "cd $DOTFILES_DIR && stow -D $package" # Unstow first to ensure idempotency
            execute "cd $DOTFILES_DIR && stow -t $HOME --adopt $package"
        else
            warning "$package directory does not exist in $DOTFILES_DIR"
        fi
    done

    execute 'source $HOME/.zprofile'
    execute 'source $HOME/.zshenv'

    # Test if symlinks are correctly setup (test if .zshenv is a symlink)
    if [ -L "$HOME/.zshenv" ]; then
        log "Stow setup successful"
    else
        error "Stow setup failed"
        exit 1
    fi
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_stow "$@"
fi
