# 🚀 Dhaval's Dotfiles

## 📄 Description
This repository contains my configuration files and scripts for setting up my development environment.

## 🛠️ Tools Configured
This script will configure the following tools:

* **Homebrew**: Installs and manages packages through bundle.
* **GNU Stow**: Manages symlinks seamlessly for painless dotfiles setup.
* **Git**: Configures git aliases and settings.
* **Zsh**: Sets up zsh with plugins like zoxide, eza, starship prompt, and its configurations.
* **Alacritty**: Configures the alacritty terminal emulator for a minimal look.
* **Tmux**: Sets up tmux with plugins and themes. Also installs tmuxifier for session management.
* **LunarVim**: Configures the LunarVim editor.
* **Lazygit**: My git client of choice with a beautiful TUI.
* **Sketchybar**: Configures the macOS menu bar.
* **AeroSpace**: Tiling Window Manager. Similar to i3.
* **macOS Defaults**: Sets macOS sane defaults.

## 🎨 Personal Choices

* **Colortheme**: Monokai Pro (Spectrum Filter).
* **Fonts**: JetBrainsMono Nerd Fonts with VictorMono Nerd Fonts for cursive.

## 🛠️ Prerequisites

1. Install Command Line Tools:
```bash
# Remove existing Command Line Tools (if outdated)
sudo rm -rf /Library/Developer/CommandLineTools

# Install Command Line Tools
sudo xcode-select --install
```

Make sure `Apple Clang` version is >16. If not, run above steps again to fix.

```bash
clang --version
```

2. Install Rosetta 2 (required for some packages on Apple Silicon):
```bash
sudo softwareupdate --install-rosetta
```

3. Full Disk Access to Terminal.app

Note: The installation process will require  sudo access at various points. You'll be prompted for your password when needed.

## Setup Instructions
1. Run following command in Terminal:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/dhavalsavalia/dotfiles/main/bootstrap.sh)"
```

> Change `main` to branch name for alternate branch. This is mostly for testing.

## App Specifics

### sketchybar

MacOS Menu Bar is not getting hidden using defaults. Manually Set it to auto hide "Always" from `System Settings` > `Control Center`.

## 🐞 Known issues

* MacOS defaults script is not working with `install.sh` so it need to be run individually:
```bash
./scripts/macos.sh -p [home|garda]
```

* Some defaults are not behaving properly
* ~~kitty is not opening~~ UTM Does not support OpenGL 3.3 drivers, so I can't test kitty on UTM
* ~~Custom taps are not working for brew.~~ Make sure Apple Clang version >16. (As of MacOS 15.1 Seqouia)
* Report?

## 📝 TODO

* Fix double calling functions
* Add neofetch or something
* Add ranger
* make sure everything works on Corne keyboard
