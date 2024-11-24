#!/bin/bash

set -e

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

setup_local_scripts() {
    log "Setting up local scripts..."

    execute 'source $HOME/.zprofile'
    execute 'source $HOME/.zshenv'

    # Give execute permission to all files in local_scripts directory recursively
    execute 'cd $XDG_CONFIG_HOME/local_scripts && chmod -R +x .'
}

# Main Execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_local_scripts
fi
