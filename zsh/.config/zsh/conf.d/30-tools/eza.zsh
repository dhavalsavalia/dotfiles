if command -v eza >/dev/null 2>&1; then
    alias ls="eza --color=always --long --git --icons=always"
fi
