#!/bin/bash

set -e

REPO_URL="https://github.com/dhavalsavalia/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# Default values
PROFILE="${DOTFILES_PROFILE:-minimal}"
BRANCH="${DOTFILES_BRANCH:-main}"

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
if [ -n "$PROVIDED_GITAUTHORNAME" ] || [ -n "$PROVIDED_GITAUTHOREMAIL" ]; then
    "$DOTFILES_DIR/scripts/install.sh" -p "$PROFILE" -n "$PROVIDED_GITAUTHORNAME" -e "$PROVIDED_GITAUTHOREMAIL"
else
    "$DOTFILES_DIR/scripts/install.sh" -p "$PROFILE"
fi
