# Dotfiles Project

## Description
This repository contains my configuration files and scripts for setting up my development environment.

## Prerequisites

1. Install Command Line Tools:
```bash
# Remove existing Command Line Tools (if outdated)
sudo rm -rf /Library/Developer/CommandLineTools

# Install Command Line Tools
xcode-select --install
```

2. Install Rosetta 2 (required for some packages on Apple Silicon):
```bash
sudo softwareupdate --install-rosetta
```

Note: The installation process will require sudo access at various points. You'll be prompted for your password when needed.

## Setup Instructions
1. Clone the repository:
```bash
git clone https://github.com/dhavalsavalia/dotfiles.git ~/dotfiles
```

2. Run the installation:
```bash
cd ~/dotfiles
./install.sh -p [home|work]
```
