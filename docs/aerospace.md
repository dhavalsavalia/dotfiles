# Aerospace Window Manager Configuration

Aerospace is a powerful window manager for macOS that enables efficient window management and workspace organization. This document outlines my personal configuration, key bindings, and workflows.

## Core Configuration

- Start at login: Enabled
- After startup commands:
  - Launch `borders` for window borders
  - Launch `sketchybar` for status bar
  - Initialize BSP tiling script

## Workspaces

I use dedicated workspaces for different types of work:

| Workspace | Key Binding | Purpose |
|-----------|------------|---------|
| B | `alt + b` | Browser |
| C | `alt + c` | Communication |
| D | `alt + d` | Development |
| T | `alt + t` | Terminal |
| A | `alt + a` | API Tools |
| M | `alt + m` | Music |
| X | `alt + x` | Extra |

To move windows between workspaces, use `alt + shift + [workspace key]`.

## Modes

### Main Mode
The default mode for window management.

#### Window Navigation
- Focus window: `alt + [h/j/k/l]`
- Move window: `alt + shift + [h/j/k/l]`
- Fullscreen: `alt + f`
- Split:
  - Horizontal: `alt + shift + g`
  - Vertical: `alt + shift + v`
  - Opposite: `alt + shift + s`

#### Monitor Management
- Move to next monitor: `alt + right`
- Move to prev monitor: `alt + shift + right`
- Quick switch workspace: `alt + tab`

### Layout Mode (`cmd + alt + ctrl + shift + l`)
Quick layout adjustments and window resizing.

#### Layout Options
- Horizontal tiles: `x`
- Vertical tiles: `v`
- Accordion: `a`
- Center floats: `f`
- Mixed (h_tiles v_accordion): `t`
- Maximize: `m`

#### Window Sizing
- Decrease size: `-`
- Increase size: `=`
- Balance sizes: `0`
- Ultrawide presets:
  - Third: `3` (1146px)
  - Quarter: `4` (860px)
  - Two-thirds: `5` (2292px)
  - Three-quarters: `6` (2580px)

### Service Mode (`alt + shift + ;`)
System management commands.

- Reload config: `c`
- Restart Aerospace: `a`

## Gaps Configuration

```toml
[gaps]
inner.horizontal = 0
inner.vertical = 0
outer.left = 0
outer.bottom = 0
outer.top = [
  { monitor.'built-in' = 5 },
  { monitor.'lg' = 37 },
  37,                         # Rest of the monitors
]
outer.right = 0
```

## Dynamic BSP Tiling

The setup includes a dynamic BSP (Binary Space Partitioning) tiling script that automatically arranges windows based on the following rules:
- First window in workspace: Splits horizontally
- Subsequent windows: Splits with opposite orientation
- Updates every 50ms to catch new windows

## Tips and Workflows

### Quick Tips
- Use `alt + tab` for quick workspace switching
- Layout mode (`cmd + alt + ctrl + shift + l`) is your friend for quick adjustments
- Center floating windows with `f` in layout mode
- Balance window sizes with `0` in layout mode

## Troubleshooting & Debugging

### Scripts Not Working
1. Check script permissions:
   ```bash
   # Make scripts executable
   chmod +x ~/.config/aerospace/scripts/*.sh
   chmod +x ~/.config/aerospace/scripts/center_floats
   ```

### Sketchybar Integration Issues
1. Check if sketchybar is running:
   ```bash
   pgrep sketchybar || echo "Sketchybar not running"
   ```

2. Verify event triggers:
   ```bash
   # Test aerospace mode change event
   sketchybar --trigger aerospace_mode_change MODE=main
   ```

3. Debug sketchybar plugins:
   - Enable logging in plugins by adding:
     ```bash
     set -x  # At start of plugin
     exec 2>> /tmp/sketchybar_aerospace.log
     ```
   - Check logs: `tail -f /tmp/sketchybar_aerospace.log`

### Window Management Problems
1. BSP Tiling Script:
   - Check if running: `pgrep -f "bsp_tiling.sh"`
   - Restart script: `~/.config/aerospace/scripts/bsp_tiling.sh`
   - Debug output:
     ```bash
     # Add to bsp_tiling.sh temporarily
     set -x
     exec 2>> /tmp/aerospace_bsp.log
     ```

2. Window Not Responding:
   - Reset window state: `aerospace reload-config`
   - Force window to tile: Enter layout mode (`cmd + alt + ctrl + shift + l`) and press `x`

### Common Error Messages
1. "Failed to execute script":
   - Check script exists and is executable
   - Verify no syntax errors: `bash -n script.sh`

2. "No such workspace":
   - Ensure workspace is defined in config
   - Try reloading config: `aerospace reload-config`

3. "Cannot move window":
   - Window might be stuck in fullscreen
   - Exit fullscreen (`alt + f`) then try moving

### Reset and Recovery
1. Full Reset:
   ```bash
   # Stop all related processes
   pkill -f "aerospace"
   pkill -f "bsp_tiling"
   pkill -f "center_floats"
   
   # Restart aerospace
   ~/.config/aerospace/scripts/restart_aerospace.sh
   ```

2. Config Recovery:
   ```bash
   # Backup current config
   cp ~/.config/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml.bak
   
   # Reset to default config
   cp /usr/local/etc/aerospace/aerospace.toml ~/.config/aerospace/
   ```

### Logging and Debugging
1. Enable debug logs:
   ```bash
   # Add to your shell rc file (.zshrc/.bashrc)
   export AEROSPACE_LOG_LEVEL=debug
   ```

2. Monitor logs:
   ```bash
   tail -f ~/.local/share/aerospace/aerospace.log
   ```

3. Check system logs:
   ```bash
   log show --predicate 'process == "aerospace"' --last 5m
   ```

### Performance Issues
1. High CPU Usage:
   - Check if BSP script polling too frequently (adjust sleep time)
   - Monitor process: `top -pid $(pgrep aerospace)`

2. Slow Window Movement:
   - Reduce number of workspace change triggers
   - Simplify sketchybar integration scripts

### Getting Help
1. Generate debug info:
   ```bash
   aerospace --version
   ls -l ~/.config/aerospace/
   cat ~/.local/share/aerospace/aerospace.log
   ```

2. Check common locations for issues:
   - `~/.config/aerospace/` - Configuration files
   - `~/.local/share/aerospace/` - Log files
   - `/tmp/` - Debug logs for scripts