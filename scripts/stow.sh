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
    # TODO: Make this take args for packages to stow
    for package in aerospace alacritty fzf-git.sh git kitty lazygit linearmouse lvim sketchybar starship tmux zsh; do
        if [ -d "$DOTFILES_DIR/$package" ]; then
            execute "cd $DOTFILES_DIR && stow -D $package" # Unstow first to ensure idempotency
            execute "cd $DOTFILES_DIR && stow -t $HOME $package"
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
    setup_stow
fi
