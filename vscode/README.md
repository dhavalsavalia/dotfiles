# VSCode Configuration

Profile-based VSCode settings and extension management for dotfiles.

## Structure

```
vscode/.config/vscode/
├── settings.base.json          # Shared settings (theme, fonts, formatters)
├── settings.home.json          # Personal-specific overrides
├── settings.garda.json         # Work-specific overrides (Jira, Azure, etc.)
├── keybindings.json            # Shared keybindings
├── extensions.base.txt         # Shared extensions (Copilot, Prettier, Python)
├── extensions.home.txt         # Personal extensions (SSH, Pets)
└── extensions.garda.txt        # Work extensions (Docker, Azure, Terraform)
```

## Installation

### Automatic (via main install.sh)
```bash
./scripts/install.sh -p home
```

### Manual
```bash
# Install for specific profile
./scripts/vscode.sh -p home
./scripts/vscode.sh -p garda

# Dry run mode
DRY_RUN=true ./scripts/vscode.sh -p home
```

## How It Works

1. **Settings Merge**: Combines `settings.base.json` + `settings.<profile>.json` using `jq`
2. **Keybindings**: Copies shared `keybindings.json` to VSCode User directory
3. **Extensions**: Brew-style management
   - Shows summary: "Installing X, keeping Y, removing Z"
   - Installs missing extensions
   - Detects untracked extensions (installed manually)
   - Prompts to remove untracked extensions (like `brew bundle cleanup`)

## Managing Extensions

### Add New Extension
```bash
# 1. Install extension in VSCode
# 2. Get extension ID
code --list-extensions | grep <extension-name>

# 3. Add to appropriate file:
# - Shared across all profiles → extensions.base.txt
# - Work only → extensions.garda.txt
# - Personal only → extensions.home.txt

# 4. Re-run script
./scripts/vscode.sh -p <profile>
```

### Update Extensions
Script checks if extension is already installed and skips it. To force update:
```bash
code --install-extension <extension-id> --force
```

### Detect Untracked Extensions
Script automatically detects extensions installed manually (outside of config):
```bash
./scripts/vscode.sh -p home

# Output:
# [WARN] The following extensions are not in your configuration and will be removed:
#   - some.random-extension
# Remove these extensions? (y/N)
```

Add them to appropriate file or remove to keep config clean.

## Settings Split

**Base (Shared)**:
- Theme: Monokai Pro (Filter Spectrum)
- Fonts: JetBrainsMono Nerd Font
- Formatters: Prettier, YAML, Docker
- Editor preferences: word wrap, minimap disabled
- Git settings
- Copilot configuration

**Home Profile**:
- Minimal spell-check dictionary (Dhaval, Savalia)

**Garda Profile**:
- Work-specific spell-check (gardaworld, ASCA, etc.)
- Jira/Atlassian configuration
- Azure settings
- Roo-Cline allowed commands

## Requirements

- VSCode installed with `code` CLI command
- `jq` for JSON merging (installed via Homebrew)
- Profile set in `~/.config/.brewprofile` or via `-p` flag

## Notes

- Settings are merged (profile overrides base), not concatenated
- Keybindings are shared (no profile-specific variants yet)
- Extension installation uses `--force` to update to latest
- "Already installed" messages are suppressed for cleaner output
