#!/usr/bin/env bash

# VSCode configuration and extension management script

# Source utilities
DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
source "${DOTFILES_DIR}/scripts/utils.sh"

# Configuration
VSCODE_CONFIG_DIR="${HOME}/Library/Application Support/Code/User"
DOTFILES_VSCODE_DIR="${DOTFILES_DIR}/vscode/.config/vscode"
PROFILE_FILE="${HOME}/.config/.brewprofile"

# Parse arguments
DRY_RUN="${DRY_RUN:-false}"
PROFILE=""

while getopts "p:d" opt; do
  case $opt in
    p) PROFILE="$OPTARG" ;;
    d) DRY_RUN=true ;;
    *) echo "Usage: $0 [-p profile] [-d]" >&2; exit 1 ;;
  esac
done

# Determine profile
if [ -z "$PROFILE" ] && [ -f "$PROFILE_FILE" ]; then
  PROFILE=$(cat "$PROFILE_FILE")
fi

PROFILE="${PROFILE:-minimal}"

log "Configuring VSCode for profile: $PROFILE"

# Check if VSCode is installed
if ! command_exists code; then
  warn "VSCode not found. Skipping configuration."
  exit 0
fi

# Ensure VSCode config directory exists
if [ ! -d "$VSCODE_CONFIG_DIR" ]; then
  execute "mkdir -p '$VSCODE_CONFIG_DIR'" "Creating VSCode config directory"
fi

# Merge settings: base + profile-specific
merge_settings() {
  local base_settings="${DOTFILES_VSCODE_DIR}/settings.base.json"
  local profile_settings="${DOTFILES_VSCODE_DIR}/settings.${PROFILE}.json"
  local output_settings="${VSCODE_CONFIG_DIR}/settings.json"

  if [ ! -f "$base_settings" ]; then
    error "Base settings not found: $base_settings"
    return 1
  fi

  log "Merging settings: base + ${PROFILE}"

  # If profile settings exist, merge them; otherwise use base only
  if [ -f "$profile_settings" ]; then
    if command_exists jq; then
      if [ "$DRY_RUN" = "true" ]; then
        echo "WOULD EXECUTE: jq -s '.[0] * .[1]' base + profile > settings.json"
      else
        jq -s '.[0] * .[1]' "$base_settings" "$profile_settings" > "$output_settings"
      fi
    else
      warn "jq not found. Copying base settings only."
      if [ "$DRY_RUN" = "true" ]; then
        echo "WOULD EXECUTE: cp $base_settings $output_settings"
      else
        cp "$base_settings" "$output_settings"
      fi
    fi
  else
    if [ "$DRY_RUN" = "true" ]; then
      echo "WOULD EXECUTE: cp $base_settings $output_settings"
    else
      cp "$base_settings" "$output_settings"
    fi
  fi
}

# Copy keybindings (shared across profiles)
copy_keybindings() {
  local source_keybindings="${DOTFILES_VSCODE_DIR}/keybindings.json"
  local target_keybindings="${VSCODE_CONFIG_DIR}/keybindings.json"

  if [ -f "$source_keybindings" ]; then
    log "Copying keybindings"
    if [ "$DRY_RUN" = "true" ]; then
      echo "WOULD EXECUTE: cp keybindings.json to VSCode"
    else
      cp "$source_keybindings" "$target_keybindings"
    fi
  else
    warn "Keybindings file not found: $source_keybindings"
  fi
}

# Install extensions from extension lists
install_extensions() {
  local base_extensions="${DOTFILES_VSCODE_DIR}/extensions.base.txt"
  local profile_extensions="${DOTFILES_VSCODE_DIR}/extensions.${PROFILE}.txt"

  log "Managing VSCode extensions for profile: $PROFILE"

  # Get currently installed extensions
  local installed_extensions
  local expected_extensions=()
  local to_install=()
  local to_uninstall=()

  if [ "$DRY_RUN" != "true" ]; then
    installed_extensions=$(code --list-extensions 2>/dev/null)
  fi

  # Build list of expected extensions from base + profile
  if [ -f "$base_extensions" ]; then
    while IFS= read -r ext || [ -n "$ext" ]; do
      [[ "$ext" =~ ^#.*$ ]] && continue
      [[ -z "$ext" ]] && continue
      expected_extensions+=("$ext")
    done < "$base_extensions"
  fi

  if [ -f "$profile_extensions" ]; then
    while IFS= read -r ext || [ -n "$ext" ]; do
      [[ "$ext" =~ ^#.*$ ]] && continue
      [[ -z "$ext" ]] && continue
      expected_extensions+=("$ext")
    done < "$profile_extensions"
  fi

  # Determine what needs to be installed
  for ext in "${expected_extensions[@]}"; do
    if [ "$DRY_RUN" = "true" ]; then
      to_install+=("$ext")
    else
      if ! echo "$installed_extensions" | grep -q "^${ext}$"; then
        to_install+=("$ext")
      fi
    fi
  done

  # Determine what needs to be uninstalled (installed but not in expected list)
  if [ "$DRY_RUN" != "true" ] && [ -n "$installed_extensions" ]; then
    while IFS= read -r ext; do
      [[ -z "$ext" ]] && continue
      local found=false
      for expected in "${expected_extensions[@]}"; do
        if [ "$ext" = "$expected" ]; then
          found=true
          break
        fi
      done
      if [ "$found" = false ]; then
        to_uninstall+=("$ext")
      fi
    done <<< "$installed_extensions"
  fi

  # Report what will happen
  local total_expected=${#expected_extensions[@]}
  local total_install=${#to_install[@]}
  local total_uninstall=${#to_uninstall[@]}
  local total_unchanged=$((total_expected - total_install))

  if [ "$DRY_RUN" = "true" ]; then
    log "Would install ${total_install} extensions"
  else
    if [ $total_install -eq 0 ] && [ $total_uninstall -eq 0 ]; then
      log "All extensions up to date (${total_expected} installed)"
    else
      log "Installing ${total_install}, keeping ${total_unchanged}, removing ${total_uninstall}"
    fi
  fi

  # Install missing extensions
  if [ ${#to_install[@]} -gt 0 ]; then
    for ext in "${to_install[@]}"; do
      if [ "$DRY_RUN" = "true" ]; then
        echo "  Would install: $ext"
      else
        echo "Installing $ext..."
        code --install-extension "$ext" --force >/dev/null 2>&1
        if [ $? -eq 0 ]; then
          echo "✓ Installed $ext"
        else
          warn "✗ Failed to install $ext"
        fi
      fi
    done
  fi

  # Uninstall extensions not in the list
  if [ ${#to_uninstall[@]} -gt 0 ]; then
    warn "The following extensions are not in your configuration and will be removed:"
    for ext in "${to_uninstall[@]}"; do
      echo "  - $ext"
    done

    if [ "$DRY_RUN" != "true" ]; then
      echo ""
      read -p "Remove these extensions? (y/N) " confirm
      if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        for ext in "${to_uninstall[@]}"; do
          echo "Uninstalling $ext..."
          code --uninstall-extension "$ext" >/dev/null 2>&1
          if [ $? -eq 0 ]; then
            echo "✓ Uninstalled $ext"
          else
            warn "✗ Failed to uninstall $ext"
          fi
        done
      else
        log "Skipped uninstalling extensions"
      fi
    fi
  fi
}

# Main execution
main() {
  merge_settings
  copy_keybindings
  install_extensions

  log "✓ VSCode configuration complete for profile: $PROFILE"
}

main
