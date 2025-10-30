# PATH management
typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$XDG_CONFIG_HOME/local_scripts"
    "$path[@]"
)
