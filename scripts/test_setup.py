#!/usr/bin/env python3

import os
import json
from pathlib import Path
from typing import Dict, List, Set
from utils import log, run_command, is_command_available

class SetupTester:
    def __init__(self, dotfiles_path: str, profile: str):
        self.dotfiles_path = Path(dotfiles_path).expanduser()
        self.profile = profile
        self.brew_dir = self.dotfiles_path / '.data' / 'homebrew'
        self.results = {
            "brew": {"passed": [], "failed": []},
            "cask": {"passed": [], "failed": []},
            "tap": {"passed": [], "failed": []}
        }

    def parse_brewfile(self, file_path: Path) -> Dict[str, Set[str]]:
        """Parse Brewfile and extract taps, brews, and casks."""
        packages = {
            "tap": set(),
            "brew": set(),
            "cask": set()
        }

        with open(file_path) as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#'):
                    parts = line.split()
                    if parts[0] in packages:
                        # Remove quotes if present
                        package = parts[1].strip('"\'')
                        packages[parts[0]].add(package)

        return packages

    def get_expected_packages(self) -> Dict[str, Set[str]]:
        """Get combined list of expected packages from Brewfiles."""
        common_file = self.brew_dir / 'Brewfile.macos.common'
        profile_file = self.brew_dir / f'Brewfile.macos.{self.profile}'

        common_packages = self.parse_brewfile(common_file)
        profile_packages = self.parse_brewfile(profile_file)

        return {
            "tap": common_packages["tap"] | profile_packages["tap"],
            "brew": common_packages["brew"] | profile_packages["brew"],
            "cask": common_packages["cask"] | profile_packages["cask"]
        }

    def test_brew_packages(self) -> None:
        """Test if all specified packages are installed."""
        if not is_command_available('brew'):
            log("Homebrew is not installed!", "error")
            return

        expected = self.get_expected_packages()

        # Test taps
        installed_taps = set(run_command("brew tap").split('\n'))
        for tap in expected["tap"]:
            if tap in installed_taps:
                self.results["tap"]["passed"].append(tap)
            else:
                self.results["tap"]["failed"].append(tap)

        # Test formulae
        for formula in expected["brew"]:
            if run_command(f"brew list --formula | grep -q '^{formula}$'", shell=True, check=False) == 0:
                self.results["brew"]["passed"].append(formula)
            else:
                self.results["brew"]["failed"].append(formula)

        # Test casks
        for cask in expected["cask"]:
            if run_command(f"brew list --cask | grep -q '^{cask}$'", shell=True, check=False) == 0:
                self.results["cask"]["passed"].append(cask)
            else:
                self.results["cask"]["failed"].append(cask)

    def print_results(self) -> None:
        """Print test results in a formatted way."""
        total_failed = sum(len(v["failed"]) for v in self.results.values())

        print("\n=== Test Results ===")

        for category in ["tap", "brew", "cask"]:
            if self.results[category]["passed"] or self.results[category]["failed"]:
                print(f"\n{category.upper()} Packages:")
                print("✅ Passed:")
                for pkg in sorted(self.results[category]["passed"]):
                    print(f"  - {pkg}")

                if self.results[category]["failed"]:
                    print("❌ Failed:")
                    for pkg in sorted(self.results[category]["failed"]):
                        print(f"  - {pkg}")

        print(f"\nTotal: {total_failed} failures found.")

        if total_failed > 0:
            exit(1)

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Test Homebrew setup")
    parser.add_argument("--profile", choices=["home", "1"], required=True,
                       help="Profile to use (home or 1)")
    args = parser.parse_args()

    tester = SetupTester("~/dotfiles", args.profile)
    tester.test_brew_packages()
    tester.print_results()
