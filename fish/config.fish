set fish_greeting

if status is-interactive; and test -e /opt/homebrew/bin/brew
    eval $(/opt/homebrew/bin/brew shellenv)
end

if status is-interactive; and test -e /usr/bin/try
    eval (/usr/bin/try init ~/src/tries | string collect)
end

set -xg PATH $HOME/.local/bin $HOME/bin $PATH
# Zed's CLI is `zed` (Homebrew cask on macOS); `zeditor` is the Linux name.
# Guard the lookup: an unguarded `(which zeditor)` that found nothing left
# EDITOR set to the bare string "-w".
for zed_cli in zed zeditor
    if command --query $zed_cli
        set -xg EDITOR $zed_cli --wait
        break
    end
end

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
