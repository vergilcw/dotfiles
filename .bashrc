set -o vi
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

# if command -v kubectl &> /dev/null
# then
#     source <(kubectl completion bash)
#     exit
# fi

source ~/.git-completion.bash

export GPG_TTY=$(tty)
LANG="en_US.UTF-8"
#[Date Time TZ] user@host:workdir$
PS1="[\D{%Y-%m-%d %H:%M:%S %Z}] \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
