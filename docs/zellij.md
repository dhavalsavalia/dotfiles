# Zellij Quick Reference

## Daily Workflow

### Starting Sessions
```bash
zellij                      # default layout
zellij --layout seditor     # shell + editor split
zellij --layout sgit        # shell + lazygit split
zellij --layout dev         # full dev workspace

zellij --session myproject  # named session
zellij attach myproject     # reattach
```

### Essential Keybinds
```
Alt+s       → Session picker (switch/resurrect)
Alt+t       → New tab
Alt+o       → Toggle between last two tabs
Alt+1-9     → Jump to tab by number
Alt+n/p     → Next/previous tab
Alt+h/j/k/l → Navigate panes (vim-style)
Alt+f       → File picker (browse & open files)
Alt+x       → Close pane
Alt+z       → Zoom pane
Alt+|       → Split right
Alt+_       → Split down
Ctrl+g      → Lock mode (for Neovim)
```

### File Picker (Replaces fzf)
Press `Alt+f`:
- Arrow keys to navigate
- Tab to select
- Enter to open in editor
- Ctrl+e to show hidden files

### Session Management
Press `Alt+s`:
- `w` - List all sessions
- Tab view shows recently closed (resurrect them!)
- Arrow keys + Enter to switch

### Quick Tips
- **Lock mode**: Use `Ctrl+g` before Neovim to avoid key conflicts
- **Floating panes**: `Ctrl+p w` for temporary terminal over editor
- **Detach**: `Ctrl+o d` (sessions persist in background)
- **Tab rename**: `Ctrl+t r` then type name

## Replaces These Tools
- **fzf** → Built-in file picker (`Alt+f`)
- **tmuxifier** → KDL layouts
- **Session scripts** → Native session manager
- **tmux plugins** → Built-in features

## Layouts Location
`~/.config/zellij/layouts/*.kdl`

Edit to customize or create new workspaces.
