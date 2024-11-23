# PATH management
typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$path[@]"
)
