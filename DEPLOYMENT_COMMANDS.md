# Quick Deployment Commands

## 🚀 Fresh Installation (Easiest Method)

On a **completely fresh Mac**, run this **ONE command**:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/dhavalsavalia/dotfiles/main/bootstrap.sh)
```

This will:
1. ✅ Install Homebrew
2. ✅ Install chezmoi
3. ✅ Clone your dotfiles
4. ✅ Prompt for profile (home/garda)
5. ✅ Prompt for git credentials
6. ✅ Install ALL packages (neovim, node, python, etc.)
7. ✅ Configure everything automatically

**Total time**: ~10-15 minutes (mostly Homebrew installing packages)

---

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

### Method 1: Bootstrap (Recommended for Fresh Machines)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/dhavalsavalia/dotfiles/main/bootstrap.sh)
```

**When prompted:**
1. Profile: `garda`
2. Git name: `Your Work Name`
3. Git email: `your.work@company.com`

### Method 2: Manual (If Homebrew Already Installed)

```bash
# Install chezmoi
brew install chezmoi

# Deploy dotfiles
chezmoi init --apply https://github.com/dhavalsavalia/dotfiles.git
```

**Note**: Method 1 (bootstrap) handles everything including Homebrew installation.

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

**Deploy on fresh machine (work laptop or new Mac):**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/dhavalsavalia/dotfiles/main/bootstrap.sh)
# Select: garda (or home), work-name, work-email
```

**Done!** 🎉

---

## 🔄 Script Execution Order

When you run bootstrap or `chezmoi init --apply`, this happens:

1. **Bootstrap installs prerequisites** (Homebrew, chezmoi, git)
2. **Chezmoi clones dotfiles** from GitHub
3. **Chezmoi prompts for data** (profile, git name/email)
4. **run_once_install-packages.sh** runs - Installs ALL Homebrew packages
5. **Chezmoi applies dotfiles** - Symlinks configs to ~/.config/
6. **run_once_after_install-nvim-dependencies.sh** runs - Validates nvim setup
7. **Done!** Shell is configured, nvim is ready

**Key point**: Packages (neovim, node, python) are installed in step 4, BEFORE the nvim dependency check in step 6. This ensures everything is available when needed.
