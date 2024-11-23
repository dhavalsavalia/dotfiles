#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

setup_sketchybar() {
  local sketchybar_dir="$XDG_CONFIG_HOME/sketchybar"
  local sketchybar_script="$sketchybar_dir/sketchybarrc"
  local plugin_dir="$sketchybar_dir/plugins"
  local items_dir="$sketchybar_dir/items"
  local colors_file="$sketchybar_dir/colors.sh"
  local temp_file
  local LATEST_APP_FONT_VERSION="2.0.28"

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
    error "sketchybar is not installed. Please install sketchybar first using brew."
    exit 1
  fi

  # Install sketchybar app fonts
  # Not checking if the font is already installed since it's a small file and won't hurt to download again
  # FWIW, this will keep the font up-to-date without too much overhead
  log "Installing sketchybar app fonts..."
  local font_url="https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v$LATEST_APP_FONT_VERSION/sketchybar-app-font.ttf"
  local font_dest="$HOME/Library/Fonts/sketchybar-app-font.ttf"

  if curl -L "$font_url" -o "$font_dest"; then
    log "sketchybar app font installed successfully"
  else
    error "Failed to download sketchybar app font from $font_url"
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

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ "$1" == "-y" ]]; then
        setup_sketchybar
    else
        read -p "This script will setup sketchybar. Do you want to continue? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            setup_sketchybar
        fi
    fi
fi
