# Zellij Configuration

## Overview

Zellij is a modern terminal workspace ("multiplexer") that consolidates functionality from multiple tools. This configuration runs **alongside tmux** (not replacing it) to allow gradual migration and experimentation.

## What Zellij Replaces/Consolidates

### ✅ Built-in Features (No Extra Packages Needed)

| Tool/Feature | Zellij Equivalent | Status |
|--------------|-------------------|--------|
| **fzf** (file finding) | Built-in Strider filepicker (`Alt+f`) | Native |
| **fd** (file discovery) | Strider fuzzy search | Native |
| **tmuxifier** (layouts) | KDL layout system | Native |
| **Session list/picker** | Built-in session manager (`Alt+s` then `w`) | Native |
| **Window/pane management** | Floating panes, tabs, stacked panes | Native |
| **Status bar** | Built-in status-bar plugin | Native |
| **Session resurrection** | Session serialization (manual) | Native |

### 🔌 Available Plugins (Install as Needed)

| Tool | Plugin | Description |
|------|--------|-------------|
| **sesh** | `zsm` or `zellij-sessionizer` | Zoxide-integrated session switching |
| **Git branch switcher** | `zj-git-branch` | Git workflow integration |
| **System monitor** | `zj-docker`, `zellij-datetime` | Container/system info |
| **Enhanced status** | `zjstatus` | Customizable status bar |

## Key Differences from Tmux

### Advantages
- **Self-documenting**: On-screen keybinding hints
- **Modern UX**: Floating panes, stacked panes
- **Batteries included**: File picker, session manager built-in
- **No plugin manager needed**: Core features are native
- **Better defaults**: Works great out of the box

### Considerations
- **No auto-restore on boot** (like tmux-continuum)
- **Different keybinds** (uses modes instead of prefix key)
- **Lock mode required** for Neovim to avoid key conflicts
- **Younger ecosystem** (fewer third-party integrations)

## Keybindings (Optimized for Your Workflow)

### Session Management
- `Alt+s` - Session mode (like your tmux `M-s`)
- `Alt+s` then `w` - List/switch sessions
- `Alt+s` then `r` - Resurrect closed session

### Tab (Window) Management
- `Alt+t` - New tab
- `Alt+n` - Next tab
- `Alt+p` - Previous tab
- `Alt+w` - Close tab

### Pane Navigation (Vi-style)
- `Alt+h/j/k/l` - Move focus between panes

### Pane Management
- `Alt+|` - Split right
- `Alt+_` - Split down
- `Alt+x` - Close pane
- `Alt+z` - Zoom/fullscreen pane

### File Operations
- `Alt+f` - Open file picker (replaces fzf)

### Vim Users
- `Ctrl+g` - Toggle Lock mode (disables Zellij keys for Neovim)

## Layouts

### Available Layouts

1. **default** - Simple single pane with status bars
   ```bash
   zellij
   ```

2. **seditor** - Shell (30%) + LunarVim (70%)
   ```bash
   zellij --layout seditor
   ```

3. **sgit** - Shell (30%) + Lazygit (70%)
   ```bash
   zellij --layout sgit
   ```

4. **dev** - Full development workspace (editor + git + terminals)
   ```bash
   zellij --layout dev
   ```

### Creating Custom Layouts

Layouts are in `~/.config/zellij/layouts/*.kdl` using KDL syntax:

```kdl
layout {
    tab name="myworkspace" {
        pane split_direction="vertical" {
            pane size="50%" {
                command "htop"
            }
            pane size="50%"
        }
    }
}
```

## Usage Examples

### Quick Start
```bash
# Start with default layout
zellij

# Start with custom layout
zellij --layout seditor

# Attach to existing session
zellij attach session-name

# List sessions
zellij list-sessions
```

### File Picker Workflow
```bash
# Inside Zellij, press Alt+f
# Navigate with arrow keys
# Tab to select, Enter to open in editor
# Ctrl+e to toggle hidden files
```

### Session Management
```bash
# Create named session
zellij --session myproject

# Detach (press Ctrl+o then d)

# Reattach
zellij attach myproject

# Kill session
zellij kill-session myproject
```

### Advanced: Piping with File Picker
```bash
# In your shell
zpipe filepicker | xargs -i cp {} /destination/

# This lets you pick files visually and pipe to commands
```

## Integration with Existing Tools

### Works Great With
- ✅ **Lazygit** - Runs perfectly in panes
- ✅ **LunarVim** - Use Lock mode (`Ctrl+g`)
- ✅ **Starship prompt** - No issues
- ✅ **Zoxide** - Works normally, or use `zsm` plugin
- ✅ **Alacritty/Kitty** - Full true color support

### Migration Strategy

**Phase 1: Trial** (Current)
- Keep tmux as primary
- Use Zellij for specific tasks:
  - Quick terminals (`zellij`)
  - File browsing (`Alt+f`)
  - Demo/presentation work

**Phase 2: Gradual Adoption**
- Use Zellij for new projects
- Keep tmux for established workflows
- Evaluate which you prefer

**Phase 3: Decision Point**
- After 2-4 weeks, decide:
  - Full migration to Zellij
  - Hybrid approach (both tools)
  - Stay with tmux

## Tips & Tricks

### 1. Persistent File Browser Sidebar
```bash
zellij -l strider  # Launches with IDE-like file sidebar
```

### 2. Quick Project Switcher (Sesh-like)
Install the `zsm` plugin for zoxide integration:
```bash
# Add to config.kdl plugins section
# Then bind to key for quick access
```

### 3. Float a Pane
In normal mode:
- Create floating pane: `Ctrl+p` then `w`
- Great for temporary terminals over your editor

### 4. Stacked Panes
- Stack panes: `Ctrl+p` then `z`
- Cycle through: Tab when stacked
- Like tabs within a pane

## Troubleshooting

### Neovim Key Conflicts
**Problem**: Ctrl+o, Ctrl+t don't work in Neovim
**Solution**: Press `Ctrl+g` to enter Lock mode before using Neovim

### Colors Look Wrong
**Problem**: Theme doesn't match
**Solution**: Check terminal true color support:
```bash
echo $TERM
# Should be "alacritty" or "xterm-256color"
```

### File Picker Not Working
**Problem**: `Alt+f` doesn't open picker
**Solution**: Make sure Zellij is installed: `which zellij`

## Configuration Files

```
~/.config/zellij/
├── config.kdl           # Main configuration
├── layouts/
│   ├── default.kdl      # Default layout
│   ├── seditor.kdl      # Shell + Editor
│   ├── sgit.kdl         # Shell + Git
│   └── dev.kdl          # Full dev workspace
└── plugins/             # Custom plugins (future)
```

## Resources

- Official docs: https://zellij.dev/documentation/
- Awesome plugins: https://github.com/zellij-org/awesome-zellij
- Layouts guide: https://zellij.dev/documentation/creating-a-layout.html

## Next Steps

1. Install: `brew install zellij` (already in Brewfile)
2. Stow config: `cd ~/dotfiles && stow zellij`
3. Try it: `zellij --layout seditor`
4. Compare with tmux for your workflows
5. Report back what you like/don't like!
