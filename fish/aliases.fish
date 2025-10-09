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

# Tailscale exit node
function ts-exit-on
    sudo tailscale up --exit-node=$argv[1] --accept-dns
end
alias ts-exit-off="sudo tailscale up --exit-node="
