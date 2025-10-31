# Dotfiles

macOS development environment managed with [chezmoi](https://chezmoi.io/).

## 🚀 Quick Start (Fresh Mac)

Run this **one command** on a completely fresh Mac:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/dhavalsavalia/dotfiles/main/bootstrap.sh)
```

**When prompted:**
- Profile: `home` (personal) or `garda` (work)
- Git name: Your full name
- Git email: Your email

**That's it!** Everything will be installed and configured automatically.

---

## 📦 What's Included

### Core Tools
- **Shell**: Zsh with starship prompt, zoxide, eza, fzf
- **Terminal**: Alacritty
- **Multiplexers**: Tmux (primary) + Zellij (trial)
- **Editor**: Neovim with kickstart.nvim
  - LSPs: TypeScript, Python, Docker, YAML, JSON, HTML, CSS, Bash, Lua
  - GitHub Copilot integration
  - Harpoon for quick file navigation
  - vim-dadbod for database management
  - Buffer management: Tab/Shift+Tab, Telescope fuzzy finder
- **Window Manager**: AeroSpace (i3-like tiling)
- **Version Control**: Git with extensive aliases, Lazygit TUI
- **Theme**: Monokai Pro (Spectrum filter) everywhere

### Development Tools
- **Languages**: Node.js, Python, Bun
- **Containers**: Docker Desktop
- **Databases**: MongoDB Compass, PostgreSQL (via brew)
- **Package Managers**: Homebrew, npm, pip, pipenv, poetry, pyenv
- **CLI Tools**: ripgrep, fd, bat, git-delta, lazydocker, tldr, thefuck
- **Cloud**: Azure Functions Core Tools

### Profile-Specific Apps

**Home Profile:**
- 1Password, Discord, Telegram, WhatsApp
- Obsidian, Steam, Minecraft
- Windscribe VPN

**Garda Profile (Work):**
- JetBrains Toolbox
- Keeper Password Manager
- OneDrive

---

## 📚 Documentation

- **[DEPLOYMENT_COMMANDS.md](DEPLOYMENT_COMMANDS.md)** - Quick reference for deployment
- **[GARDA_DEPLOYMENT.md](GARDA_DEPLOYMENT.md)** - Detailed deployment guide for work laptop
- **[WORKFLOW_ANALYSIS.md](WORKFLOW_ANALYSIS.md)** - Keyboard & workflow optimization analysis
- **[~/.config/nvim/README.md](dot_config/nvim/README.md)** - Complete Neovim guide
- **[~/.config/nvim/QUICK_REFERENCE.md](dot_config/nvim/QUICK_REFERENCE.md)** - Nvim cheat sheet

---

## 🔧 Usage

### First Time Setup (Already Done via Bootstrap)

```bash
# Bootstrap handles everything, but if you need to do it manually:
brew install chezmoi
chezmoi init --apply https://github.com/dhavalsavalia/dotfiles.git
```

### Daily Usage

```bash
# Update from GitHub
chezmoi update

# Edit a config file
chezmoi edit ~/.zshrc

# Apply changes
chezmoi apply

# Go to source directory
cd ~/.local/share/chezmoi
```

### Making Changes

```bash
# Edit in chezmoi source
cd ~/.local/share/chezmoi
nvim dot_config/nvim/init.lua

# Apply locally
chezmoi apply

# Commit and push
git add .
git commit -m "feat: add plugin"
git push
```

---

## 🎯 Key Features

### Nvim Buffer Management
```vim
<leader><leader>    " Fuzzy search buffers (best!)
Tab / Shift+Tab     " Cycle buffers like browser tabs
<leader>bd          " Delete buffer
<leader>a           " Mark file with Harpoon
<leader>1-4         " Jump to Harpoon marked files
```

### Tmux Session Management
```bash
Alt+t               # New tmux window
Alt+n / Alt+p       # Next/previous window
Alt+1-9             # Jump to window 1-9
Alt+s               # Session switcher
<C-h/j/k/l>         # Navigate panes (works in nvim too!)
```

### Shell Shortcuts
```bash
# Navigation
z <dir>             # Jump to directory (zoxide)
..                  # cd ..
...                 # cd ../..

# Git
lg                  # lazygit TUI
gst                 # git status

# Quick edits
v <file>            # nvim (alias)
c                   # clear
```

---

## 🏗️ Architecture

### Profile System
- **minimal**: Basic CLI tools only
- **home**: Personal setup (gaming, personal apps)
- **garda**: Work setup (JetBrains, work tools)

Profile is stored in `~/.config/.chezmoi.toml` after first installation.

### Chezmoi Templates
- `.chezmoi.toml.tmpl` - Profile and git configuration prompts
- `Brewfile.tmpl` - Profile-specific package installation
- `dot_config/git/gitconfig.d/user.conf.tmpl` - Git credentials per profile
- `run_once_install-packages.sh.tmpl` - Package installation script
- `run_once_after_install-nvim-dependencies.sh.tmpl` - Nvim validation

### Execution Order
1. Bootstrap installs Homebrew, chezmoi, git
2. Chezmoi clones dotfiles and prompts for data
3. `run_once_install-packages.sh` - Installs all packages
4. Chezmoi applies all dotfiles to `~/.config/`
5. `run_once_after_install-nvim-dependencies.sh` - Validates nvim setup

---

## 🐛 Troubleshooting

### Neovim Issues
```vim
:checkhealth           " Check all systems
:Lazy sync             " Update plugins
:Mason                 " Check LSP servers
:Copilot setup         " Authenticate GitHub Copilot
```

### Chezmoi Issues
```bash
# Re-apply dotfiles
chezmoi apply --force

# Check what would change
chezmoi diff

# Update from GitHub
chezmoi update

# Reset to GitHub state
cd ~/.local/share/chezmoi
git reset --hard origin/main
chezmoi apply --force
```

### Package Issues
```bash
# Update Homebrew packages
brew update && brew upgrade

# Reinstall a package
brew reinstall neovim

# Check Brewfile sync
cd ~/.local/share/chezmoi
cat Brewfile.tmpl
```

---

## 🤝 Contributing

This is a personal dotfiles repository, but feel free to:
- Fork it for your own use
- Open issues for bugs
- Submit PRs for improvements

---

## 📜 License

MIT - Use it however you want!

---

## 🙏 Credits

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - Neovim configuration
- [chezmoi](https://chezmoi.io/) - Dotfiles management
- [Monokai Pro](https://monokai.pro/) - Color scheme
- [ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon) - File navigation
- [SixArm/gitconfig](https://github.com/SixArm/gitconfig-settings) - Git aliases

---

**Questions?** Check the [documentation](DEPLOYMENT_COMMANDS.md) or [open an issue](https://github.com/dhavalsavalia/dotfiles/issues).
