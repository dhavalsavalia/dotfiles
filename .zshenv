export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# PATH and vards I am supposed to be adding
# Setting in .zshenv ensures that these variables are available to all programs
# including in alacritty, tmux, etc.
export PATH="$HOME/.local/bin:$PATH"                       # lvim
export PATH="$HOME/.config/tmuxifier/bin:$PATH"            # tmuxifier
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/.gitconfig" # Git config
