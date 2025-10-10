# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS dotfiles repository that manages development environment configuration across multiple machines (personal and work). It uses GNU Stow for symlink management and supports profile-based installation (home, garda, minimal).

## Installation Commands

### Initial Setup (Bootstrap)
```bash
# Default installation (minimal profile)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/dhavalsavalia/dotfiles/main/bootstrap.sh)"

# With specific profile and branch
DOTFILES_BRANCH=main DOTFILES_PROFILE=home /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/dhavalsavalia/dotfiles/main/bootstrap.sh)"

# Direct install from cloned repo
./scripts/install.sh -p home -n "Your Name" -e "your@email.com"
./scripts/install.sh -p home -d  # Dry run
./scripts/install.sh -p home -m  # Include macOS defaults
./scripts/install.sh -p home -g  # Skip git configuration
```

### Homebrew Package Management
```bash
# Manually run brew setup for a profile
./scripts/brew.sh -p home
./scripts/brew.sh -p garda
./scripts/brew.sh -p minimal

# Dry run mode
./scripts/brew.sh -p home -d

# Sync ad-hoc installs to Brewfile (interactive with gum)
./scripts/brew-capture.sh
brew-sync  # alias

# Check for out-of-sync casks (manually updated outside brew)
./scripts/brew-check-sync.sh                # Report only
./scripts/brew-check-sync.sh --interactive  # Fix with gum selection
./scripts/brew-check-sync.sh --auto-fix     # Reinstall all
brew-fix-sync  # alias for --interactive
brew-fix-all   # alias for --auto-fix
```

### Stow Symlink Management
```bash
# Stow all default packages
./scripts/stow.sh

# Stow specific packages
./scripts/stow.sh zsh git tmux

# Test stow setup
source scripts/utils.sh && test_stow
```

## Architecture

### Profile System
The repository supports three profiles that determine which packages get installed:

- **minimal**: Basic command-line tools only (uses `Brewfile.macos.minimal`)
- **home**: Personal setup (combines `Brewfile.macos.common` + `Brewfile.macos.home`)
- **garda**: Work setup (combines `Brewfile.macos.common` + `Brewfile.macos.garda`)

Profile is stored in `~/.config/.brewprofile` after first installation.

### Brewfile Structure
Located in `homebrew/`:
- `Brewfile.macos.common`: Shared packages for home and garda profiles
- `Brewfile.macos.home`: Personal-only packages
- `Brewfile.macos.garda`: Work-only packages
- `Brewfile.macos.minimal`: Minimal installation packages
- `Brewfile.combined`: Generated at runtime by concatenating relevant files

### Stow Package Organization
Each top-level directory (except `scripts`, `homebrew`, `docs`) is a stow package:
- `zsh/`: Shell configuration with conf.d structure
- `tmux/`: Tmux config and layouts (tmuxifier)
- `git/`: Git config with gitconfig.d includes
- `nvim/`, `lvim/`: Editor configurations
- `alacritty/`: Terminal emulator config
- `aerospace/`: Window manager configuration
- `starship/`: Prompt configuration
- `lazygit/`: Git TUI configuration
- `fzf-git.sh/`: FZF git integration
- `ripgrep/`: Search tool config
- `local_scripts/`: Custom scripts
- `linearmouse/`: Mouse configuration

Stow creates symlinks from `~/dotfiles/{package}/.config/*` to `~/.config/*`.

### Installation Flow (install.sh)
1. Validates profile and git configuration
2. Optionally runs macOS defaults (scripts/macos.sh)
3. Installs/updates Homebrew packages (scripts/brew.sh)
4. Creates symlinks with GNU Stow (scripts/stow.sh)
5. Tests stow setup (verifies ~/.zshenv is symlinked)
6. Configures git user (scripts/git.sh)
7. Installs LunarVim (scripts/lunarvim.sh)
8. Sets up tmux and tmuxifier (scripts/tmux.sh)
9. Configures AeroSpace (scripts/aerospace.sh)

### Utility Functions (scripts/utils.sh)
Provides shared functionality across all scripts:
- `log()`, `warn()`, `error()`: Colored output
- `execute()`: Runs commands with dry-run support (honors $DRY_RUN)
- `command_exists()`: Checks if command is available
- `test_stow()`: Validates stow symlinks
- `$DOTFILES_DIR`: Environment variable pointing to repo root

### Git Configuration Strategy
Git config uses includes in `.config/git/config`:
- `user.conf`: Created by install script with name/email
- Other configs are stowed from `git/.config/git/gitconfig.d/`
- Precedence: existing user.conf → provided flags → prompt → defaults

## Environment Variables

