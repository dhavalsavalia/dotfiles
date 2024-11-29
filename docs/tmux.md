# Tmux Configuration and Workflow

This document outlines my tmux setup, including plugins, key bindings, and workflow integration with other tools.

## Overview

My tmux configuration focuses on creating an efficient terminal multiplexer environment with:
- Vim-style navigation
- Custom key bindings for quick window/pane management
- Integration with tools like `sesh` and `tmuxifier` for enhanced session management
- Modern aesthetics with the Monokai Pro theme
- Persistent sessions with automatic save/restore

## Installation

The tmux setup is automatically installed through the dotfiles installation script. It includes:
1. Installing tmux via package manager
2. Setting up TPM (Tmux Plugin Manager)
3. Installing tmuxifier for layout management
4. Configuring various plugins and themes

## Key Components

### Plugin Manager (TPM)
- Located at `$XDG_CONFIG_HOME/tmux/plugins/tpm`
- Manages all tmux plugins
- Install plugins: `prefix` + `I`
- Update plugins: `prefix` + `U`

### Active Plugins
1. **tpm**: Plugin manager itself
2. **monokai-pro.tmux**: Theme with Spectrum filter
3. **vim-tmux-navigator**: Seamless navigation between vim and tmux panes
4. **tmux-resurrect**: Session persistence
5. **tmux-continuum**: Automatic session saving

### Key Bindings

#### Basic Operations
- Leader key: `Ctrl + s`
- Reload config: `prefix` + `r`
- Mouse mode: Enabled

#### Window Management
- New window: `Alt + t`
- Kill window: `Alt + w`
- Switch to window 1-3: `Alt + 1-3`

#### Pane Operations
- Split vertically: `prefix` + `|`
- Split horizontally: `prefix` + `-`
- Kill pane: `prefix` + `x`

#### Pane Navigation (Vim-style)
- Left: `prefix` + `h`
- Down: `prefix` + `j`
- Up: `prefix` + `k`
- Right: `prefix` + `l`

#### Pane Resizing
- Left: `prefix` + `<`
- Right: `prefix` + `>`
- Up: `prefix` + `+`
- Down: `prefix` + `-`

#### Session Management
- Choose session: `Alt + s`
- Connect via sesh: `prefix` + `T`
- Last session: `prefix` + `L`
- Load tmuxifier window: `prefix` + `W`

### Session Management Tools

#### Sesh Integration
Sesh provides fuzzy-finding session management with various filters:
- `Ctrl + a`: Show all sessions
- `Ctrl + t`: Show tmux sessions
- `Ctrl + x`: Show zoxide directories
- `Ctrl + d`: Kill sessions

#### Tmuxifier
- Manages predefined window layouts
- Layouts stored in `$XDG_CONFIG_HOME/tmux/layouts`
- Quick access through `prefix` + `W`

## Terminal Integration

### Color Support
- Uses Alacritty as the default terminal
- True color (RGB) support enabled
- Colored underscores supported

### Vim Integration
- Vi mode enabled for copy mode
- Seamless navigation between vim and tmux panes
- Session restoration support for Neovim

## Persistence

### Auto Save/Restore
- Automatic session restoration on tmux start
- Continuous saving of sessions
- Neovim session strategy enabled

## Workflow Tips

1. Start new projects with tmuxifier layouts for consistent workspace setup
2. Use sesh for quick session switching and management
3. Leverage vim-tmux-navigator for seamless editor/terminal navigation
4. Use the mouse for quick pane resizing when needed
5. Take advantage of Alt-based shortcuts for frequent operations

## Customization

The main configuration file is located at `$XDG_CONFIG_HOME/tmux/tmux.conf`. Key areas for customization:
- Key bindings
- Theme settings (`@monokai-pro-filter`)
- Plugin selection
- Status bar position and content
- Terminal compatibility settings
