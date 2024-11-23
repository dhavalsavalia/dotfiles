#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

setup_aerospace() {
  local aerospace_config_dir="$XDG_CONFIG_HOME/aerospace"

  # Check if Aerospace CLI is installed
  if ! command_exists "aerospace"; then
    error "Aerospace CLI is not installed. Please install Aerospace CLI first using brew."
    exit 1
  fi

  # if aerospace cli is present and aerospace config directory is present with a config file
  if [ -d "$aerospace_config_dir" ] && [ -f "$aerospace_config_dir/aerospace.toml" ]; then
    log "Aerospace is already installed and configured"
    log "Attempting to open Aerospace..."
    open -a "AeroSpace"
    return 0
  fi

  error "Aerospace is not configured. Please configure Aerospace first using stow."
  exit 1
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if [[ "$1" == "-y" ]]; then
    setup_aerospace
  else
    read -p "This script will setup aerospace. Do you want to continue? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      setup_aerospace
    fi
  fi
fi
