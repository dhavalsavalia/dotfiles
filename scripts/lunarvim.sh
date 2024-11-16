#!/bin/bash

set -e

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

install_lunarvim() {

    if command_exists "lvim"; then
        log "LunarVim is already installed"
        return 0
    fi

    # Install LunarVim Nightly
    log "Installing LunarVim..."
    execute 'bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)'

    # Verify installation
    if command_exists "lvim"; then
        log "LunarVim installed successfully!"
    else
        error "LunarVim installation failed"
        exit 1
    fi
}

# Main execution
install_lunarvim
