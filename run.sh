#!/usr/bin/env bash

# # Install Homebrew
# 
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# brew update
# brew upgrade
# 
# brew tap homebrew/cask-versions
# 
# # Install packages
# brew install --cask hpedrorodrigues/tools/dockutil # See https://github.com/kcrawford/dockutil/issues/127#issuecomment-1118733013
# # brew install dockutil # Used to manage the dock
# brew install htop
# brew install git
# brew install wget
# brew install jq # Used for json manipulation
# brew install fish #better shell
# # Wait a bit before moving on...
# sleep 1
# 
# # ...and then.
# echo "Success! Basic brew packages are installed."


# Download Git Auto-Completion
curl "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash" > .git-completion.bash
curl "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh" > .git-prompt.sh


# # Add Git Auto-Completion to .bashrc
# export GIT_PS1_SHOWUNTRACKEDFILES=true
# export GIT_PS1_SHOWCOLORHINTS=true
# export GIT_PS1_SHOWDIRTYSTATE=true
# 
# # will show username, at-sign, host, colon, 
# # current directory, and git status followed by dollar
# export PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'

echo "made it to 1"
dotdir="$(cd "$(dirname "$1")"; pwd)$(basename "$1")"
homedir=$HOME
echo "made it to 2"

#extglob for negative pattern matching, dotglob to match dotfiles
shopt -s extglob
#(a)rchive, (v)erbose, (s)ymlink, ~~(f)orce~~, (b)ackup
cp -avsb $dotdir/.!(@(|.)|git|gitignore|*swp|git-completion) $homedir 
# (all dotfiles except not ., .., .git, .gitignore, etc)
shopt -u extglob

