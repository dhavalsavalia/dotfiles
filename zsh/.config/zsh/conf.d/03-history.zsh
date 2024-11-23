# ZSH History Setup
# ------------------------------------------------------------------------------

HISTFILE=$XDG_DATA_HOME/zsh/history     # Save history to XDG data directory
SAVEHIST=1000                           # Save 1000 lines of history
HISTSIZE=999                            # Keep 999 lines of history in memory
setopt share_history                    # Share history between all sessions
setopt hist_expire_dups_first           # Expire duplicates first when trimming history
setopt hist_ignore_dups                 # Ignore duplicates when adding to history
setopt hist_verify                      # Verify history before executing command
