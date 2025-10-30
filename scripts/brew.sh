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
    execute 'NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

    # Add Homebrew to current session. Later to be added by stow to .zprofile
    execute 'eval "$(/opt/homebrew/bin/brew shellenv)"'
}

generate_combined_brewfile() {
    local profile="$1"
    local brew_dir="$DOTFILES_DIR/homebrew"
    local common_file="$brew_dir/Brewfile.macos.common"
    local profile_file="$brew_dir/Brewfile.macos.$profile"
    local combined_file="/tmp/Brewfile.combined.$$"

    # Check if required files exist
    if [ "$profile" = "minimal" ]; then
        if [ ! -f "$profile_file" ]; then
            error "Missing Brewfile: $profile_file" >&2
            return 1
        fi
        # Use only the minimal Brewfile
        log "Using minimal Brewfile..." >&2
        execute "cat '$profile_file' > '$combined_file'" >&2
    else
        if [ ! -f "$common_file" ] || [ ! -f "$profile_file" ]; then
            error "Missing Brewfile(s): $common_file or $profile_file" >&2
            return 1
        fi
        # Generate combined Brewfile in /tmp
        log "Generating combined Brewfile..." >&2
        execute "cat '$common_file' '$profile_file' > '$combined_file'" >&2
    fi

    echo "$combined_file"
}

install_packages() {
    local profile="$1"
    local combined_file
    combined_file=$(generate_combined_brewfile "$profile")

    log "Installing Homebrew packages for profile: $profile"

    # Update Homebrew first
    execute "brew update"

    # Install from Brewfile
    execute "brew bundle --file='$combined_file'"

    # Clean up temp file
    rm -f "$combined_file"
}

cleanup_packages() {
    local profile="$1"
    local combined_file
    combined_file=$(generate_combined_brewfile "$profile")

    log "Cleaning up unused Homebrew packages..."
    log "NOTE: Use 'brew-capture.sh' to add ad-hoc installs to your Brewfile before cleanup"
    execute "brew bundle cleanup --file='$combined_file'"

    # Clean up temp file
    rm -f "$combined_file"
}

perform_brew_maintenance() {
    log "Running Homebrew maintenance tasks..."

    # Check for out-of-sync cask installations
    if [ -f "$DOTFILES_DIR/scripts/brew-check-sync.sh" ]; then
        source "$DOTFILES_DIR/scripts/brew-check-sync.sh"
        check_cask_sync || warn "Some casks are out of sync with Homebrew database"
    fi

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
    cleanup_packages "$profile"
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

    # If no profile is supplied, check or create .brewprofile
    if [ -z "$PROFILE" ]; then
        PROFILE=$(get_or_create_profile)
    fi

    setup_homebrew "$PROFILE"
fi
