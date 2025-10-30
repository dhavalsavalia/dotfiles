# Migration to Chezmoi

This branch documents the migration from the stow-based dotfiles system to [chezmoi](https://chezmoi.io).

## Why Migrate?

**Old System Complexity:**
- 13 bash scripts (~2000 lines of custom code)
- Manual profile management via `.brewprofile`
- Multiple Brewfiles to manage and concatenate
- Complex brew-capture and sync scripts
- Fragile script dependencies

**New System Simplicity:**
- Zero custom bash scripts (chezmoi handles everything)
- One templated Brewfile with conditional sections
- Built-in diff, update, and state management
- One-command bootstrap: `chezmoi init --apply dhavalsavalia`
- Industry-standard tool with great docs

## What's Changed

### Structure
**Old:**
```
~/dotfiles/
├── scripts/          # 13 bash scripts
│   ├── install.sh
│   ├── brew.sh
│   ├── brew-capture.sh
│   ├── brew-check-sync.sh
│   └── ...
├── homebrew/
│   ├── Brewfile.macos.common
│   ├── Brewfile.macos.home
│   └── Brewfile.macos.garda
└── {package}/.config/{package}/  # Stow packages
```

**New:**
```
~/.local/share/chezmoi/  # Git repo
├── .chezmoi.toml.tmpl    # Profile/git config
├── Brewfile.tmpl         # Single templated Brewfile
├── README.md             # Complete documentation
├── dot_config/           # Maps to ~/.config/
│   ├── zsh/
│   ├── git/
│   ├── alacritty/
│   └── ...
└── run_once_*.sh         # Auto-run setup scripts
```

### Workflow

**Old Install:**
```bash
git clone https://github.com/dhavalsavalia/dotfiles
cd dotfiles
./scripts/install.sh -p home -n "Name" -e "email@example.com"
```

**New Install:**
```bash
chezmoi init --apply dhavalsavalia
# Prompts for profile/name/email, then applies everything
```

**Old Update:**
```bash
cd ~/dotfiles
git pull
./scripts/brew.sh -p home
./scripts/stow.sh
```

**New Update:**
```bash
chezmoi update  # Pull + apply in one command
```

### Profile System

**Old:** Shell script reads `~/.config/.brewprofile`, concatenates Brewfiles
**New:** Chezmoi template conditionals:

```toml
{{- if eq .profile "home" }}
cask "1password"
{{- else if eq .profile "garda" }}
cask "keeper-password-manager"
{{- end }}
```

## Migration Steps

### 1. Install Chezmoi

```bash
brew install chezmoi
```

### 2. Initialize from New Repo

```bash
# This will prompt for profile (home/garda), name, email
chezmoi init dhavalsavalia

# Review what will change
chezmoi diff

# Apply when ready
chezmoi apply
```

### 3. Verify Setup

```bash
# Check managed files
chezmoi managed

# Verify profile
cat ~/.config/chezmoi/chezmoi.toml

# Install packages
brew bundle --file=~/Brewfile
```

### 4. Remove Old Dotfiles (Optional)

```bash
# Backup first!
mv ~/dotfiles ~/dotfiles.old

# Chezmoi is now managing everything from ~/.local/share/chezmoi
```

## What's Included

**Essential Configs (Migrated):**
- ✅ Zsh with conf.d structure
- ✅ Git with gitconfig.d includes
- ✅ Alacritty terminal
- ✅ Zellij multiplexer
- ✅ Neovim (as reference, manage separately)
- ✅ Lazygit
- ✅ AeroSpace window manager
- ✅ Starship prompt
- ✅ Ripgrep config

**Not Migrated (Add as Needed):**
- Tmux config (migrating to Zellij)
- LunarVim setup
- Tmuxifier layouts
- VSCode settings script
- fzf-git.sh
- linearmouse config

## Common Tasks

### Add New Config

```bash
chezmoi add ~/.config/newapp/config.toml
chezmoi cd
git add .
git commit -m "Add newapp config"
git push
```

### Edit Existing Config

```bash
chezmoi edit ~/.config/zsh/conf.d/10-aliases.zsh
# Opens in $EDITOR, auto-tracked in git
```

### Make Config Profile-Specific

```bash
chezmoi edit ~/.config/someapp/config.toml
# Add template syntax:
{{- if eq .profile "home" }}
setting = "home-value"
{{- else }}
setting = "work-value"
{{- end }}
```

### Update on All Machines

```bash
# On machine 1: make changes
chezmoi edit ~/.zshrc
chezmoi cd && git push

# On machine 2: pull changes
chezmoi update
```

## Rollback Plan

If you need to revert to the old system:

```bash
# 1. Remove chezmoi
chezmoi purge  # Removes managed files

# 2. Restore old dotfiles
cd ~/dotfiles.old
git checkout main
./scripts/install.sh -p home
```

## Resources

- [Chezmoi Documentation](https://chezmoi.io)
- [Chezmoi GitHub](https://github.com/twpayne/chezmoi)
- [Template Reference](https://chezmoi.io/user-guide/templating/)
- [Best Practices](https://chezmoi.io/user-guide/best-practices/)

## Notes

- The old `~/dotfiles` repo remains intact on the `main` branch
- This migration is on the `migrate-to-chezmoi` branch
- New chezmoi setup lives at `~/.local/share/chezmoi` (separate git repo)
- All old scripts and configs are preserved for reference
- You can run both systems in parallel during testing

## Questions?

Check the README in the new chezmoi repo:
```bash
chezmoi cd
cat README.md
```
