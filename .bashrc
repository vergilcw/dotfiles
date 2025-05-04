#enable vi mode in command editor:
set -o vi

export EDITOR=vi
export VISUAL=vi
export PAGER=less

export GPG_TTY=$(tty)
LANG="en_US.UTF-8"

# dotfiles/run.sh uses ~/.local/bin as the default bin directory, so make sure it's in
# PATH:
if [[ ":$PATH:" != *":$BIN:"* ]]; then
  echo "$BIN not found in PATH. Adding it..."
  echo "export PATH=\"$BIN:\$PATH\"" >> "$HOME/.bashrc"
  source "$HOME/.bashrc"
  echo "$BIN has been added to PATH."
else
  echo "$BIN is already in PATH."
fi


#check whether gh exists and gh copilot is installed, if so then add ghce and ghcs aliases
if command -v gh &> /dev/null && gh extension list | grep -q "github/gh-copilot"; then 
    echo "gh copilot aliases ghce and ghcs available"
    alias '??'='gh copilot suggest -t shell'
    alias 'git?'='gh copilot suggest -t git'
    alias 'explain'='gh copilot explain'
    alias 'gh?'='gh copilot suggest -t gh'
    eval "$(gh copilot alias -- bash)" 
fi

#if run.sh has been run, then git completions and custom shell prompt scripts should be avalailable
# if [ -f ~/.git-completion.bash ]; then
#     echo "completions: git"
#     source ~/.git-completion.bash
# fi
# 
# if [ -f ~/.git-prompt.sh ]; then
#     echo "completions: git-prompt"
#     source ~/.git-prompt.sh
# fi
# 
# # 1password completions
# if command -v op &> /dev/null; then 
#     echo "completions: 1password (op)"
#     source <(op completion bash)
# fi
# 
# # kubectl completions
# if command -v kubectl &> /dev/null
# then
#     echo "completions: kubectl"
#     source <(kubectl completion bash)
#     exit
# fi

# enable 256 color support for tmux (turned off because it messes up package installation in in run.sh)
# alias tmux="tmux -2"



#prompt color

# original:
# user@host:workdir$
#PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "


# git-prompt.sh settings
# export GIT_PS1_SHOWUNTRACKEDFILES=true
# export GIT_PS1_SHOWCOLORHINTS=true
# export GIT_PS1_SHOWDIRTYSTATE=true
# will show username, at-sign, host, colon,
# current directory, and git status followed by dollar


#PROMPT_COMMAND='__git_ps1 "$green\u$reset@$blue\h$reset:\w" "\$ "'
#export PROMPT_COMMAND='__git_ps1 "\001\033[01;32m\002\u\033[00m\]@\033[01;34m\]\h\033[00m\]:\w" "\$ "'


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
#unset green blue dim reset


