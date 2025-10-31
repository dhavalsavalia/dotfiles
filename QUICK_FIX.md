# Quick Fix for Already-Deployed Machines

## Problem: Neovim is Old Version

If you already ran `chezmoi init --apply` and neovim is still old (< 0.10), the issue is that `brew bundle` doesn't upgrade existing packages.

### Fix on Current Machine

```bash
# Update and upgrade all packages
brew update
brew upgrade

# Specifically upgrade neovim
brew upgrade neovim

# Verify version
nvim --version
# Should show NVIM v0.10.x or higher

# If still old, force reinstall
brew uninstall neovim
brew install neovim
nvim --version
```

### After Fixing

```bash
# Test nvim
nvim

# In nvim, run:
:checkhealth
:Mason           # Check LSP servers
:Lazy sync       # Update plugins
```

---

## Problem: Other Packages Are Old

```bash
# Update Homebrew
brew update

# Upgrade all packages
brew upgrade

# Clean up old versions
brew cleanup
```

---

## For Future Deployments

The scripts have been fixed! Next time you run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/dhavalsavalia/dotfiles/main/bootstrap.sh)
```

Or:

```bash
chezmoi init --apply https://github.com/dhavalsavalia/dotfiles.git
```

The installation script will now:
1. Run `brew update` before installing
2. Run `brew upgrade` after installing
3. Auto-upgrade neovim if it's too old

No more manual fixing needed! 🎉

---

## Update Existing Machine to Latest Config

If you want to pull the latest fixes on your current machine:

```bash
# Update from GitHub
chezmoi update

# Or manually:
cd ~/.local/share/chezmoi
git pull
chezmoi apply

# Then upgrade packages
brew update
brew upgrade
```

---

## Test Everything

```bash
# Check versions
nvim --version      # Should be 0.10+
node --version      # Should be v23+
python3 --version   # Should be 3.12+

# Check nvim
nvim
:checkhealth        # Should all pass
:Tutor              # Learn vim (optional)

# Check git
git config user.name
git config user.email

# Check shell
echo $SHELL         # Should be /bin/zsh
which starship      # Should find it
```

---

## Complete Reset (Nuclear Option)

If things are really messed up and you want to start fresh:

```bash
# 1. Remove chezmoi and configs
rm -rf ~/.local/share/chezmoi
rm -rf ~/.config/nvim
rm -rf ~/.config/zsh
# ... (or just backup and remove ~/.config/*)

# 2. Upgrade all brew packages
brew update
brew upgrade

# 3. Re-deploy with fixed scripts
bash <(curl -fsSL https://raw.githubusercontent.com/dhavalsavalia/dotfiles/main/bootstrap.sh)
```

This will give you a completely fresh deployment with all the latest versions.
