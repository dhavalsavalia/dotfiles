#!/bin/bash

set -e

REPO_URL="https://github.com/dhavalsavalia/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# Default values
PROFILE="${DOTFILES_PROFILE:-minimal}"
BRANCH="${DOTFILES_BRANCH:-main}"

DEFAULT_GITAUTHORNAME="Dhaval Savalia"
DEFAULT_GITAUTHOREMAIL="hello@dhavalsavalia.com"

# Prompt for GITAUTHORNAME if not set
if [ -z "$GITAUTHORNAME" ]; then
    read -p "Enter your Git author name [${DEFAULT_GITAUTHORNAME}]: " input_name
    GITAUTHORNAME=${input_name:-$DEFAULT_GITAUTHORNAME}
fi

# Prompt for GITAUTHOREMAIL if not set
if [ -z "$GITAUTHOREMAIL" ]; then
    read -p "Enter your Git author email [${DEFAULT_GITAUTHOREMAIL}]: " input_email
    GITAUTHOREMAIL=${input_email:-$DEFAULT_GITAUTHOREMAIL}
fi

# Clone the repository if it doesn't exist
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles repository..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    # Check if repository has right remote URL
    if [ "$(git -C "$DOTFILES_DIR" remote get-url origin)" != "$REPO_URL" ]; then
        echo "Changing remote URL to $REPO_URL..."
        git -C "$DOTFILES_DIR" remote set-url origin "$REPO_URL"
    fi

    # Pull the latest changes
    echo "Pulling latest changes..."
    git -C "$DOTFILES_DIR" pull --ff-only
fi

# Navigate to the dotfiles directory and checkout the specified branch
cd "$DOTFILES_DIR"
if [ "$(git rev-parse --abbrev-ref HEAD)" != "$BRANCH" ]; then
    git checkout "$BRANCH"
fi

# Make scripts executable
chmod +x "$DOTFILES_DIR"/scripts/*.sh

# Run the install script
"$DOTFILES_DIR/scripts/install.sh" -p "$PROFILE" -n "$GITAUTHORNAME" -e "$GITAUTHOREMAIL"
