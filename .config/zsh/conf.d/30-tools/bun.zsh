if [ -d "$HOME/.bun" ]; then
    export BUN_INSTALL="$HOME/.bun"
    path+=("$BUN_INSTALL/bin")
    [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
fi
