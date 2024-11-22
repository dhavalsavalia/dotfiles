#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

setup_aerospace() {
  local aerospace_config_dir="$XDG_CONFIG_HOME/aerospace"

  # if aerospace cli is present and aerospace config directory is present with a config file
  if command -v aerospace &>/dev/null && [ -d "$aerospace_config_dir" ] && [ -f "$aerospace_config_dir/aerospace.toml" ]; then
    log "Aerospace is already installed and configured"
    info "Attempting to open Aerospace..."
    open -a "AeroSpace"
    return 0
  fi
}

setup_aerospace
