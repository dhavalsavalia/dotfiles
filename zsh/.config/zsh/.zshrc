eval "$(/opt/homebrew/bin/brew shellenv)"

if [[ -r "${XDG_CONFIG_HOME}:-$HOME/.cache}}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CONFIG_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source all configuration files
for conf in "$ZDOTDIR"/conf.d/*.zsh(N); do
    source "$conf"
done

# Source tool-specific configs
for conf in "$ZDOTDIR"/conf.d/30-tools/*.zsh(N); do
    source "$conf"
done
