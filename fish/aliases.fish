# Navigation
alias cd="z"

# Better defaults
alias ls 'eza --all --long --group-directories-first --no-permissions --octal-permissions --hyperlink --git --time-style="+%Y-%m-%d %H:%M" $argv'
alias cat="bat $argv"

# Editors
alias v="nvim $argv"
if test (uname) = "Darwin"
    alias zed="zed $argv"
else
    alias zed="zeditor $argv"
end
