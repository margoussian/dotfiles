set fish_greeting

if status is-interactive; and test -e /opt/homebrew/bin/brew
    eval $(/opt/homebrew/bin/brew shellenv)
end

set -xg PATH $HOME/.local/bin $HOME/bin $PATH
set -xg EDITOR (which zeditor) -w

# Activate mise if installed
if command -v mise &> /dev/null
    mise activate fish | source
end

# Source aliases
source ~/.config/fish/aliases.fish

# locals.fish is a home for anything machine specific
if test -e ~/.config/fish/locals.fish
    source ~/.config/fish/locals.fish
end

# add to ~/.config/fish/config.fish
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
