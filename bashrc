set -o vi
#export TERM=xterm-256color

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source <(kubectl completion bash)
