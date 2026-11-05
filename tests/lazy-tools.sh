#!/usr/bin/env bash
# Mocked tests for setup.sh and the first-use launchers (no real downloads).
set -u
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d "${TMPDIR:-/tmp}/lazy tools.XXXXXX")" # space in path on purpose
trap 'rm -rf "$tmp"' EXIT
fail=0
ok() { printf 'ok   %s\n' "$1"; }
bad() { printf 'FAIL %s\n' "$1"; fail=1; }
check() { if eval "$2"; then ok "$1"; else bad "$1"; fi; }

# Mock release archives: fish/zellij single binary, nvim full tree.
mk="$(mktemp -d)"; trap 'rm -rf "$tmp" "$mk"' EXIT; mkdir -p "$mk/src/nvim-linux-x86_64/bin" "$mk/src/nvim-linux-x86_64/share"
for t in fish zellij; do
  printf '#!/bin/sh\n[ "$1" = --version ] && { echo %s mock; exit 0; }\n[ "$1" = -c ] && exit "${3:-0}"\necho "%s ran: $*"\n' "$t" "$t" > "$mk/src/$t"
  chmod +x "$mk/src/$t"
  tar -C "$mk/src" -czf "$mk/$t.tar.gz" "$t"
done
printf '#!/bin/sh\n[ "$1" = --version ] && exit 0\necho "nvim ran: $*; runtime=$(ls "$(dirname "$0")/../share")"\n' > "$mk/src/nvim-linux-x86_64/bin/nvim"
chmod +x "$mk/src/nvim-linux-x86_64/bin/nvim"; : > "$mk/src/nvim-linux-x86_64/share/runtime-file"
tar -C "$mk/src" -czf "$mk/nvim.tar.gz" nvim-linux-x86_64
sha() { sha256sum "$1" | cut -d' ' -f1; }

meta() { # meta <tool-url-suffix-override-for-nvim> writes metadata for current arch
  cat > "$tmp/versions.sh" <<EOF
tool_spec() {
  TOOL_VERSION=1.0; TOOL_STRIP=0
  case "\$1" in
    fish) TOOL_URL="file://$mk/fish.tar.gz"; TOOL_SHA256=$(sha "$mk/fish.tar.gz"); TOOL_EXE=bin/fish ;;
    zellij) TOOL_URL="file://$mk/zellij.tar.gz"; TOOL_SHA256=${ZSHA:-$(sha "$mk/zellij.tar.gz")}; TOOL_EXE=bin/zellij ;;
    nvim) TOOL_URL="file://$mk/nvim.tar.gz"; TOOL_SHA256=$(sha "$mk/nvim.tar.gz"); TOOL_STRIP=1; TOOL_EXE=bin/nvim ;;
  esac
}
EOF
}
meta

# --- setup.sh
home="$tmp/home dir"; mkdir -p "$home" "$home/.local/bin"
printf 'native\n' > "$home/keep"
HOME="$home" bash "$repo/setup.sh" >/dev/null 2>&1
check "setup links launchers" '[ -L "$home/.local/bin/nvim" ] && [ -L "$home/.local/bin/fish" ]'
check "setup links fish config" '[ -L "$home/.config/fish/config.fish" ]'
check "setup downloads nothing" '[ ! -d "$home/.local/share/dotfiles" ]'
HOME="$home" bash "$repo/setup.sh" >/dev/null 2>&1
check "setup rerun ok" '[ -L "$home/.local/bin/zellij" ]'

export HOME="$home" DOTFILES_TOOLS_METADATA="$tmp/versions.sh" DOTFILES_TOOLS_DIR="$tmp/tools dir"
export DOTFILES_LOCK_WAIT=5
L="$home/.local/bin"
PATH_BASE="/usr/bin:/bin"

# --- first use installs only that tool, preserves args
out=$(PATH="$L:$PATH_BASE" "$L/zellij" --flag "a b" 2>&1); rc=$?
check "zellij first use runs with args" '[ $rc = 0 ] && [[ "$out" == *"zellij ran: --flag a b"* ]]'
check "only zellij installed" '[ -d "$DOTFILES_TOOLS_DIR/zellij" ] && [ ! -d "$DOTFILES_TOOLS_DIR/fish" ]'
out=$(PATH="$L:$PATH_BASE" "$L/nvim" x 2>&1)
check "nvim keeps runtime tree" '[[ "$out" == *"runtime=runtime-file"* ]]'

# --- offline reuse
mv "$mk/zellij.tar.gz" "$mk/zellij.gone"
out=$(PATH="$L:$PATH_BASE" "$L/zellij" again 2>&1)
check "reuse works offline" '[[ "$out" == *"zellij ran: again"* ]] && [[ "$out" != *installing* ]]'
mv "$mk/zellij.gone" "$mk/zellij.tar.gz"

# --- exit status
PATH="$L:$PATH_BASE" "$L/fish" -c 'exit 7' 7 >/dev/null 2>&1
check "fish preserves exit status" '[ $? = 7 ]'

