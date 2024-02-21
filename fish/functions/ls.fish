function ls --wraps='eza --all --icons --hyperlink --long --octal-permissions --header --group-directories-first --git' --description 'alias ls=eza --all --long --header --group-directories-first'
  eza --all --long --header --group-directories-first --octal-permissions --hyperlink --git $argv;
end
