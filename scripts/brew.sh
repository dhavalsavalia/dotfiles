#!/bin/bash

set -e

# Source utils if not already sourced
source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

install_homebrew() {
    if command_exists "brew"; then
        log "Homebrew is already installed"
        return 0
    fi

    log "Installing Homebrew..."
    execute '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

    # Setup shell environment
    setup_shell_env

    # Add Homebrew to current session
    if [ -f "/opt/homebrew/bin/brew" ]; then
        execute 'eval "$(/opt/homebrew/bin/brew shellenv)"'
    fi
}

setup_shell_env() {
    local zprofile="$HOME/.zprofile"
    local brew_env='eval "$(/opt/homebrew/bin/brew shellenv)"'

    # Create .zprofile if it doesn't exist
    if [ ! -f "$zprofile" ]; then
        touch "$zprofile"
    fi

    # Add brew to PATH only if it's not already there
    if ! grep -q "brew shellenv" "$zprofile"; then
        log "Adding Homebrew to PATH in .zprofile"
        echo >> "$zprofile"
        echo '# Homebrew PATH' >> "$zprofile"
        echo "$brew_env" >> "$zprofile"
    fi

    # Run brew shellenv so it's available in current session
    execute "$brew_env"
}

generate_combined_brewfile() {
    local profile="$1"
    local brew_dir="$DOTFILES_DIR/.data/homebrew"
    local common_file="$brew_dir/Brewfile.macos.common"
    local profile_file="$brew_dir/Brewfile.macos.$profile"
    local combined_file="$brew_dir/Brewfile.combined"

    # Check if required files exist
    if [ "$profile" = "minimal" ]; then
        if [ ! -f "$profile_file" ]; then
            error "Missing Brewfile: $profile_file"
            return 1
        fi
        # Use only the minimal Brewfile
        log "Using minimal Brewfile..."
        execute "cat > '$combined_file' << EOF
# Generated minimal Brewfile
$(cat "$profile_file")
EOF"
    else
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
    fi

    echo "$combined_file"
}

install_packages() {
    local profile="$1"
    local combined_file
    generate_combined_brewfile "$profile"

    local brew_dir="$DOTFILES_DIR/.data/homebrew"
    combined_file="$brew_dir/Brewfile.combined"

    log "Installing Homebrew packages for profile: $profile"

    # Update Homebrew first
    execute "brew update"

    # Install from Brewfile
    execute "brew bundle --file='$combined_file'"
}

cleanup_packages() {
    local profile="$1"
    local combined_file
    generate_combined_brewfile "$profile"

    local brew_dir="$DOTFILES_DIR/.data/homebrew"
    combined_file="$brew_dir/Brewfile.combined"

    log "Cleaning up unused Homebrew packages..."
    execute "brew bundle cleanup --file='$combined_file'"
}

setup_homebrew() {
    local profile="$1"

    # Validate profile
    if [ "$profile" != "home" ] && [ "$profile" != "garda" ] && [ "$profile" != "minimal" ]; then
        error "Profile must be either 'home', 'garda', or 'minimal'"
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
