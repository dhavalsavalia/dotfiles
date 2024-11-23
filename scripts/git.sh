#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES_DIR

setup_git_author() {
  local name="$1"
  local email="$2"

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

  # Check if $DOTFILES_DIR/.config/git/gitconfig.d/user.conf exists
  if [ ! -f "$DOTFILES_DIR/.config/git/gitconfig.d/user.conf" ]; then
    error "Git configuration file not found. Please check if the file exists."
    exit 1
  fi

  # use sed to replace GITAUTHORNAME and GITAUTHOREMAIL in $DOTFILES_DIR/.config/git/gitconfig.d/user.conf
  sed -i '' "s/GITAUTHORNAME/$name/g" "$DOTFILES_DIR/.config/git/gitconfig.d/user.conf"
  sed -i '' "s/GITAUTHOREMAIL/$email/g" "$DOTFILES_DIR/.config/git/gitconfig.d/user.conf"

  # Check if this worked
  if ! grep -q "$name" "$DOTFILES_DIR/.config/git/gitconfig.d/user.conf"; then
    error "Failed to set git author name"
    exit 1
  fi
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  # check if -n [name] and -e [email] are passed as arguments
  # if yes, set as variables
  while getopts "n:e:" opt; do
    case $opt in
      n) NAME="$OPTARG";;
      e) EMAIL="$OPTARG";;
      *) echo "Usage: $0 -n [name] -e [email]" >&2; exit 1;;
    esac
  done

  setup_git_author "$NAME" "$EMAIL"
fi