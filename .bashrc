#enable vi mode in command editor:
set -o vi

#export TERM=xterm-256color

#export WORKON_HOME=$HOME/.virtualenvs
#export PROJECT_HOME=$HOME/Devel
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
fi
if [ -f ~/.git-prompt.sh ]; then
    source ~/.git-prompt.sh
fi

alias tmux="tmux -2"

export GPG_TTY=$(tty)
LANG="en_US.UTF-8"


#prompt color

# original:
# user@host:workdir$
#PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "


# git-prompt.sh settings
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
# will show username, at-sign, host, colon,
# current directory, and git status followed by dollar


#PROMPT_COMMAND='__git_ps1 "$green\u$reset@$blue\h$reset:\w" "\$ "'
#export PROMPT_COMMAND='__git_ps1 "\001\033[01;32m\002\u\033[00m\]@\033[01;34m\]\h\033[00m\]:\w" "\$ "'

# Add Git Auto-Completion 
source .git-prompt.sh
source .git-completion.bash

## experiment for clean prompt definition:
#green="\001$(tput setaf 34)\002"
#blue="\001$(tput setaf 32)\002"
#dim="\001$(tput dim)\002"
#reset="\001$(tput sgr0)\002"
#
#PS1="$dim[\t] " # [hh:mm:ss]
#PS1+="$green\u@\h" # user@host
#PS1+="$blue\w\$$reset " # workingdir$
#export PS1
#export PROMPT_COMMAND
unset green blue dim reset

PAGER=less
export PAGER

#check whether gh exists and gh copilot is installed, if so then add ghce and ghcs aliases
if [command -v gh &> /dev/null && gh extension list | grep -q "github/gh-copilot"]; then 
    alias '??'='gh copilot suggest -t shell'
    alias 'git?'='gh copilot suggest -t git'
    alias 'explain'='gh copilot explain'
    alias 'gh?'='gh copilot suggest -t gh'
    eval "$(gh copilot alias -- bash)"; 
fi
