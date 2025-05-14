# cspell: disable
if status is-interactive
    # Git
    abbr --add ga 'git add'
    abbr --add gb 'git branch --sort=-committerdate' # Desc
    abbr --add gc 'git commit -m'
    abbr --add gco 'git checkout'
    abbr --add gf 'git fetch'
    abbr --add grb 'git rebase origin/master'
    abbr --add gn "git checkout -b" # new branch
    abbr --add gs "git status --short"
    abbr --add gd 'git diff --output-indicator-new=" " --output-indicator-old=" "'
    abbr --add gl 'git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n"'
    abbr --add gp 'git push origin'
    abbr --add gr 'git reset'
end
