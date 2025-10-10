#!/bin/bash

set -e

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

AUTO_FIX=${AUTO_FIX:-false}
INTERACTIVE=${INTERACTIVE:-false}

check_cask_sync() {
    log "Checking for out-of-sync cask installations..."

    local out_of_sync=()

    # Get list of installed casks
    local installed_casks=($(brew list --cask 2>/dev/null || true))

    if [ ${#installed_casks[@]} -eq 0 ]; then
        log "No casks found to check"
        return 0
    fi

    # Get all cask info in one batch call
    local all_casks_json
    all_casks_json=$(brew info --cask "${installed_casks[@]}" --json=v2 2>/dev/null || echo '{"casks":[]}')

    # Process each cask from the JSON
    while IFS= read -r cask_json; do
        [ -z "$cask_json" ] || [ "$cask_json" = "null" ] && continue

        local cask_name=$(echo "$cask_json" | jq -r '.token')
        local brew_version=$(echo "$cask_json" | jq -r '.installed // empty')
        local app_path=$(echo "$cask_json" | jq -r '.artifacts[]? | select(.app != null) | .app[0] // empty' | head -n1)

        # Skip if no installed version or no app path
        [ -z "$brew_version" ] || [ -z "$app_path" ] && continue

        local full_app_path="/Applications/$app_path"

        # Skip if app doesn't exist
        [ ! -d "$full_app_path" ] && continue

        # Get actual version from app bundle
        local actual_version=$(defaults read "$full_app_path/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null || echo "")

        # Normalize versions for comparison (strip build numbers after comma)
        local brew_version_normalized=$(echo "$brew_version" | cut -d',' -f1)
        local actual_version_normalized="$actual_version"

        # Compare normalized versions
        if [ -n "$actual_version" ] && [ "$brew_version_normalized" != "$actual_version_normalized" ]; then
            out_of_sync+=("$cask_name: brew=$brew_version, actual=$actual_version")
        fi
    done < <(echo "$all_casks_json" | jq -c '.casks[]?')

    # Report findings
    if [ ${#out_of_sync[@]} -gt 0 ]; then
        warn "Found ${#out_of_sync[@]} out-of-sync cask(s):"

        # Extract just the cask names for reinstall
        local cask_names=()
        for item in "${out_of_sync[@]}"; do
            echo "  - $item"
            local cask_name=$(echo "$item" | cut -d: -f1)
            cask_names+=("$cask_name")
        done
        echo ""

        # Handle auto-fix or interactive mode
        if [ "$AUTO_FIX" = true ]; then
            log "Auto-fixing all out-of-sync casks..."
            for cask in "${cask_names[@]}"; do
                log "Reinstalling $cask..."
                execute "brew reinstall --cask $cask"
            done
            log "✓ All casks reinstalled and synced"
            return 0
        elif [ "$INTERACTIVE" = true ] && command_exists gum; then
            log "Select casks to reinstall and sync:"
            local selected=$(printf '%s\n' "${cask_names[@]}" | \
                gum choose --no-limit --header "Select casks to reinstall (space to select, enter to confirm):")

            if [ -n "$selected" ]; then
                local selected_array=()
                while IFS= read -r line; do
                    selected_array+=("$line")
                done <<< "$selected"

                log "Reinstalling ${#selected_array[@]} cask(s)..."
                for cask in "${selected_array[@]}"; do
                    log "Reinstalling $cask..."
                    execute "brew reinstall --cask $cask"
                done
                log "✓ Selected casks reinstalled and synced"
                return 0
            else
                log "No casks selected. Skipping."
                return 1
            fi
        else
            log "These apps may have been manually updated outside of Homebrew."
            log "Run 'brew reinstall --cask <cask>' to sync Homebrew's database."
            log "Or run with --auto-fix to reinstall all, or --interactive for selection."
            return 1
        fi
    else
        log "All casks are in sync ✓"
        return 0
    fi
}

fix_all_out_of_sync() {
    AUTO_FIX=true check_cask_sync
}

fix_interactive() {
    INTERACTIVE=true check_cask_sync
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -a|--auto-fix)
                AUTO_FIX=true
                shift
                ;;
            -i|--interactive)
                INTERACTIVE=true
                shift
                ;;
            -h|--help)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Check for out-of-sync cask installations (manually updated outside brew)"
                echo ""
                echo "Options:"
                echo "  -a, --auto-fix      Automatically reinstall all out-of-sync casks"
                echo "  -i, --interactive   Interactive selection with gum"
                echo "  -h, --help          Show this help message"
                echo ""
                echo "Examples:"
                echo "  $0                   # Check only (report issues)"
                echo "  $0 --interactive     # Select casks to fix with gum"
                echo "  $0 --auto-fix        # Reinstall all out-of-sync casks"
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    check_cask_sync
fi
