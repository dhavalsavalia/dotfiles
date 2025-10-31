# Quick Deployment Commands

## 📋 Commit Your Changes (Run on Home Laptop)

```bash
cd ~/dotfiles

# Add all new nvim config files
git add dot_config/nvim/
git add run_once_before_install-nvim-dependencies.sh.tmpl
git add WORKFLOW_ANALYSIS.md
git add GARDA_DEPLOYMENT.md
git add DEPLOYMENT_COMMANDS.md

# Commit
git commit -m "feat: add nvim configuration with kickstart.nvim

- Add complete nvim config with LSPs for TypeScript, Python, Docker, YAML
- Add Harpoon for quick file navigation
- Add GitHub Copilot integration
- Add vim-dadbod for database management
- Add vim-tmux-navigator for seamless navigation
- Add buffer management keybindings
- Fix Telescope layout errors
- Add comprehensive documentation and deployment guides
- Profile-independent config works on both home and garda"

# Push to GitHub
git push origin migrate-to-chezmoi

# Or if you want to merge to main first:
git checkout main
git merge migrate-to-chezmoi
git push origin main
```

---

## 🚀 Deploy to Work Laptop (Garda)

### Prerequisites

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install chezmoi
brew install chezmoi
```

### One-Command Deployment

```bash
# Replace with your actual repo URL
chezmoi init --apply https://github.com/dhavalsavalia/dotfiles.git
```

**You'll be prompted:**
1. Profile: `garda`
2. Git name: `Your Work Name`
3. Git email: `your.work@company.com`

That's it! Everything will be configured automatically.

---

## 🔍 Post-Deployment Verification

```bash
# Quick health check
cat ~/.config/.chezmoi.toml        # Should show profile = "garda"
git config user.email               # Should be work email
nvim --version                      # Should be 0.10+
nvim                                # Should auto-install plugins

# In nvim:
:checkhealth                        # Check everything
:Copilot setup                      # Authenticate (if using at work)
:Mason                              # Check LSP servers

# Test buffer management
<leader>sf                          # Search files
<leader><leader>                    # Search buffers
Tab / Shift+Tab                     # Cycle buffers
<leader>a                           # Mark with Harpoon
<leader>1                           # Jump to marked file
```

---

## 🔄 Keeping Machines in Sync

### Update from GitHub

```bash
# On either machine
chezmoi update

# Or manually:
cd ~/.local/share/chezmoi
git pull
chezmoi apply
```

### Make Changes and Push

```bash
# Edit in chezmoi source
cd ~/.local/share/chezmoi
nvim dot_config/nvim/init.lua

# Apply and test locally
chezmoi apply
nvim  # Test it works

# Commit and push
git add .
git commit -m "feat: add new plugin"
git push
```

---

## 🎯 Most Important Commands

### On Work Laptop (First Time)
```bash
chezmoi init --apply https://github.com/dhavalsavalia/dotfiles.git
```

### Daily Usage (Both Machines)
```bash
chezmoi update                # Pull latest from GitHub
chezmoi edit ~/.zshrc         # Edit a config file
chezmoi apply                 # Apply changes
cd ~/.local/share/chezmoi     # Go to source dir
```

### Nvim Buffer Management
```bash
<leader><leader>              # See all buffers (best way!)
Tab / Shift+Tab               # Cycle buffers
<leader>bd                    # Delete buffer
<leader>a                     # Mark with Harpoon
<leader>1-4                   # Jump to marked files
```

---

## 📚 Reference Docs

- **Full guide**: `~/.config/nvim/README.md`
- **Quick reference**: `~/.config/nvim/QUICK_REFERENCE.md`
- **Deployment details**: `GARDA_DEPLOYMENT.md`
- **Workflow analysis**: `WORKFLOW_ANALYSIS.md`

---

## ⚡ TL;DR

**Commit on home laptop:**
```bash
cd ~/dotfiles
git add .
git commit -m "feat: add nvim config"
git push
```

**Deploy on work laptop:**
```bash
chezmoi init --apply https://github.com/dhavalsavalia/dotfiles.git
# Select: garda, work-name, work-email
```

**Done!** 🎉
