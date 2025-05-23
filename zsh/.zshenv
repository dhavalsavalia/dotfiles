# ────────────────────────────────────────────────────────────────────────────────
# 🌟 Shell Types: Interactive vs Non-Interactive 🌟
# ────────────────────────────────────────────────────────────────────────────────
# 1. **Interactive Shell**:
#    - Expects user input via keyboard (e.g., typing commands in a terminal).
#    - Displays a prompt (e.g., $PS1) and allows interaction with the shell.
#    - Reads startup files like `.zshrc` or `.bashrc` for configuration.
#    - Example: Opening a terminal and typing commands manually.
#
# 2. **Non-Interactive Shell**:
#    - Runs without user interaction, typically executing scripts or automated tasks.
#    - Does not display a prompt or expect input from the user.
#    - Example: Running a shell script (`./script.sh`) or cron jobs.
#
# 🔄 How to Check Shell Type:
#    - Interactive: `[[ $- == *i* ]] && echo "Interactive" || echo "Non-Interactive"`
# ────────────────────────────────────────────────────────────────────────────────
# ────────────────────────────────────────────────────────────────────────────────
# 🌟 Zsh Configuration Files Overview 🌟
# ────────────────────────────────────────────────────────────────────────────────
# 1. 📂 .zshenv:
#    - Sourced in ALL shells (login, interactive, non-interactive).
#    - Use for universal environment variables (e.g., PATH, EDITOR).
#
# 2. 📂 .zprofile:
#    - Sourced in LOGIN shells before .zshrc.
#    - Use for login-specific setup (e.g., modifying PATH).
#
# 3. 📂 .zshrc:
#    - Sourced in INTERACTIVE shells after .zprofile.
#    - Use for aliases, prompts, plugins, and user experience settings.
#
# 4. 📂 .zlogin:
#    - Sourced in LOGIN shells after .zshrc.
#    - Use for commands that run once per session (e.g., welcome messages).
#
# 5. 📂 .zlogout:
#    - Sourced when LOGIN shells exit.
#    - Use for cleanup tasks (e.g., clearing temp files).
#
# 🔄 Load Order: .zshenv → .zprofile → .zshrc → .zlogin → .zlogout

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