- `DOTFILES_DIR`: Set to repo root by all scripts
- `DOTFILES_PROFILE`: Profile selection (home/garda/minimal)
- `DOTFILES_BRANCH`: Git branch for bootstrap (default: main)
- `DOTFILES_MACOS_DEFAULTS`: Whether to apply macOS settings (default: true)
- `DOTFILES_NO_GIT`: Skip git configuration (default: false)
- `DRY_RUN`: Preview commands without executing (set to "true")
- `PROVIDED_GITAUTHORNAME`: Override git name
- `PROVIDED_GITAUTHOREMAIL`: Override git email

## Key Files

- `bootstrap.sh`: Entry point for remote installation
- `scripts/install.sh`: Main orchestration script with argument parsing
- `scripts/utils.sh`: Shared utility functions
- `scripts/brew.sh`: Homebrew and package management
- `scripts/stow.sh`: GNU Stow symlink creation
- `.stow-local-ignore`: Files to exclude from stowing

## Configured Tools

- **Shell**: Zsh with zoxide, eza, starship prompt
- **Terminal**: Alacritty
- **Multiplexers**: Tmux (primary) + Zellij (trial/evaluation)
- **Editors**: LunarVim, Neovim
- **Git**: Lazygit TUI, custom aliases
- **Window Manager**: AeroSpace (i3-like tiling)
- **Color Theme**: Monokai Pro (Spectrum Filter) - Cohesive across all tools
- **Fonts**: JetBrainsMono Nerd Font, VictorMono Nerd Font (cursive)

## Testing and Maintenance

The repository includes dry-run mode for safe testing:
```bash
DRY_RUN=true ./scripts/install.sh -p home
```

Homebrew maintenance is automated during setup:
- `brew update`: Updates package definitions
- `brew bundle`: Installs from Brewfile
- `brew bundle cleanup --force`: Removes unlisted packages
- `brew upgrade`: Upgrades all packages
- `brew cleanup`: Removes old versions

## Project Status

### Current State
**Stable and actively maintained.** Core functionality works reliably across personal (home) and work (garda) machines. Scripts are idempotent and tested with dry-run support.

**Recent improvements:**
- Fixed critical script errors (syntax, stow --adopt, git remote checks)
- Added Zellij as modern terminal workspace alternative
- Improved session naming and workflow ergonomics

### Active Decisions & Rationale

**Multiplexer Strategy (Tmux + Zellij)**
- **Decision**: Run both in parallel, Tmux as primary
- **Why**: Zellij offers consolidation potential (built-in file picker, session manager) but ecosystem is immature. Evaluate gradually rather than force migration.
- **Status**: Zellij configured with Monokai Pro theme, optimized keybinds (`Alt+` prefix), auto-naming wrapper (`z`/`zj`). See `docs/zellij.md`.

**Tool Consolidation Philosophy**
- **Preference**: Native features over plugins where UX is comparable
- **Example**: Zellij's built-in file picker vs fzf, native session manager vs sesh
- **Balance**: Don't sacrifice workflow quality for minimalism. Keep tools that work exceptionally (lazygit, starship, zoxide).

**Configuration Approach**
- **Liberal with trials**: Easy to add new tools for evaluation (Zellij example)
- **Conservative with removal**: Keep tmux despite Zellij trial - workflows are valuable
- **Cohesion priority**: Monokai Pro theme consistency across all tools matters

**Script Quality Standards**
- Idempotent operations (safe to run multiple times)
- Dry-run support (`DRY_RUN=true`)
- Meaningful error messages
- No silent failures on critical paths

### Known Issues & Workarounds

**Script Limitations:**
- `test.sh` only validates home/garda profiles (minimal untested)
- macOS defaults have some non-functional settings (documented in comments)
- `brew doctor` disabled on macOS Sequoia (known Homebrew issue)

**Tool Gaps:**
- No auto-restore for Zellij sessions (unlike tmux-continuum)
- Zellij lacks "last session" toggle (use tab toggle instead)
- Neovim in Zellij requires Lock mode (`Ctrl+g`) to avoid key conflicts

## Roadmap

### Short-term (Next Session)
- Evaluate Zellij in daily workflow (2-4 weeks trial)
- Decide: full migration, hybrid approach, or stay with tmux
- If keeping Zellij: add zjstatus plugin for enhanced status bar

### Medium-term (Future)
- Complete git setup (SSH keys, GPG signing) - see README TODO
- Add ranger/file manager if Zellij file picker insufficient
- Resolve remaining macOS defaults issues
- Per-app stowing capability (selective package installation)

### Long-term (Optional)
- Neofetch or system info display
- Corne keyboard configuration verification
- Consider replacing additional tools with Zellij plugins if ecosystem matures

### Deferred/Canceled
- Removing tmux (too valuable, works perfectly)
- Aggressive package consolidation (quality > quantity)

## Notes for Claude Code

- Do not create random-ass long markdowns willy-nilly.
- Be smart with your output tokens, save and use for better thinking or task execution.
- Short is better, complex and too-verbose is bad.
- User values: Liberal experimentation + Conservative removal + Cohesive aesthetics.