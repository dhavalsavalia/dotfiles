#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Function to execute commands with dry run support
execute() {
    if [ "$DRY_RUN" = "true" ]; then
        echo "WOULD EXECUTE: $*"
        return 0
    else
        echo "EXECUTING: $*"
        eval "$@"
        return $?
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}