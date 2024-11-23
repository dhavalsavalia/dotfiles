#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES_DIR

setup_stow() {
    log "Setting up stow symlinks..."

    # Ensure stow is installed
    if ! command_exists "stow"; then
        error "stow is not installed. Please install stow first using brew."
        exit 1
    fi

    # Stow everything from the dotfiles directory
    # NOTE: Need to use --adopt to avoid conflicts with .zprofile since brew.sh also must have
    #       created a .zprofile file. Using stow for uniformity.
    execute "cd $DOTFILES_DIR && stow -v --target=$HOME --adopt ."

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
    setup_stow
fi
