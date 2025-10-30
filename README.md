# Dotfiles (Chezmoi)

Minimal macOS dotfiles managed with [chezmoi](https://chezmoi.io).

## Features

- **Profile-based**: Separate configs for home and work (garda) machines
- **Template-driven**: One Brewfile with conditional sections per profile
- **Simple**: No complex scripts, chezmoi handles everything
- **Fast**: One-command setup on new machines

## Quick Start

### Fresh Machine Setup

```bash
# Install chezmoi and apply dotfiles in one command
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply dhavalsavalia

# Or if you want to review changes first
chezmoi init dhavalsavalia
chezmoi diff
chezmoi apply
```

During init, you'll be prompted for:
- **profile**: `home` or `garda`
- **git name**: Your name for git commits
- **git email**: Your email for git commits

### Existing Machine Update

```bash
# Pull latest changes and apply
chezmoi update

# Or step by step
chezmoi git pull
chezmoi diff
chezmoi apply
```

## What's Included

### Core Tools
- **Shell**: Zsh with starship prompt, zoxide, eza
- **Terminal**: Alacritty
- **Multiplexer**: Zellij (primary), Tmux (legacy)
- **Editor**: Neovim/LunarVim
- **Git**: Lazygit TUI
- **Window Manager**: AeroSpace (i3-like tiling)
- **Theme**: Monokai Pro Spectrum

### Configuration Files
All configs live in `~/.config/`:
- `zsh/` - Shell configuration
- `git/` - Git config with includes
- `alacritty/` - Terminal emulator
- `zellij/` - Terminal workspace
- `nvim/` - Neovim config
- `lazygit/` - Git TUI
- `aerospace/` - Window manager
- `starship.toml` - Shell prompt
- `ripgrep/` - Search config

### Profile-Specific Packages

**Home Profile:**
- 1Password, Enpass, Setapp
- Discord, Telegram, WhatsApp
- Obsidian, Windscribe
- Steam, Minecraft, Codecrafters

**Garda Profile (Work):**
- JetBrains Toolbox
- Keeper Password Manager
- OneDrive

## Common Tasks

### Add New Config File

```bash
# Add file to chezmoi
chezmoi add ~/.config/newapp/config.toml

# Edit in chezmoi
chezmoi edit ~/.config/newapp/config.toml

# Apply changes
chezmoi apply
```

### Make Config Profile-Specific

Add template conditionals:

```toml
{{- if eq .profile "home" }}
# Home-only config
{{- else if eq .profile "garda" }}
# Work-only config
{{- end }}
```

### Update Brewfile

```bash
# Edit Brewfile
chezmoi edit ~/Brewfile

# Apply and install
chezmoi apply
brew bundle --file=~/Brewfile
```

### View Chezmoi State

```bash
chezmoi status              # Show changed files
chezmoi diff                # Show diff of changes
chezmoi managed             # List all managed files
chezmoi doctor              # Check for issues
```

### Reset a File

```bash
# Re-apply from source (discard local changes)
chezmoi apply --force ~/.config/zsh/conf.d/10-aliases.zsh
```

## Directory Structure

```
~/.local/share/chezmoi/     # Chezmoi source directory (git repo)
├── .chezmoi.toml.tmpl      # Config template (prompts for profile/git)
├── Brewfile.tmpl           # Homebrew packages (templated)
├── README.md               # This file
├── dot_config/             # Maps to ~/.config/
│   ├── zsh/
│   ├── git/
│   ├── alacritty/
│   ├── zellij/
│   ├── nvim/
│   └── ...
├── dot_zshenv              # Maps to ~/.zshenv
└── run_once_*.sh           # Setup scripts (run once)
```

## Chezmoi Concepts

- **`dot_`**: Translates to `.` (dot_config → .config)
- **`.tmpl`**: Template file, processed on apply
- **`run_once_`**: Script runs once (tracked in chezmoi state)
- **`run_onchange_`**: Script runs when file changes
- **`private_`**: Sets file to 0600 permissions
- **`executable_`**: Makes file executable

## Migration from Old Dotfiles

This replaces the previous stow-based setup with:
- ✅ Simpler: No custom bash scripts
- ✅ Cleaner: Profile logic in templates, not shell code
- ✅ Faster: One-command bootstrap
- ✅ Safer: Dry-run with `chezmoi diff` before apply

Old complexity:
- 13 bash scripts (~2000 lines)
- Stow + custom profile system
- Multiple Brewfiles to manage

New simplicity:
- Chezmoi handles everything
- One templated Brewfile
- No custom scripts needed

## Troubleshooting

### Chezmoi not applying changes

```bash
chezmoi apply -v    # Verbose output
chezmoi doctor      # Check for issues
```

### Reset everything

```bash
chezmoi purge       # Remove all managed files
chezmoi init --apply dhavalsavalia  # Start fresh
```

### Profile not detected

Check `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    profile = "home"
    git_name = "Your Name"
    git_email = "your@email.com"
```

## Resources

- [Chezmoi Documentation](https://chezmoi.io)
- [Template Syntax](https://chezmoi.io/user-guide/templating/)
- [Best Practices](https://chezmoi.io/user-guide/best-practices/)
