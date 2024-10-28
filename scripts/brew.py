#!/usr/bin/env python3

import os
from pathlib import Path
from utils import log, run_command, is_command_available

class BrewManager:
    def __init__(self, dotfiles_path: str, profile: str, dry_run: bool = False):
        self.dotfiles_path = Path(dotfiles_path).expanduser()
        self.profile = profile
        self.dry_run = dry_run
        self.brew_dir = self.dotfiles_path / '.data' / 'homebrew'

    def install_homebrew(self) -> None:
        """Install Homebrew if not already installed."""
        if is_command_available('brew'):
            log("Homebrew is already installed")
            return

        log("Installing Homebrew...")
        install_script = '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        run_command(install_script, self.dry_run, shell=True)

        # Add Homebrew to PATH for Apple Silicon
        if os.path.exists('/opt/homebrew/bin/brew'):
            run_command('eval "$(/opt/homebrew/bin/brew shellenv)"',
                       self.dry_run, shell=True)

    def generate_combined_brewfile(self) -> Path:
        """Generate combined Brewfile from common and profile-specific files."""
        common_file = self.brew_dir / 'Brewfile.macos.common'
        profile_file = self.brew_dir / f'Brewfile.macos.{self.profile}'
        combined_file = self.brew_dir / 'Brewfile.combined'

        if not common_file.exists() or not profile_file.exists():
            log(f"Missing Brewfile(s): {common_file} or {profile_file}", "error")
            return None

        with combined_file.open('w') as outfile:
            for file in [common_file, profile_file]:
                outfile.write(f"\n# Including {file.name}\n")
                outfile.write(file.read_text())

        return combined_file

    def install_packages(self) -> None:
        """Install packages from combined Brewfile."""
        combined_file = self.generate_combined_brewfile()
        if not combined_file:
            return

        log(f"Installing Homebrew packages for profile: {self.profile}")
        run_command(f"brew bundle --file={combined_file}", self.dry_run)

    def cleanup(self) -> None:
        """Clean up unused packages."""
        combined_file = self.generate_combined_brewfile()
        if not combined_file:
            return

        log("Cleaning up unused Homebrew packages...")
        run_command(f"brew bundle cleanup --file={combined_file}", self.dry_run)

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Manage Homebrew packages")
    parser.add_argument("--profile", choices=["home", "garda"], required=True,
                       help="Profile to use (home or garda)")
    parser.add_argument("--dry-run", action="store_true",
                       help="Show what would be done without making changes")
    args = parser.parse_args()

    brew_manager = BrewManager("~/dotfiles", args.profile, args.dry_run)
    brew_manager.install_homebrew()
    brew_manager.install_packages()
    brew_manager.cleanup()
