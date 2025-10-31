eval "$(/opt/homebrew/bin/brew shellenv)"

# Source all configuration files
for conf in "$ZDOTDIR"/conf.d/*.zsh(N); do
    source "$conf"
done

# Source tool-specific configs
for conf in "$ZDOTDIR"/conf.d/30-tools/*.zsh(N); do
    source "$conf"
done
