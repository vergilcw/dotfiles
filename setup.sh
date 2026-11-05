#!/usr/bin/env bash
# Configuration-only setup: links dotfiles and the first-use launchers
# (fish, zellij, nvim) into $HOME. No tools are downloaded or installed here;
# the launchers fetch pinned releases the first time they are run explicitly.
# macOS and NixOS keep their external provisioning and get no launchers.

set -u

OS="$(uname -s)"
dotdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
homedir=$HOME

# macOS cp doesn't support -b (backup), so we use -f (force) instead
if [[ "$OS" == "Darwin" ]]; then
  CP_ARGS="-avsf"
else
  CP_ARGS="-avsb"
fi

use_launchers=1
if [[ "$OS" != "Linux" ]]; then
  use_launchers=0
elif [ -f /etc/os-release ] && grep -q 'ID=nixos' /etc/os-release; then
  use_launchers=0
  echo "NixOS detected. Skipping launchers (assume nix provides tools)."
fi
[[ "$OS" == "Darwin" ]] && echo "macOS detected. Skipping launchers (assume nix-darwin is used)."

# Symlink every file under a directory of the repo, preserving structure.
link_tree() {
  local rel=$1 f rel_path target_dir
  [ -d "$dotdir/$rel" ] || return 0
  find "$dotdir/$rel" -type f | while IFS= read -r f; do
    rel_path="${f#"$dotdir"/}"
    target_dir="$homedir/$(dirname "$rel_path")"
    mkdir -p "$target_dir"
    cp $CP_ARGS "$f" "$target_dir/$(basename "$f")"
  done
}

setup_symlinks() {
  echo "Symlinking dotfiles from $dotdir to $homedir..."
  local file name
  for file in "$dotdir"/.*; do
    name=$(basename "$file")
    [[ "$name" == "." || "$name" == ".." ]] && continue
    [[ "$name" == ".git" || "$name" == ".gitignore" || "$name" == ".git-completion" || "$name" == ".config" || "$name" == ".local" || "$name" == ".DS_Store" ]] && continue
    [[ "$name" == *.swp ]] && continue
    cp $CP_ARGS "$file" "$homedir"
  done

  echo "Symlinking .config files..."
  link_tree .config

  if [[ $use_launchers == 1 ]]; then
    echo "Symlinking launchers into ~/.local/bin..."
    link_tree .local/bin
  fi
}

setup_symlinks
