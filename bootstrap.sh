#!/usr/bin/env bash
# Bootstrap script for fresh macOS installations
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/dhavalsavalia/dotfiles/main/bootstrap.sh | bash
#   or
#   bash <(curl -fsSL https://raw.githubusercontent.com/dhavalsavalia/dotfiles/main/bootstrap.sh)

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[bootstrap]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[bootstrap]${NC} $1"
}

error() {
    echo -e "${RED}[bootstrap]${NC} $1"
}

info() {
    echo -e "${BLUE}[bootstrap]${NC} $1"
}

# Banner
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║         Dotfiles Bootstrap - Fresh Installation           ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    error "This script is designed for macOS only"
    exit 1
fi

log "Starting bootstrap process..."

# Step 1: Install Homebrew
if ! command -v brew &> /dev/null; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
    fi

    log "Homebrew installed successfully!"
else
    log "Homebrew is already installed"
    brew --version
fi

# Step 2: Update Homebrew
log "Updating Homebrew..."
brew update

# Step 3: Install chezmoi
if ! command -v chezmoi &> /dev/null; then
    log "Installing chezmoi..."
    brew install chezmoi
    log "chezmoi installed successfully!"
else
    log "chezmoi is already installed"
    chezmoi --version
fi

# Step 4: Install Git (if not present)
if ! command -v git &> /dev/null; then
    log "Installing Git..."
    brew install git
else
    log "Git is already installed"
fi

# Step 5: Get dotfiles repository URL
REPO_URL="${DOTFILES_REPO:-https://github.com/dhavalsavalia/dotfiles.git}"
BRANCH="${DOTFILES_BRANCH:-main}"

log "Using repository: $REPO_URL"
log "Using branch: $BRANCH"

# Step 6: Initialize chezmoi
log "Initializing chezmoi with dotfiles..."
echo ""
info "You will be prompted for:"
info "  1. Profile (home/garda) - Select your machine profile"
info "  2. Git name - Your full name for git commits"
info "  3. Git email - Your email for git commits"
echo ""

# Give user a moment to read
sleep 2

if chezmoi init --apply "$REPO_URL"; then
    log "Dotfiles applied successfully!"
else
    error "Failed to apply dotfiles"
    exit 1
fi

# Step 7: Source the new shell config
log "Reloading shell configuration..."
if [[ -f "$HOME/.zshenv" ]]; then
    source "$HOME/.zshenv"
fi

# Step 8: Summary
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║                  Bootstrap Complete! 🎉                    ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

log "What was installed:"
echo "  ✅ Homebrew"
echo "  ✅ chezmoi"
echo "  ✅ Git"
echo "  ✅ All packages from your Brewfile"
echo "  ✅ Complete development environment"
echo ""

log "What's configured:"
echo "  ✅ Zsh with starship, zoxide, eza, fzf"
echo "  ✅ Tmux with custom config and plugins"
echo "  ✅ Neovim with kickstart.nvim (LSPs, Copilot, Harpoon)"
echo "  ✅ Git with your credentials and aliases"
echo "  ✅ Alacritty, Aerospace window manager"
echo "  ✅ Lazygit, ripgrep, bat, and more dev tools"
echo ""

log "Next steps:"
echo ""
echo "1. Restart your terminal or run: exec zsh"
echo ""
echo "2. Test Neovim:"
echo "   nvim"
echo "   :checkhealth    # Check everything"
echo "   :Copilot setup  # Authenticate with GitHub"
echo "   :Mason          # Check LSP servers"
echo "   :Tutor          # Learn vim basics"
echo ""
echo "3. Read the guides:"
echo "   cat ~/.config/nvim/QUICK_REFERENCE.md"
echo "   cat ~/.config/nvim/README.md"
echo ""
echo "4. Buffer management in nvim:"
echo "   <leader><leader>  # Search buffers"
echo "   Tab/Shift+Tab     # Cycle buffers"
echo "   <leader>sf        # Search files"
echo "   <leader>a         # Mark with Harpoon"
echo ""

info "Enjoy your new development environment! 🚀"
echo ""
