#!/bin/bash

set -e

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

install_lunarvim() {

    if ! command_exists "nvim"; then
        error "Neovim is not installed. Please install Neovim first using brew."
        exit 1
    fi

    if command_exists "lvim"; then
        log "LunarVim is already installed"
        return 0
    fi

    # Install LunarVim Nightly
    log "Installing LunarVim..."
    execute 'yes | bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)'

    # Source shell environment to make lvim available
    execute 'source $HOME/.zprofile'
    execute 'source $HOME/.zshenv'

    # Verify installation
    if command_exists "lvim"; then
        log "LunarVim installed successfully!"
    else
        error "LunarVim installation failed"
        exit 1
    fi
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ "$1" == "-y" ]]; then
        install_lunarvim
    else
        read -p "This script will install LunarVim. Do you want to continue? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_lunarvim
        fi
    fi
fi
