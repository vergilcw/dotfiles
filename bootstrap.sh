#!/usr/bin/env bash
#only run this from your git repo.
#git pull origin main;

# Download Git Auto-Completion
curl "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash" > .git-completion.bash
curl "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh" > .git-prompt.sh
bash .git-prompt.sh


dotdir="$(cd "$(dirname "$1")"; pwd)$(basename "$1")"
homedir=$HOME


#extglob for negative pattern matching, dotglob to match dotfiles
shopt -s extglob
#(a)rchive, (v)erbose, (s)ymlink, ~~(f)orce~~, (b)ackup
cp -avsb $dotdir/.!(@(|.)|git|gitignore|*swp|git-completion) $homedir 
# (all dotfiles except not ., .., .git, .gitignore, etc)
shopt -u extglob




if gh extension list | grep -q "github/gh-copilot" && ! grep -q "gh copilot" ~/.bashrc; then echo 'eval "$(gh copilot alias -- bash)"' >> ~/.bashrc; fi