# --- native tool later on PATH wins, no download, no recursion
rm -rf "$DOTFILES_TOOLS_DIR"
nat="$tmp/native"; mkdir -p "$nat"; printf '#!/bin/sh\necho native fish\n' > "$nat/fish"; chmod +x "$nat/fish"
out=$(PATH="$L:$nat:$PATH_BASE" "$L/fish" 2>&1)
check "native later on PATH used" '[ "$out" = "native fish" ] && [ ! -d "$DOTFILES_TOOLS_DIR" ]'
ln -s "$L/fish" "$tmp/alias-fish-dir-fish" 2>/dev/null
mkdir -p "$tmp/alias"; ln -s "$L/fish" "$tmp/alias/fish"
out=$(PATH="$tmp/alias:$L:$nat:$PATH_BASE" "$L/fish" 2>&1)
check "symlink alias of launcher skipped" '[ "$out" = "native fish" ]'

# --- checksum mismatch: no usable install, retry succeeds
ZSHA=deadbeef meta
out=$(PATH="$L:$PATH_BASE" "$L/zellij" 2>&1); rc=$?
check "checksum mismatch fails" '[ $rc != 0 ] && [[ "$out" == *"checksum mismatch"* ]]'
check "no partial install left" '[ -z "$(find "$DOTFILES_TOOLS_DIR" -name .complete 2>/dev/null | grep zellij)" ] && [ -z "$(ls -A "$DOTFILES_TOOLS_DIR" 2>/dev/null | grep -E "^\.(stage|lock)")" ]'
meta
out=$(PATH="$L:$PATH_BASE" "$L/zellij" retry 2>&1)
check "retry after failure works" '[[ "$out" == *"zellij ran: retry"* ]]'

# --- HTTP/missing download failure
mv "$mk/fish.tar.gz" "$mk/fish.gone"
out=$(PATH="$L:$PATH_BASE" "$L/fish" 2>&1); rc=$?
check "download failure reported, nonzero" '[ $rc != 0 ] && [[ "$out" == *"download failed"* ]]'
mv "$mk/fish.gone" "$mk/fish.tar.gz"

# --- concurrency
rm -rf "$DOTFILES_TOOLS_DIR"
for i in 1 2 3; do (PATH="$L:$PATH_BASE" "$L/nvim" "p$i" > "$tmp/c$i.out" 2>&1) & done; wait
check "concurrent first runs all succeed" 'grep -q "nvim ran: p1" "$tmp/c1.out" && grep -q "nvim ran: p2" "$tmp/c2.out" && grep -q "nvim ran: p3" "$tmp/c3.out"'
check "one install dir" '[ "$(find "$DOTFILES_TOOLS_DIR/nvim" -name .complete | wc -l)" = 1 ]'

# --- abandoned lock is recovered
rm -rf "$DOTFILES_TOOLS_DIR"; mkdir -p "$DOTFILES_TOOLS_DIR/.lock-fish"; echo 99999999 > "$DOTFILES_TOOLS_DIR/.lock-fish/pid"
out=$(PATH="$L:$PATH_BASE" "$L/fish" -c 'exit 0' 2>&1)
check "dead-owner lock recovered" '[ -f "$(find "$DOTFILES_TOOLS_DIR/fish" -name .complete | head -1)" ]'
rm -rf "$DOTFILES_TOOLS_DIR"; mkdir -p "$DOTFILES_TOOLS_DIR/.lock-fish"; echo $$ > "$DOTFILES_TOOLS_DIR/.lock-fish/pid"
out=$(PATH="$L:$PATH_BASE" "$L/fish" 2>&1); rc=$?
check "live lock times out" '[ $rc != 0 ] && [[ "$out" == *"timed out"* ]]'

# --- unsupported arch (fake uname)
fake="$tmp/fakebin"; mkdir -p "$fake"; printf '#!/bin/sh\n[ "$1" = -m ] && echo riscv64 || echo Linux\n' > "$fake/uname"; chmod +x "$fake/uname"
rm -rf "$DOTFILES_TOOLS_DIR"
out=$(PATH="$fake:$L:$PATH_BASE" "$L/fish" 2>&1); rc=$?
check "unsupported arch clear error" '[ $rc = 127 ] && [[ "$out" == *"unsupported architecture"* ]]'
printf '#!/bin/sh\n[ "$1" = -m ] && echo arm64 || echo Linux\n' > "$fake/uname"
# arm64 alias maps to aarch64 in real metadata
out=$(DOTFILES_TOOLS_METADATA="$repo/tools/versions.sh" PATH="$fake:$L:$PATH_BASE" bash -c '. "$0/tools/lazy-tool.sh"; . "$0/tools/versions.sh"; a=$(_lt_arch); tool_spec nvim "$a"; echo "$a $TOOL_URL"' "$repo")
check "arm64 maps to aarch64 asset" '[[ "$out" == *"aarch64 "*nvim-linux-arm64.tar.gz ]]'

# --- bash startup never installs
rm -rf "$DOTFILES_TOOLS_DIR"
PATH="$L:$PATH_BASE" bash -i -c 'source "$HOME/.bashrc"' >/dev/null 2>&1 </dev/null
check "bashrc triggers no install" '[ ! -d "$DOTFILES_TOOLS_DIR" ]'

[ $fail = 0 ] && echo "ALL PASSED" || { echo "FAILURES"; exit 1; }
