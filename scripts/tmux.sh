#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

setup_tmux() {

    # Install TPM (Tmux Plugin Manager) in $XDG_CONFIG_HOME/tmux/plugins/tpm
    local tpm_dir="$XDG_CONFIG_HOME/tmux/plugins/tpm"

    if [ -d "$tpm_dir" ]; then
        log "TPM is already installed"
        return 0
    fi

    log "Installing TPM..."
    execute "git clone https://github.com/tmux-plugins/tpm $tpm_dir"

    if [ -d "$tpm_dir" ]; then
        log "TPM installed successfully!"
    else
        error "TPM installation failed"
        exit 1
    fi
}

# Main execution
setup_tmux