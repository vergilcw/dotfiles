#enable vi mode in command editor:
set -o vi
#enable pressing up anywhere in the line to transit history on unique text to right of cursor
"\e[A": history-search-backward
"\e[B": history-search-forward

#export TERM=xterm-256color

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
#source /usr/local/bin/virtualenvwrapper.sh

# # If not running interactively, return
# case $- in
#     *i*) ;;
#       *) return;;
# esac
# if [ -f "/google/devshell/bashrc.google" ]; then
#   source "/google/devshell/bashrc.google"
# fi

if command -v kubectl &> /dev/null
then
    source <(kubectl completion bash)
    exit
fi

# if file exists, source it
if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
    exit
fi
if [ -f ~/.git-prompt.sh ]; then
    source ~/.git-prompt.sh
    exit
fi

alias tmux="tmux -2"

export GPG_TTY=$(tty)
LANG="en_US.UTF-8"
#[Date Time TZ] user@host:workdir$
PS1="[\D{%Y-%m-%d %H:%M:%S %Z}] \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

PAGER=less
export PAGER

#check whether gh exists and gh copilot is installed, if so then add ghce and ghcs aliases
if command -v gh &> /dev/null && gh extension list | grep -q "github/gh-copilot"; then eval "$(gh copilot alias -- bash)"; fi
