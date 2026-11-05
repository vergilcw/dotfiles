# Pinned tool releases. Sourced by lazy-tool.sh; bump versions explicitly here.
# tool_spec TOOL ARCH -> sets TOOL_VERSION TOOL_URL TOOL_SHA256 TOOL_STRIP TOOL_EXE
# ARCH is "x86_64" or "aarch64". Returns 1 if the tool/arch is unknown.
tool_spec() {
  local tool=$1 arch=$2
  TOOL_STRIP=0
  case "$tool/$arch" in
    fish/x86_64)
      TOOL_VERSION=4.9.3
      TOOL_URL=https://github.com/fish-shell/fish-shell/releases/download/4.9.3/fish-4.9.3-linux-x86_64.tar.xz
      TOOL_SHA256=8f643d10ad1abb0ef7072764c01ceb5cf61b2d373fda400cf60f0bad69b7e095
      TOOL_EXE=bin/fish ;;
    fish/aarch64)
      TOOL_VERSION=4.9.3
      TOOL_URL=https://github.com/fish-shell/fish-shell/releases/download/4.9.3/fish-4.9.3-linux-aarch64.tar.xz
      TOOL_SHA256=57349f0111728c64b703a84e611aa97ff4d1fa8466385d64e67bd5bc3ffa49fc
      TOOL_EXE=bin/fish ;;
    zellij/x86_64)
      TOOL_VERSION=0.45.1
      TOOL_URL=https://github.com/zellij-org/zellij/releases/download/v0.45.1/zellij-x86_64-unknown-linux-musl.tar.gz
      TOOL_SHA256=40bcc2e03f5d5ae8e054e39f676081fe12ab70871506996ba595834c3718eefc
      TOOL_EXE=bin/zellij ;;
    zellij/aarch64)
      TOOL_VERSION=0.45.1
      TOOL_URL=https://github.com/zellij-org/zellij/releases/download/v0.45.1/zellij-aarch64-unknown-linux-musl.tar.gz
      TOOL_SHA256=05f0802afadd53f8db9514e7cae53c9ae8432fed1b35b8294aa816ee3044a16b
      TOOL_EXE=bin/zellij ;;
    nvim/x86_64)
      TOOL_VERSION=0.12.6
      TOOL_URL=https://github.com/neovim/neovim/releases/download/v0.12.6/nvim-linux-x86_64.tar.gz
      TOOL_SHA256=474430d53e6264f6d6dd18db42d6dc9df3a1b56ca9e88a325bbf860e1a811d87
      TOOL_STRIP=1
      TOOL_EXE=bin/nvim ;;
    nvim/aarch64)
      TOOL_VERSION=0.12.6
      TOOL_URL=https://github.com/neovim/neovim/releases/download/v0.12.6/nvim-linux-arm64.tar.gz
      TOOL_SHA256=8f1f64a0bdb97247034038c3823c6cbad5bdf9ecd5751b85494b71c3ee04c815
      TOOL_STRIP=1
      TOOL_EXE=bin/nvim ;;
    *) return 1 ;;
  esac
}
