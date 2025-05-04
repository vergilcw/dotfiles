#!/usr/bin/env bash
#!/bin/bash

BIN="$HOME/.local/bin"
mkdir -p "$BIN"

# Skip installation on NixOS
if [ -f /etc/os-release ] && grep -q 'ID=nixos' /etc/os-release; then
  echo "NixOS detected. Skipping binary downloads (assume nix will be used)."
  exit 0
fi

# Function to get the latest release URL from GitHub
latest_url() {
  curl -s "https://api.github.com/repos/$1/releases/latest" |
    grep "browser_download_url" |
    grep -i "$2" |
    cut -d '"' -f 4
}

# Install Fish (static build)
if ! command -v fish &> /dev/null; then
  echo "Fish not found. Installing Fish shell..."
  url=$(latest_url fish-shell/fish-shell "fish-static-amd64.*\.tar\.xz") && curl -Lo fish.tar.xz "$url"
  echo "Extracting Fish shell..."
  tar -xJf fish.tar.xz -C "$BIN" --strip-components=1 fish*/fish
  rm fish.tar.xz
  echo "Fish shell installed successfully!"
else
  echo "Fish shell is already installed."
fi

# Install Zellij (musl static build)
if ! command -v zellij &> /dev/null; then
  echo "Zellij not found. Installing Zellij..."
  url=$(latest_url zellij-org/zellij "zellij-x86_64-unknown-linux-musl\.tar\.gz") && curl -Lo zellij.tar.gz "$url"
  echo "Extracting Zellij..."
  tar -xzf zellij.tar.gz -C "$BIN"
  chmod +x "$BIN/zellij"
  rm zellij.tar.gz
  echo "Zellij installed successfully!"
else
  echo "Zellij is already installed."
fi

# Install Neovim (AppImage)
if ! command -v nvim &> /dev/null; then
  echo "Neovim not found. Installing Neovim..."
  url=$(latest_url neovim/neovim "nvim-linux-x86_64.appimage") && curl -Lo nvim.appimage "$url"
  chmod +x nvim.appimage
  echo "Extracting Neovim AppImage..."
  ./nvim.appimage --appimage-extract
  mv squashfs-root/usr/bin/nvim "$BIN/nvim"
  rm -rf squashfs-root nvim.appimage
  echo "Neovim installed successfully!"
else
  echo "Neovim is already installed."
fi

# Ensure all binaries in $BIN are executable
echo "Making sure all binaries in $BIN are executable..."
chmod +x "$BIN"/*
echo "All binaries are now executable!"


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

