if command -v tmuxifier >/dev/null 2>&1; then
    export TMUXIFIER_LAYOUT_PATH="$XDG_CONFIG_HOME/tmux/layouts"
    eval "$(tmuxifier init -)"
fi
