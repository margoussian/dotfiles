set fish_greeting

if status is-interactive; and test -e /opt/homebrew/bin/brew
    eval $(/opt/homebrew/bin/brew shellenv)
end

set -xg PATH $HOME/bin $PATH
set -xg EDITOR (which code) -w

# locals.fish is a home for anything machine specific
if test -e ~/.config/fish/locals.fish
    source ~/.config/fish/locals.fish
end

alias cd="z"
alias ls 'eza --all --long --group-directories-first --no-permissions --octal-permissions --hyperlink --git --time-style="+%Y-%m-%d %H:%M" $argv'
alias v="nvim $argv"
alias cat="bat $argv"
if test (uname) = "Darwin"
    alias zed="zed $argv"
else
    alias zed="zeditor $argv"
end
