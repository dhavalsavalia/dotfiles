#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

# Get git author info from existing config or prompts
get_git_author() {
  local provided_name="$1"
  local provided_email="$2"
  local user_conf="$DOTFILES_DIR/git/.config/git/gitconfig.d/user.conf"
  local default_name="Dhaval Savalia"
  local default_email="hello@dhavalsavalia.com"
  local git_name git_email

  # Check if user.conf already exists
  if [ -f "$user_conf" ]; then
    local existing_name=$(grep "name = " "$user_conf" 2>/dev/null | sed 's/.*name = //')
    local existing_email=$(grep "email = " "$user_conf" 2>/dev/null | sed 's/.*email = //')

    if [ -n "$existing_name" ] && [ -n "$existing_email" ]; then
      echo "$existing_name|$existing_email"
      return 0
    fi
  fi

  # Determine name: provided > existing > prompt > default
  if [ -n "$provided_name" ]; then
    git_name="$provided_name"
  else
    read -p "Enter your Git author name [${default_name}]: " input_name
    git_name=${input_name:-$default_name}
  fi

  # Determine email: provided > existing > prompt > default
  if [ -n "$provided_email" ]; then
    git_email="$provided_email"
  else
    read -p "Enter your Git author email [${default_email}]: " input_email
    git_email=${input_email:-$default_email}
  fi

  echo "$git_name|$git_email"
}

setup_git_author() {
  local name="$1"
  local email="$2"
  local user_conf="$DOTFILES_DIR/git/.config/git/gitconfig.d/user.conf"
  local git_config="$DOTFILES_DIR/git/.config/git/.gitconfig"

  # Check if git is installed
  if ! command_exists "git"; then
    error "Git is not installed. Please install Git first using brew."
    exit 1
  fi

  # Check stow is installed and symlinked
  if ! test_stow; then
    error "Stow is not installed or symlinked. Please install Stow first using brew."
    exit 1
  fi

  # Check if $DOTFILES_DIR/git/.config/git/gitconfig.d/ exists
  if [ ! -d "$DOTFILES_DIR/git/.config/git/gitconfig.d" ]; then
    error "Git config directory does not exist. Please check your dotfiles setup."
    exit 1
  fi

  # Update git remote URL to SSH
  current_url="$(git -C "$DOTFILES_DIR" remote get-url origin 2>/dev/null || echo "")"
  if [ "$current_url" != "git@github.com:dhavalsavalia/dotfiles.git" ]; then
    execute "git -C \"$DOTFILES_DIR\" remote set-url origin git@github.com:dhavalsavalia/dotfiles.git"
  fi

  # Check if user.conf already exists
  if [ -f "$user_conf" ]; then
    warn "Existing user.conf found, skipping git user configuration..."
    local current_name=$(git config --global user.name || echo "")
    local current_email=$(git config --global user.email || echo "")
    log "Current git configuration:"
    log "  Name: $current_name"
    log "  Email: $current_email"
    return 0
  fi

  # Write to user.conf only if it doesn't exist
  echo "[user]" > "$user_conf"
  echo "  name = $name" >> "$user_conf"
  echo "  email = $email" >> "$user_conf"

  # Ensure include path is set in .gitconfig
  if ! grep -q "path = gitconfig.d/user.conf" "$git_config" 2>/dev/null; then
    echo "  path = gitconfig.d/user.conf" >> "$git_config"
  fi

  # Verify the configuration
  if ! grep -q "name = $name" "$user_conf" 2>/dev/null; then
    error "Failed to set git author name"
    exit 1
  fi

  log "Git configuration updated successfully:"
  log "  Name: $name"
  log "  Email: $email"
  warn "Please setup your signing key in gitconfig.d/user.conf"
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  # check if -n [name] and -e [email] are passed as arguments
  while getopts "n:e:" opt; do
    case $opt in
    n) NAME="$OPTARG" ;;
    e) EMAIL="$OPTARG" ;;
    *)
      echo "Usage: $0 -n [name] -e [email]" >&2
      exit 1
      ;;
    esac
  done

  setup_git_author "$NAME" "$EMAIL"
fi
