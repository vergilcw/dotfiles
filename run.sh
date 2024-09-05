#!/usr/bin/env bash

# Download Git Auto-Completion
curl "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash" > .git-completion.bash
curl "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh" > .git-prompt.sh

# Add Git Auto-Completion to .bashrc
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true

# will show username, at-sign, host, colon, 
# current directory, and git status followed by dollar
export PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'

source .git-prompt.sh
source .git-completion.bash


dotdir="$(cd "$(dirname "$1")"; pwd)$(basename "$1")"
homedir=$HOME


#extglob for negative pattern matching, dotglob to match dotfiles
shopt -s extglob
#(a)rchive, (v)erbose, (s)ymlink, ~~(f)orce~~, (b)ackup
cp -avsb $dotdir/.!(@(|.)|git|gitignore|*swp|git-completion) $homedir 
# (all dotfiles except not ., .., .git, .gitignore, etc)
shopt -u extglob

