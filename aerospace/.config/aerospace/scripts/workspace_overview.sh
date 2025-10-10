#!/bin/bash

# Workspace Overview - Exposé-style workspace switcher
# Shows thumbnails of all workspaces in a grid with labels
# Uses macOS screencapture and AeroSpace workspace switching

TEMP_DIR="/tmp/aerospace-overview"
mkdir -p "$TEMP_DIR"

# Monokai Pro Spectrum colors for workspace labels
declare -A WORKSPACE_COLORS=(
    ["B"]="#5ad4e6"  # Browser - Cyan
    ["C"]="#fc618d"  # Teams - Red
    ["D"]="#7bd88f"  # Dev - Green
    ["T"]="#fd9353"  # Terminal - Orange
    ["A"]="#948ae3"  # API - Magenta
    ["O"]="#fce566"  # Outlook - Yellow
    ["M"]="#f7f1ff"  # More Dev - White
    ["X"]="#f7f1ff"  # Extra - White
)

declare -A WORKSPACE_LABELS=(
    ["B"]="Browser"
    ["C"]="Teams"
    ["D"]="Dev"
    ["T"]="Terminal"
    ["A"]="API"
    ["O"]="Outlook"
    ["M"]="More Dev"
    ["X"]="Extra"
)

# Get current focused workspace to restore later
CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)

# Capture screenshots of each workspace
WORKSPACES=(B C D T A O M X)
for ws in "${WORKSPACES[@]}"; do
    # Switch to workspace
    aerospace workspace "$ws" 2>/dev/null

    # Small delay for workspace switch to complete
    sleep 0.3

    # Capture screenshot
    screencapture -x "$TEMP_DIR/${ws}.png" 2>/dev/null
done

# Return to original workspace
aerospace workspace "$CURRENT_WORKSPACE" 2>/dev/null

# Create HTML overview page
cat > "$TEMP_DIR/overview.html" <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Workspace Overview</title>
    <style>
        body {
            margin: 0;
            padding: 20px;
            background: #2d2a2e;
            font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
            color: #fcfcfa;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            max-width: 1800px;
            margin: 0 auto;
        }
        .workspace {
            position: relative;
            cursor: pointer;
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
            box-shadow: 0 4px 6px rgba(0,0,0,0.3);
        }
        .workspace:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 16px rgba(0,0,0,0.4);
        }
        .workspace.current {
            box-shadow: 0 0 0 4px #fce566;
        }
        .workspace img {
            width: 100%;
            height: auto;
            display: block;
        }
        .label {
            position: absolute;
            top: 10px;
            left: 10px;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 14px;
            background: rgba(45, 42, 46, 0.9);
            backdrop-filter: blur(10px);
            border: 2px solid;
        }
        .key {
            position: absolute;
            top: 10px;
            right: 10px;
            width: 32px;
            height: 32px;
            border-radius: 6px;
            background: rgba(45, 42, 46, 0.9);
            backdrop-filter: blur(10px);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 16px;
            border: 2px solid;
        }
        .hint {
            text-align: center;
            margin-top: 30px;
            font-size: 14px;
            color: #939293;
        }
    </style>
</head>
<body>
    <div class="grid">
EOF

# Add workspace divs
for ws in "${WORKSPACES[@]}"; do
    color="${WORKSPACE_COLORS[$ws]}"
    label="${WORKSPACE_LABELS[$ws]}"
    current_class=""
    if [ "$ws" = "$CURRENT_WORKSPACE" ]; then
        current_class=" current"
    fi

    cat >> "$TEMP_DIR/overview.html" <<EOF
        <div class="workspace${current_class}" onclick="switchWorkspace('$ws')">
            <img src="${ws}.png" alt="Workspace $ws">
            <div class="label" style="border-color: $color; color: $color;">$label</div>
            <div class="key" style="border-color: $color; color: $color;">$ws</div>
        </div>
EOF
done

cat >> "$TEMP_DIR/overview.html" <<'EOF'
    </div>
    <div class="hint">
        Click workspace to switch • Press ESC to close • Alt + [ workspace key ] to switch directly
    </div>
    <script>
        function switchWorkspace(ws) {
            // Execute aerospace command via AppleScript
            const script = `do shell script "/opt/homebrew/bin/aerospace workspace ${ws}"`;
            const osa = `osascript -e '${script}'`;

            // Execute and close window
            const exec = require('child_process').exec;
            exec(osa, () => {
                window.close();
            });
        }

        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                window.close();
            }
            // Alt + letter for direct switching
            if (e.altKey && e.key.match(/[bcdtaomx]/i)) {
                switchWorkspace(e.key.toUpperCase());
            }
        });
    </script>
</body>
</html>
EOF

# Open in browser (will use default browser)
open "$TEMP_DIR/overview.html"
