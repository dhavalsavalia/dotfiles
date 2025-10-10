#!/bin/bash

# brew-capture.sh - Capture ad-hoc brew installs and sync them to Brewfiles
# Usage:
#   ./brew-capture.sh           # Interactive mode
#   ./brew-capture.sh --dry-run # Show what would be added
#   ./brew-capture.sh --auto    # Auto-add all to current profile

set -e

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

DRY_RUN=${DRY_RUN:-false}
AUTO_MODE=false
TARGET_PROFILE=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -a|--auto)
            AUTO_MODE=true
            shift
            ;;
        -p|--profile)
            TARGET_PROFILE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Capture ad-hoc brew installs and sync them to Brewfiles"
            echo ""
            echo "Options:"
            echo "  -d, --dry-run    Show packages that would be added without modifying files"
            echo "  -a, --auto       Automatically add all packages without prompting"
            echo "  -p, --profile    Target profile (home/garda/minimal)"
            echo "  -h, --help       Show this help message"
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Get current profile
get_current_profile() {
    local brewprofile_path="${XDG_CONFIG_HOME:-$HOME/.config}/.brewprofile"
    if [ -f "$brewprofile_path" ]; then
        cat "$brewprofile_path"
    else
        echo "home"  # default
    fi
}

# Normalize package name (remove tap prefix for comparison)
normalize_package_name() {
    local pkg="$1"
    # Remove tap prefix (e.g., "nikitabobko/tap/aerospace" -> "aerospace")
    echo "$pkg" | sed 's|.*/||'
}

# Get packages from Brewfiles
get_brewfile_packages() {
    local brew_dir="$DOTFILES_DIR/homebrew"
    local profile="${TARGET_PROFILE:-$(get_current_profile)}"

    local files=""
    if [ "$profile" = "minimal" ]; then
        files="$brew_dir/Brewfile.macos.minimal"
    else
        files="$brew_dir/Brewfile.macos.common $brew_dir/Brewfile.macos.$profile"
    fi

    # Extract package names and normalize
    cat $files 2>/dev/null | \
        grep -E '^(brew |cask |tap )' | \
        sed -E 's/(brew|cask|tap) "([^"]+)".*/\2/' | \
        while read pkg; do
            normalize_package_name "$pkg"
        done | sort -u
}

# Get manually installed packages
get_installed_packages() {
    # Get formulae (leaves only, manually installed)
    brew leaves

    # Get casks
    brew list --cask
}

# Check if package was manually installed (not a dependency)
is_manually_installed() {
    local pkg="$1"
    local json=$(brew info "$pkg" --json 2>/dev/null)

    if [ -z "$json" ]; then
        return 1
    fi

    # Check if installed_on_request is true
    echo "$json" | jq -r '.[0].installed[0].installed_on_request // false' | grep -q true
}

# Get package type (formula or cask)
get_package_type() {
    local pkg="$1"

    if brew list --cask | grep -qx "$pkg"; then
        echo "cask"
    else
        echo "brew"
    fi
}

# Get package description
get_package_desc() {
    local pkg="$1"
    brew info "$pkg" --json 2>/dev/null | jq -r '.[0].desc // "No description"' | head -c 60
}

# Find packages not in Brewfile
find_missing_packages() {
    local brewfile_pkgs=$(get_brewfile_packages)
    local installed_pkgs=$(get_installed_packages)

    local missing=()

    while IFS= read -r pkg; do
        local normalized=$(normalize_package_name "$pkg")

        # Skip if in Brewfile
        if echo "$brewfile_pkgs" | grep -qx "$normalized"; then
            continue
        fi

        # Skip if not manually installed
        if ! is_manually_installed "$pkg"; then
            continue
        fi

        missing+=("$pkg")
    done <<< "$installed_pkgs"

    printf '%s\n' "${missing[@]}"
}

# Format package for Brewfile
format_package_line() {
    local pkg="$1"
    local pkg_type=$(get_package_type "$pkg")
    local desc=$(get_package_desc "$pkg")

    if [ -n "$desc" ] && [ "$desc" != "null" ] && [ "$desc" != "No description" ]; then
        echo "$pkg_type \"$pkg\" # $desc"
    else
        echo "$pkg_type \"$pkg\""
    fi
}

# Add packages to Brewfile
add_to_brewfile() {
    local packages=("$@")
    local profile="${TARGET_PROFILE:-$(get_current_profile)}"
    local brew_dir="$DOTFILES_DIR/homebrew"

    # Determine target file
    local target_file
    if [ "$profile" = "minimal" ]; then
        target_file="$brew_dir/Brewfile.macos.minimal"
    else
        # Ask which file to add to (only in interactive mode)
        if [ "$AUTO_MODE" = false ] && command_exists gum; then
            target_file=$(gum choose \
                "$brew_dir/Brewfile.macos.common" \
                "$brew_dir/Brewfile.macos.$profile" \
                --header "Choose Brewfile to add packages:")
        else
            # Auto mode or no gum: add to profile-specific Brewfile
            target_file="$brew_dir/Brewfile.macos.$profile"
        fi
    fi

    log "Adding ${#packages[@]} package(s) to $(basename $target_file)"

    for pkg in "${packages[@]}"; do
        local line=$(format_package_line "$pkg")

        if [ "$DRY_RUN" = true ]; then
            echo "  [DRY RUN] Would add: $line"
        else
            echo "$line" >> "$target_file"
            log "✓ Added: $line"
        fi
    done

    if [ "$DRY_RUN" = false ]; then
        log "Done! Review changes with: git diff $target_file"
        log "Tip: Organize packages manually to maintain section headers and formatting"
    fi
}

# Main execution
main() {
    DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

    log "Scanning for packages not in Brewfile..."

    local missing_packages=($(find_missing_packages))

    if [ ${#missing_packages[@]} -eq 0 ]; then
        log "✓ All manually installed packages are in your Brewfile!"
        return 0
    fi

    log "Found ${#missing_packages[@]} package(s) not in Brewfile:"
    echo ""

    for pkg in "${missing_packages[@]}"; do
        local pkg_type=$(get_package_type "$pkg")
        local desc=$(get_package_desc "$pkg")
        echo "  [$pkg_type] $pkg"
        echo "      $desc"
        echo ""
    done

    if [ "$DRY_RUN" = true ]; then
        log "Dry run complete. Use without --dry-run to add packages."
        return 0
    fi

    if [ "$AUTO_MODE" = true ]; then
        add_to_brewfile "${missing_packages[@]}"
    else
        # Interactive mode with gum if available
        if command_exists gum; then
            local selected=$(printf '%s\n' "${missing_packages[@]}" | \
                gum choose --no-limit --header "Select packages to add to Brewfile (space to select, enter to confirm):")

            if [ -n "$selected" ]; then
                local selected_array=()
                while IFS= read -r line; do
                    selected_array+=("$line")
                done <<< "$selected"

                add_to_brewfile "${selected_array[@]}"
            else
                log "No packages selected."
            fi
        else
            warn "gum not installed. Install with: brew install gum"
            log "Adding all packages automatically..."
            add_to_brewfile "${missing_packages[@]}"
        fi
    fi
}

# Run main
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
