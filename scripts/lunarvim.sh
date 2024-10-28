#!/bin/bash

set -e

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

install_lunarvim() {

    if command_exists "lvim"; then
        log "LunarVim is already installed"
        return 0
    fi

    # Install dependencies first
    log "Installing LunarVim dependencies..."

    # Install npm dependencies
    local npm_deps=("neovim")
    if ! command_exists "tree-sitter"; then
        npm_deps+=("tree-sitter-cli")
    fi

    for dep in "${npm_deps[@]}"; do
        if command_exists "pnpm"; then
            execute "pnpm install -g $dep"
        elif command_exists "bun"; then
            execute "bun install -g $dep"
        elif command_exists "npm"; then
            execute "npm install -g $dep"
        else
            error "No package manager (pnpm, bun, or npm) found"
            exit 1
        fi
    done

    # Install rust dependencies
    local rust_deps=("ripgrep" "fd-find")
    for dep in "${rust_deps[@]}"; do
        if ! command_exists "${dep%%::*}"; then
            if command_exists "cargo"; then
                execute "cargo install $dep"
            else
                warn "Cargo not found. Please install Rust and Cargo to install $dep"
            fi
        fi
    done

    # Install LunarVim Nightly
    log "Installing LunarVim..."
    execute 'bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)'

    # Verify installation
    if command_exists "lvim"; then
        log "LunarVim installed successfully!"
    else
        error "LunarVim installation failed"
        exit 1
    fi
}

# Main execution
install_lunarvim
