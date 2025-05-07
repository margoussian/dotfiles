set fish_greeting

if test -e /opt/homebrew/bin/brew
    eval $(/opt/homebrew/bin/brew shellenv)
end

set -xg PATH $HOME/bin $PATH
set -xg EDITOR (which code) -w

# locals.fish is a home for anything machine specific
if test -e ~/.config/fish/locals.fish
    source ~/.config/fish/locals.fish
end

alias ls 'eza --all --long --header --group-directories-first --git'

