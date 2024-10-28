#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Function to execute commands with dry run support
execute() {
    if [ "$DRY_RUN" = "true" ]; then
        echo "WOULD EXECUTE: $*"
        return 0
    else
        echo "EXECUTING: $*"
        eval "$@"
        return $?
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_homebrew() {
    if command_exists "brew"; then
        log "Homebrew is already installed"
        return 0
    fi

    log "Installing Homebrew..."
    execute '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

    # Add Homebrew to PATH for Apple Silicon
    if [ -f "/opt/homebrew/bin/brew" ]; then
        execute 'eval "$(/opt/homebrew/bin/brew shellenv)"'
    fi
}

generate_combined_brewfile() {
    local profile="$1"
    local brew_dir="$DOTFILES_DIR/.data/homebrew"
    local common_file="$brew_dir/Brewfile.macos.common"
    local profile_file="$brew_dir/Brewfile.macos.$profile"
    local combined_file="$brew_dir/Brewfile.combined"

    # Check if required files exist
    if [ ! -f "$common_file" ] || [ ! -f "$profile_file" ]; then
        error "Missing Brewfile(s): $common_file or $profile_file"
        return 1
    fi

    # Generate combined Brewfile
    log "Generating combined Brewfile..."
    execute "cat > '$combined_file' << EOF
# Generated combined Brewfile
# Common packages
$(cat "$common_file")

# Profile-specific packages ($profile)
$(cat "$profile_file")
EOF"

    echo "$combined_file"
}

install_packages() {
    local profile="$1"
    local combined_file
    combined_file=$(generate_combined_brewfile "$profile")

    if [ -z "$combined_file" ]; then
        error "Failed to generate combined Brewfile"
        return 1
    fi

    log "Installing Homebrew packages for profile: $profile"

    # Update Homebrew first
    execute "brew update"

    # Install from Brewfile
    execute "brew bundle --file='$combined_file'"
}

cleanup_packages() {
    local profile="$1"
    local combined_file
    combined_file=$(generate_combined_brewfile "$profile")

    if [ -z "$combined_file" ]; then
        error "Failed to generate combined Brewfile"
        return 1
    fi

    log "Cleaning up unused Homebrew packages..."
    execute "brew bundle cleanup --file='$combined_file'"
}

setup_homebrew() {
    local profile="$1"

    # Validate profile
    if [ "$profile" != "home" ] && [ "$profile" != "1" ]; then
        error "Profile must be either 'home' or '1'"
        return 1
    fi

    install_homebrew
    install_packages "$profile"
    cleanup_packages "$profile"
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Parse command line arguments
    while getopts "p:d" opt; do
        case $opt in
            p) PROFILE="$OPTARG";;
            d) DRY_RUN="true";;
            *) echo "Usage: $0 [-p profile] [-d]" >&2
               exit 1;;
        esac
    done

    # Set DOTFILES_DIR if running directly
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

    setup_homebrew "$PROFILE"
fi
