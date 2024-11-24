#!/bin/bash

set -e

# Source utils if not already sourced
source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

get_or_create_brewprofile() {
    local brewprofile_path="${XDG_CONFIG_HOME:-$HOME/.config}/.brewprofile"

    # Check if .brewprofile exists
    if [ ! -f "$brewprofile_path" ]; then
        log ".brewprofile not found at $brewprofile_path"
        read -rp "Enter profile (home/garda/minimal): " user_profile

        # Validate input
        while [[ "$user_profile" != "home" && "$user_profile" != "garda" && "$user_profile" != "minimal" ]]; do
            echo "Invalid profile. Please enter 'home', 'garda', or 'minimal'."
            read -rp "Enter profile: " user_profile
        done

        # Create .brewprofile and save the profile
        mkdir -p "$(dirname "$brewprofile_path")"
        echo "$user_profile" >"$brewprofile_path"
        log "Profile saved to $brewprofile_path"
    fi

    # Read and return the profile from .brewprofile
    cat "$brewprofile_path"
}


install_homebrew() {
    if command_exists "brew"; then
        log "Homebrew is already installed"
        return 0
    fi

    log "Installing Homebrew..."
    execute 'NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

    # Add Homebrew to current session. Later to be added by stow to .zprofile
    execute 'eval "$(/opt/homebrew/bin/brew shellenv)"'
}

generate_combined_brewfile() {
    local profile="$1"
    local brew_dir="$DOTFILES_DIR/homebrew"
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
        execute "cat '$profile_file' > '$combined_file'"
    else
        if [ ! -f "$common_file" ] || [ ! -f "$profile_file" ]; then
            error "Missing Brewfile(s): $common_file or $profile_file"
            return 1
        fi
        # Generate combined Brewfile
        log "Generating combined Brewfile..."
        execute "cat '$common_file' '$profile_file' > '$combined_file'"
    fi
}

install_packages() {
    local profile="$1"
    local combined_file
    generate_combined_brewfile "$profile"

    local brew_dir="$DOTFILES_DIR/homebrew"
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

    local brew_dir="$DOTFILES_DIR/homebrew"
    combined_file="$brew_dir/Brewfile.combined"

    log "Cleaning up unused Homebrew packages..."
    execute "brew bundle cleanup --file='$combined_file' --force"
}

perform_brew_maintenance() {
    log "Running Homebrew maintenance tasks..."

    # Check system health
    # execute "brew doctor"  # TODO: `brew doctor` doesn't work on MacOS Sequoia for now. Come back later.
    execute "brew missing"

    # Upgrade installed packages
    execute "brew upgrade"
    execute "brew upgrade --cask"

    # Cleanup outdated versions
    execute "brew cleanup"
}

setup_homebrew() {
    local profile="$1"

    # Validate profile
    if [ "$profile" != "home" ] && [ "$profile" != "garda" ] && [ "$profile" != "minimal" ]; then
        # NOTE: Yeah, I know this fails the first time you run the script.
        # Don't worry, it's just a one-time thing. Just run the script again.
        error "Profile must be either 'home', 'garda', or 'minimal'"
        return 1
    fi

    install_homebrew

    install_packages "$profile"
    perform_brew_maintenance
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    while getopts "p:d" opt; do
        case $opt in
        p) PROFILE="$OPTARG" ;;
        d) DRY_RUN="true" ;;
        *)
            echo "Usage: $0 [-p profile] [-d]" >&2
            exit 1
            ;;
        esac
    done

    # Set DOTFILES_DIR if running directly
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

    # If no profile is supplied, check or create .brewprofile
    if [ -z "$PROFILE" ]; then
        PROFILE=$(get_or_create_brewprofile)
    fi

    setup_homebrew "$PROFILE"
fi
