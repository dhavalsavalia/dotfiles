alias vim="lvim"
alias vi="lvim"
alias v="lvim"
alias lg="lazygit"

alias rz="source ~/.config/zsh/.zshrc"

# 󱩷  Basic Commands
alias c="clear"

# Work computer does not have iCloud Drive setup
alias icloud="cd $HOME/Documents"  # Given iCloud is logged in and synced with Documents

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

#   Safety Commands
alias rm="rm -ri"
alias mv="mv -i"

# 󰂯 Bluetooth goodies
alias bta="bt status 'AirPods Pro'"
alias btb="bt status 'Dhaval's Bose NC700'"

#  Tmux + Tmuxifier + Sesh | # NOTE: While works, these could actually be local scripts. I dunno. Integrate tmuxifier into sesh?
alias tks='tmux kill-session -t $(tmux list-sessions -F "#{session_name}" | gum choose --header "Pick a session to kill: " --header.foreground="114" --selected.foreground="204" --cursor.foreground="204" --item.foreground="231" --select-if-one)'
alias tfls='tmuxifier load-session $(tmuxifier list-sessions | gum filter --placeholder "Pick a session layout: ")'
alias sc='sesh connect $(sesh list | gum filter --placeholder "Pick a session to connect: ")'
