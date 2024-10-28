#!/usr/bin/env python3

import os
import subprocess
import sys
from typing import Union, List, Optional

class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    END = '\033[0m'
    BOLD = '\033[1m'

def log(message: str, level: str = "info") -> None:
    """Print colored log messages."""
    colors = {
        "info": Colors.GREEN,
        "warn": Colors.YELLOW,
        "error": Colors.RED,
    }
    color = colors.get(level, Colors.BLUE)
    print(f"{color}[{level.upper()}]{Colors.END} {message}")

def run_command(
    command: Union[str, List[str]],
    dry_run: bool = False,
    shell: bool = False
) -> Optional[str]:
    """Execute shell commands safely."""
    if isinstance(command, str) and not shell:
        command = command.split()

    if dry_run:
        log(f"Would execute: {' '.join(command) if isinstance(command, list) else command}", "info")
        return None

    try:
        result = subprocess.run(
            command,
            shell=shell,
            check=True,
            text=True,
            capture_output=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        log(f"Command failed: {e}", "error")
        log(f"Error output: {e.stderr}", "error")
        sys.exit(1)

def ensure_dir(path: str) -> None:
    """Create directory if it doesn't exist."""
    os.makedirs(os.path.expanduser(path), exist_ok=True)

def is_command_available(command: str) -> bool:
    """Check if a command is available in the system."""
    try:
        subprocess.run(['which', command],
                      check=True,
                      capture_output=True)
        return True
    except subprocess.CalledProcessError:
        return False
