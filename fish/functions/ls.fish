function ls --wraps='eza --all --icons --hyperlink --long --octal-permissions --group-directories-first --git' --description 'alias ls=eza --all --long --header --group-directories-first'
    eza --all --long --group-directories-first --no-permissions --octal-permissions --hyperlink --git --time-style="+%Y-%m-%d %H:%M" $argv
end
