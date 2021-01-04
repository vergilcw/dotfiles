set -o vi
#export TERM=xterm-256color

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
if command -v kubectl &> /dev/null
then
    source <(kubectl completion bash)
    exit
fi
