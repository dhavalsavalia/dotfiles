#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

setup_stow() {
    local profile="$1"

    log "Setting up stow symlinks..."

    # Stow everything from the dotfiles directory
    execute "cd $DOTFILES_DIR && stow -v --target=$HOME ."

    log "Stow setup complete"
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_stow "$1"
fi
