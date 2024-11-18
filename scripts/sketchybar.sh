#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

setup_sketchybar() {
  local sketchybar_dir="$XDG_CONFIG_HOME/sketchybar"
  local sketchybar_script="$sketchybar_dir/sketchybarrc"
  local plugin_dir="$sketchybar_dir/plugins"
  local items_dir="$sketchybar_dir/items"
  local colors_file="$sketchybar_dir/colors.sh"
  local temp_file

  log "Setting up sketchybar..."

  # Ensure the sketchybar script and dir exists, exit if it doesn't since stow should have created it
  if [ ! -f "$sketchybar_script" ]; then
    error "sketchybar script not found: $sketchybar_script"
    exit 1
  fi

  # Ensure all scripts are executable
  chmod +x "$sketchybar_script" || { error "Failed to make $sketchybar_script executable"; exit 1; }
  chmod +x "$plugin_dir"/*.sh || { error "Failed to make scripts in $plugin_dir executable"; exit 1; }
  chmod +x "$items_dir"/*.sh || { error "Failed to make scripts in $items_dir executable"; exit 1; }
  chmod +x "$colors_file" || { error "Failed to make $colors_file executable"; exit 1; }

  # Ensure sketchybar is installed
  if ! command -v sketchybar &> /dev/null; then
    error "sketchybar is not installed"
    exit 1
  fi

  # Start sketchybar service
  if brew services list | grep -q "^sketchybar.*started"; then
    log "sketchybar service is already running"
  else
    log "Starting sketchybar service..."
    temp_file=$(mktemp)
    brew services start sketchybar &> "$temp_file"
    if [ $? -eq 0 ]; then
      log "sketchybar service started successfully"
    else
      error "Failed to start sketchybar service"
      cat "$temp_file"
      rm -f "$temp_file"
      exit 1
    fi
    rm -f "$temp_file"
  fi
}

setup_sketchybar
