#!/bin/bash

set -e

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

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

        # Compare versions
        if [ -n "$actual_version" ] && [ "$brew_version" != "$actual_version" ]; then
            out_of_sync+=("$cask_name: brew=$brew_version, actual=$actual_version")
        fi
    done < <(echo "$all_casks_json" | jq -c '.casks[]?')

    # Report findings
    if [ ${#out_of_sync[@]} -gt 0 ]; then
        warn "Found ${#out_of_sync[@]} out-of-sync cask(s):"
        for item in "${out_of_sync[@]}"; do
            echo "  - $item"
        done
        echo ""
        log "These apps may have been manually updated outside of Homebrew."
        log "Run 'brew reinstall <cask>' to sync Homebrew's database and get latest version."
        return 1
    else
        log "All casks are in sync ✓"
        return 0
    fi
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    check_cask_sync
fi
