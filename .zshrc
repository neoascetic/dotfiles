# usage: plug! some/repo[:branch] file-to.load ...
function plug!() {
  local arg=("${(@s/:/)1}") && r=$arg[1] && b=${arg[2]:=master}
  local dir="$HOME/.zsh/$r/$b"
  [[ -d $dir ]] || git clone --depth=1 --branch=$b https://github.com/$r $dir
  for f in "${@:2}"; do source "$dir/$f"; done
}

plug! sindresorhus/pure async.zsh pure.zsh
plug! paulirish/git-open git-open.plugin.zsh
plug! zsh-users/zsh-completions zsh-completions.plugin.zsh
VIRTUALENVWRAPPER_PYTHON=python3
plug! sorin-ionescu/prezto init.zsh
plug! sorin-ionescu/prezto modules/python/init.zsh
plug! sorin-ionescu/prezto modules/docker/init.zsh

# usage: sleep 5; notify
alias notify='echo 1 | nc 127.0.0.1 4321'
function anysound() {
  while true; do
    nc -l 4321 && afplay -v 10 /System/Library/Sounds/Glass.aiff
  done
}
[[ $(lsof -Pi :4321 -sTCP:LISTEN) ]] || anysound > /dev/null &!

# other stuff
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

setopt AUTOCD
typeset -U path cdpath fpath
cdpath=(. ~ ~/work ~/src $cdpath)
path=(. $HOME/bin vendor/bin node_modules/.bin /usr/local/bin /usr/local/sbin $path)
export GOPATH=$HOME

HISTFILE="$HOME/.zhistory" SAVEHIST=1000 HISTSIZE=1000
setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_BEEP
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_EXPIRE_DUPS_FIRST HIST_SAVE_NO_DUPS

EDITOR="emacsclient -t -a ''"
alias e=$EDITOR vim=e
alias g=git
alias ls="ls -GF"
alias bclean="find . \( -name '*.pyc' -or -name '*.beam' \) -delete"
