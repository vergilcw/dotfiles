#!/usr/bin/env bash
#only run this from your git repo.
#git pull origin main;

# Download Git Auto-Completion
curl "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash" > .git-completion.bash

dotdir="$(cd "$(dirname "$1")"; pwd)$(basename "$1")"
homedir=$HOME


#extglob for negative pattern matching, dotglob to match dotfiles
shopt -s extglob dotglob
#(a)rchive, (v)erbose, (s)ymlink, (f)orce
cp -avsf $dotdir/.!(@(|.)|git|gitignore|*swp|git-completion) $homedir 
# (all dotfiles except not ., .., .git, .gitignore, etc)
	
