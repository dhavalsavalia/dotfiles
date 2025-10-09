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

# Function to check if a command exists
check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        log "✓ $1 is installed"
        return 0
    else
        error "✗ $1 is not installed"
        return 1
    fi
}

# Function to check if a Homebrew package is installed
check_brew_package() {
    if brew list "$1" >/dev/null 2>&1; then
        log "✓ brew package $1 is installed"
        return 0
    else
        error "✗ brew package $1 is not installed"
        return 1
    fi
}

# Function to check if a Homebrew cask is installed
check_brew_cask() {
    if brew list --cask "$1" >/dev/null 2>&1; then
        log "✓ brew cask $1 is installed"
        return 0
    else
        error "✗ brew cask $1 is not installed"
        return 1
    fi
}

# Function to verify Homebrew installation
test_homebrew() {
    log "Testing Homebrew installation..."

    # Check if Homebrew is installed
    if ! check_command "brew"; then
        error "Homebrew is not installed!"
        exit 1
    fi

    # Check if brew doctor reports any issues
    if brew doctor >/dev/null 2>&1; then
        log "✓ brew doctor reports no issues"
    else
        warn "! brew doctor reports some issues"
    fi
}

# Function to verify common packages
test_common_packages() {
    log "Testing common packages..."

    local common_packages=(
        "git"
        "stow"
        "python"
        "zsh"
        # Add more common packages here
    )

    local failed=0
    for package in "${common_packages[@]}"; do
        check_brew_package "$package" || ((failed++))
    done

    return $failed
}

# Function to verify profile-specific packages
test_profile_packages() {
    local profile="$1"
    log "Testing profile-specific packages for $profile..."

    local home_packages=(
        "neovim"
        "fzf"
        "ripgrep"
        # Add more home-specific packages
    )

    local work_packages=(
        "neovim"
        "fzf"
        "docker"
        # Add more work-specific packages
    )

    local failed=0

    if [ "$profile" = "home" ]; then
        for package in "${home_packages[@]}"; do
            check_brew_package "$package" || ((failed++))
        done
    elif [ "$profile" = "garda" ]; then
        for package in "${work_packages[@]}"; do
            check_brew_package "$package" || ((failed++))
        done
    else
        error "Invalid profile: $profile"
        return 1
    fi

    return $failed
}

# Main test function
main() {
    local profile="$1"
    local total_failed=0

    # Validate profile
    if [ "$profile" != "home" ] && [ "$profile" != "garda" ]; then
        error "Profile must be either 'home' or 'garda'"
        exit 1
    fi

    log "Starting tests for profile: $profile"

    # Run tests
    test_homebrew || ((total_failed++))
    test_common_packages || ((total_failed++))
    test_profile_packages "$profile" || ((total_failed++))

    # Report results
    echo
    if [ $total_failed -eq 0 ]; then
        log "All tests passed successfully! 🎉"
    else
        error "$total_failed test groups failed"
        exit 1
    fi
}

# Parse command line arguments
while getopts "p:" opt; do
    case $opt in
        p) PROFILE="$OPTARG";;
        *) echo "Usage: $0 [-p profile]" >&2
           exit 1;;
    esac
done

# Run main function
main "$PROFILE"
