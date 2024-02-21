function ls --wraps='eza --all --long --header --group-directories-first --git' --description 'alias ls=eza --all --long --header --group-directories-first'
  exa --all --long --header --group-directories-first --git $argv;
end
