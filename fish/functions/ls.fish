function ls --wraps='exa --all --long --header --group-directories-first --git' --description 'alias ls=exa --all --long --header --group-directories-first'
  exa --all --long --header --group-directories-first --git $argv;
end
