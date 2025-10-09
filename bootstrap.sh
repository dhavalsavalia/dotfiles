#!/bin/bash

set -e

REPO_URL="https://github.com/dhavalsavalia/dotfiles.git"
SSH_REPO_URL="git@github.com:dhavalsavalia/dotfiles"
DOTFILES_DIR="$HOME/dotfiles"

# Default values
PROFILE="${DOTFILES_PROFILE:-minimal}"
BRANCH="${DOTFILES_BRANCH:-main}"
MACOS_DEFAULTS="${DOTFILES_MACOS_DEFAULTS:-true}"
NO_GIT="${DOTFILES_NO_GIT:-false}"
if [ "$USE_SSH" = "true" ]; then
  REPO_URL="$SSH_REPO_URL"
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

# Run the install script
arguments=()
if [ -n "$PROFILE" ]; then
    arguments+=("-p" "$PROFILE")
fi
if [ -n "$PROVIDED_GITAUTHORNAME" ]; then
    arguments+=("-n" "$PROVIDED_GITAUTHORNAME")
fi
if [ -n "$PROVIDED_GITAUTHOREMAIL" ]; then
    arguments+=("-e" "$PROVIDED_GITAUTHOREMAIL")
fi
if [ "$MACOS_DEFAULTS" = "true" ]; then
    arguments+=("-m")
fi
if [ "$NO_GIT" = "true" ]; then
    arguments+=("-g")
fi

"$DOTFILES_DIR"/scripts/install.sh "${arguments[@]}"
