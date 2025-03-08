#!/usr/bin/env bash

# check whether running on a nixos system
if [ -f /etc/nixos/configuration.nix ]
then
    echo "NixOS detected. Skipping Homebrew installation..."
else
    echo "Not NixOS. Proceeding with Homebrew installation..."


# # Install Homebrew
# Check whether homebrew is installed:
if ! command -v brew &> /dev/null
then
    echo "Homebrew is not installed. Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed. Skipping..."
fi 
brew update
brew upgrade
# # Install package
packages="htop git vim wget jq fish zellij ncdu"
# loop through packages and check if they are already present. If not, install them with brew.
for package in $packages
do
    if ! command -v $package &> /dev/null
    then
        echo "$package is not installed. Installing $package..."
        brew install $package
    else
        echo "$package is already installed. Skipping..."
    fi
done

# # Wait a bit before moving on...
sleep 1
# 
# # ...and then.
echo "Success! Basic brew packages are installed."

fi



# Download Git Auto-Completion
# curl "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash" > .git-completion.bash
# curl "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh" > .git-prompt.sh


# # Add Git Auto-Completion to .bashrc
# export GIT_PS1_SHOWUNTRACKEDFILES=true
# export GIT_PS1_SHOWCOLORHINTS=true
# export GIT_PS1_SHOWDIRTYSTATE=true
# 
# # will show username, at-sign, host, colon, 
# # current directory, and git status followed by dollar
# export PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'

dotdir="$(cd "$(dirname "$1")"; pwd)$(basename "$1")"
homedir=$HOME

#extglob for negative pattern matching, dotglob to match dotfiles
shopt -s extglob
#(a)rchive, (v)erbose, (s)ymlink, ~~(f)orce~~, (b)ackup
cp -avsb $dotdir/.!(@(|.)|git|gitignore|*swp|git-completion) $homedir 
# (all dotfiles except not ., .., .git, .gitignore, etc)
shopt -u extglob

