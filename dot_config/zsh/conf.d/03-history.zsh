# ZSH History Setup
# ------------------------------------------------------------------------------

HISTFILE=$XDG_DATA_HOME/zsh/history     # Save history to XDG data directory

# If the history file/directory containing it does not exist, create it
if [ ! -d "$(dirname $HISTFILE)" ]; then
    mkdir -p "$(dirname $HISTFILE)"
    touch $HISTFILE
    chmod 777 $HISTFILE
fi

HISTSIZE=99999                          # Number of lines to keep in memory
HISTFILESIZE=999999                     # Number of lines to keep in history file
SAVEHIST=$HISTSIZE                      # Number of lines to save in history file
setopt share_history                    # Share history between all sessions
setopt hist_expire_dups_first           # Expire duplicates first when trimming history
setopt hist_ignore_dups                 # Ignore duplicates when adding to history
setopt hist_verify                      # Verify history before executing command
setopt append_history                   # Append history to the file
setopt inc_append_history               # Save history incrementally
