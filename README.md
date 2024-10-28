# Dhaval's dotfiles

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

3. Full Disk Access to Terminal.app

Note: The installation process will require sudo access at various points. You'll be prompted for your password when needed.

## Setup Instructions
1. Clone the repository:
```bash
git clone https://github.com/dhavalsavalia/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Give executable permissions to scripts
```bash
chmod +x scripts/*.sh
```

3. See help and install acordingly
```bash
./scripts/install.sh -h
```

## Known issues

* MacOS defaults script is not working with `install.sh` so it need to be run individually:
```bash
./scripts/macos.sh -p [home|garda]
```

* Some defaults are not behaving properly
* kitty is not opening
* Custom taps are not working for brew.
* Report?

## TODO

* More robust
* Solve issues
* More config
* Checkout [xdg-ninja](https://github.com/b3nj5m1n/xdg-ninja)
