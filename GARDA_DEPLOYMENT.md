# Deploying to Work Laptop (Garda Profile)

## ✅ Pre-Deployment Checklist

Everything is ready! Your config is properly set up for multi-profile deployment.

### What's Already Configured

**1. Profile-Aware Git Configuration** ✅
- Location: `dot_config/git/gitconfig.d/user.conf.tmpl`
- Uses chezmoi data: `{{ .git_name }}` and `{{ .git_email }}`
- Prompts for work credentials on first run
- Home profile has 1Password SSH signing (won't interfere with garda)

**2. Profile-Specific Brewfile** ✅
- Location: `Brewfile.tmpl`
- Home profile: Personal apps (1Password, Obsidian, Discord, Steam, etc.)
- Garda profile: Work apps (JetBrains Toolbox, Keeper, OneDrive)
- Common packages: Shared dev tools (nvim, node, python, docker, etc.)

**3. Nvim Configuration** ✅
- Location: `dot_config/nvim/`
- **Profile-independent** - works on both machines!
- No hardcoded paths or machine-specific settings
- LSPs, themes, plugins all platform/profile agnostic

**4. Chezmoi Templates** ✅
- `.chezmoi.toml.tmpl` - Will prompt for profile/git info
- `run_once_install-packages.sh.tmpl` - Handles Homebrew installation
- `run_once_before_install-nvim-dependencies.sh.tmpl` - Validates nvim setup

---

## 🚀 Deployment Steps for Garda Laptop

### Prerequisites on Work Laptop

```bash
# 1. Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install chezmoi
brew install chezmoi

# 3. Verify git is available (should be pre-installed on macOS)
git --version
```

### Deploy Dotfiles

```bash
# Option A: Fresh deployment from GitHub
chezmoi init https://github.com/dhavalsavalia/dotfiles.git
cd ~/.local/share/chezmoi

# OR Option B: If already cloned
chezmoi init

# Follow the prompts:
# - Profile: garda
# - Git name: Your Work Name
# - Git email: your.work@email.com

# Review changes before applying
chezmoi diff

# Apply the dotfiles
chezmoi apply -v

# Source the new shell config
source ~/.zshenv
exec zsh
```

### What Happens During Deployment

1. **Chezmoi prompts** (`.chezmoi.toml.tmpl`):
   - Profile: `garda`
   - Git name: Your work name
   - Git email: Your work email

2. **Brewfile installation** (`run_once_install-packages.sh.tmpl`):
   - Common packages: neovim, node, python, docker, tmux, etc.
   - Garda-specific: JetBrains Toolbox, Keeper, OneDrive
   - Skips: Home-only packages (1Password, Discord, Steam, etc.)

3. **Nvim setup** (`run_once_before_install-nvim-dependencies.sh.tmpl`):
   - Validates nvim version (0.10+)
   - Checks Node.js (for LSPs & Copilot)
   - Checks Python (for pyright)
   - Creates nvim data directory

4. **Git configuration** (`dot_config/git/gitconfig.d/user.conf.tmpl`):
   - Sets work name/email
   - Skips 1Password SSH signing (garda-specific comment added)
   - Keeps all other git settings (aliases, colors, etc.)

5. **All other configs**:
   - Zsh, tmux, alacritty, aerospace, starship
   - Lazygit, fzf, ripgrep, etc.
   - **Nvim config** (identical to home!)

### Post-Deployment Verification

```bash
# 1. Check profile
cat ~/.config/.chezmoi.toml
# Should show: profile = "garda"

# 2. Verify git config
git config user.name
git config user.email
# Should show your work credentials

# 3. Check Brewfile applications
brew list --cask | grep -E "jetbrains|keeper|onedrive"
# Should show: jetbrains-toolbox, keeper-password-manager, onedrive

brew list --cask | grep -E "1password|discord|steam"
# Should NOT show these (home-only)

# 4. Test nvim
nvim --version
# Should be 0.10+

nvim
# Should auto-install plugins on first launch
# Run: :Tutor, :checkhealth, :Mason

# 5. Test tmux + nvim integration
tmux
nvim .
# Test <C-h/j/k/l> navigation between panes
```

---

## 🔍 Key Differences: Home vs Garda

### Git Configuration

**Home** (`user.conf` when profile=home):
```gitconfig
[user]
  name = Dhaval Savalia
  email = hello@dhavalsavalia.com
  signingkey = ssh-ed25519 AAAA... (1Password key)

[gpg]
  format = ssh

[gpg "ssh"]
  program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
```

**Garda** (`user.conf` when profile=garda):
```gitconfig
[user]
  name = Your Work Name
  email = your.work@company.com
  # Work profile - add your work signing key here if needed
  # signingkey = ssh-ed25519 YOUR_WORK_KEY
```

### Installed Applications

| Category | Home | Garda |
|----------|------|-------|
| **Password Manager** | 1Password | Keeper |
| **IDE** | VS Code only | + JetBrains Toolbox |
| **Cloud Storage** | - | OneDrive |
| **Communication** | Discord, Telegram, WhatsApp | Microsoft Teams |
| **Personal** | Steam, Minecraft, Obsidian | - |
| **Dev Tools** | ✅ Identical | ✅ Identical |

### Dev Tools (Identical on Both)

Both profiles get:
- neovim, node, python, docker
- tmux, zellij, alacritty
- lazygit, gh, git-delta
- fzf, ripgrep, fd, bat, eza
- starship, zoxide, thefuck
- **Same nvim config!**

---

## 🛠️ Work-Specific Customizations

### If You Need Work-Specific Git Signing

Edit on work laptop after deployment:
```bash
# Edit the generated user.conf
nvim ~/.config/git/gitconfig.d/user.conf

# Add your work SSH key
[user]
  signingkey = ssh-ed25519 YOUR_WORK_KEY_HERE

[gpg]
  format = ssh

[commit]
  gpgsign = true
```

### If You Need Work-Specific Environment Variables

Create a work-specific zsh config:
```bash
# Create garda-specific config
nvim ~/.config/zsh/conf.d/90-garda.zsh

# Add work-specific settings
export COMPANY_VAR="value"
export WORK_PROXY="http://proxy:8080"
```

### If You Need Different Nvim Plugins

The nvim config is identical, but you can add work-specific plugins:
```lua
-- In nvim, create a local config (not tracked by chezmoi)
nvim ~/.config/nvim/lua/local.lua

-- Add work-specific plugins
return {
  { 'your-company/internal-plugin' },
}

-- Then in init.lua (after deployment), add:
-- pcall(require, 'local')  -- Load local config if exists
```

---

## 🔄 Keeping Both Machines in Sync

### Making Changes on Either Machine

```bash
# 1. Edit files in chezmoi source
cd ~/.local/share/chezmoi
nvim dot_config/nvim/init.lua

# 2. See what changed
chezmoi diff

# 3. Apply changes
chezmoi apply

# 4. Commit and push
git add .
git commit -m "feat: add new nvim plugin"
git push
```

### Syncing Changes to Other Machine

```bash
# On the other machine
chezmoi update

# Or manually:
cd ~/.local/share/chezmoi
git pull
chezmoi apply
```

### Profile-Specific Changes

If you need to make a change only for one profile:

```lua
-- Example: In a template file
{{- if eq .profile "garda" }}
-- Garda-specific setting
{{- else if eq .profile "home" }}
-- Home-specific setting
{{- end }}
```

---

## 🚨 Common Issues & Solutions

### Issue: Wrong Git Credentials Applied

**Symptom**: Work laptop has personal email or vice versa

**Solution**:
```bash
# Re-initialize chezmoi with correct profile
cd ~/.local/share/chezmoi
chezmoi init --force
# Select correct profile when prompted

# Or manually edit
nvim ~/.config/.chezmoi.toml
# Change profile value

# Re-apply
chezmoi apply --force
```

### Issue: Missing Work-Specific Apps

**Symptom**: JetBrains Toolbox not installed on garda laptop

**Solution**:
```bash
# Check profile
cat ~/.config/.chezmoi.toml

# Should show: profile = "garda"
# If not, see above fix

# Re-run Brewfile installation
cd ~/.local/share/chezmoi
chezmoi apply --force run_once_install-packages.sh.tmpl
```

### Issue: Nvim Plugins Not Installing

**Symptom**: Nvim opens but plugins missing

**Solution**:
```bash
# Check prerequisites
nvim --version  # Should be 0.10+
node --version  # Should be v18+
python3 --version

# Manually trigger plugin installation
nvim
:Lazy sync
:Mason
:checkhealth
```

### Issue: Different Nvim Configs Needed

**Symptom**: Need different LSP settings for work projects

**Solution**:
Use project-local config instead of modifying global:
```bash
# In work project root
nvim .nvimrc.lua

-- Project-specific LSP settings
require('lspconfig').tsserver.setup {
  -- Work-specific settings
}
```

---

## ✅ Final Checklist

After deploying to garda laptop:

- [ ] Profile set to `garda` in `~/.config/.chezmoi.toml`
- [ ] Git user.name and user.email are work credentials
- [ ] JetBrains Toolbox, Keeper, OneDrive installed
- [ ] Personal apps (1Password, Discord, Steam) NOT installed
- [ ] Neovim 0.10+ installed
- [ ] Node.js installed (for Copilot)
- [ ] Python installed (for pyright)
- [ ] First nvim launch completed (plugins auto-installed)
- [ ] `:checkhealth` shows no critical errors
- [ ] `:Copilot setup` completed (if using at work)
- [ ] Tmux + nvim navigation working (`<C-h/j/k/l>`)
- [ ] Can push/pull from dotfiles repo
- [ ] Shell looks good (starship prompt, zoxide, eza)

---

## 🎯 Summary

**What's the same:**
- ✅ Entire nvim config (LSPs, plugins, keybindings, theme)
- ✅ Shell config (zsh, tmux, starship, aliases)
- ✅ Terminal setup (alacritty, aerospace)
- ✅ Git aliases and settings
- ✅ Dev tools (node, python, docker, etc.)

**What's different:**
- ❌ Git user name/email (work vs personal)
- ❌ Git signing key (1Password vs work key)
- ❌ GUI applications (personal vs work-specific)
- ❌ Profile identifier

**The magic:**
Chezmoi templates handle all the differences automatically. You just select the profile during `chezmoi init`!

---

## 🚀 Ready to Deploy!

Your dotfiles are perfectly set up for multi-machine deployment. Just run:

```bash
chezmoi init https://github.com/dhavalsavalia/dotfiles.git
```

Select `garda` profile, enter work credentials, and you're done! 🎉
