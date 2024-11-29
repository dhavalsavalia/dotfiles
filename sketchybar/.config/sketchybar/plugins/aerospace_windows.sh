#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

update_workspace() {
    local workspace_id="$1"
    local apps=""
    local unique_apps=""

    # Get all app names in the workspace and map them to icons
    while read -r app_name; do
        if [[ -n "$app_name" && ! "$unique_apps" =~ "$app_name" ]]; then
            icon="$($CONFIG_DIR/plugins/icon_map.sh "$app_name")"
            apps="$apps $icon"
            unique_apps="$unique_apps $app_name"
        fi
    done < <(aerospace list-windows --workspace "$workspace_id" --json | jq -r '.[]."app-name"')

    # Update the workspace label
    if [ -n "$apps" ]; then
        sketchybar --set space.$workspace_id label="$apps"
    else
        sketchybar --set space.$workspace_id label=" —"
    fi
}

# Handle workspace change event
if [ "$SENDER" = "aerospace_workspace_change" ]; then
    # Update all workspaces
    for workspace_id in $(aerospace list-workspaces --all); do
        update_workspace "$workspace_id"
    done
fi
