# Shared first-use launcher logic for fish, zellij and nvim. Sourced by the
# launchers in .local/bin; requires Bash.
#
# Dispatch order:
#   1. an existing executable on PATH that is not a launcher (never downloaded over)
#   2. a completed managed install under $DOTFILES_TOOLS_DIR
#   3. one-time pinned download, checksum verification, atomic publish
#
# Environment:
#   DOTFILES_TOOLS_DIR       install root (default ${XDG_DATA_HOME:-~/.local/share}/dotfiles/tools)
#   DOTFILES_TOOLS_METADATA  alternate versions file (used by tests with file:// URLs)
#   DOTFILES_LOCK_WAIT       seconds to wait for another installer (default 120)
#   DOTFILES_LOCK_STALE      seconds before an unowned lock is considered abandoned (default 600)
#
# An abandoned lock is recovered automatically (owner PID dead, or older than
# DOTFILES_LOCK_STALE). To recover manually: rm -rf "$DOTFILES_TOOLS_DIR/.lock-<tool>".

_lt_err() { printf 'dotfiles: %s\n' "$*" >&2; }

_lt_find_external() {
  local tool=$1 self=$2 dir cand
  local IFS=:
  for dir in $PATH; do
    [ -n "$dir" ] || dir=.
    cand=$dir/$tool
    [ -f "$cand" ] && [ -x "$cand" ] || continue
    [ "$cand" -ef "$self" ] && continue
    # skip any copy of the managed launchers (e.g. from another clone)
    [ "$(wc -c < "$cand")" -lt 1024 ] && grep -q 'tools/lazy-tool.sh' "$cand" 2>/dev/null && continue
    printf '%s\n' "$cand"
    return 0
  done
  return 1
}

_lt_arch() {
  case "$(uname -m)" in
    x86_64|amd64) echo x86_64 ;;
    aarch64|arm64) echo aarch64 ;;
    *) return 1 ;;
  esac
}

_lt_sha256() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | cut -d' ' -f1
  elif command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | cut -d' ' -f1
  else return 1; fi
}

_lt_lock_acquire() {
  local lock=$1 waited=0 max=${DOTFILES_LOCK_WAIT:-120} stale=${DOTFILES_LOCK_STALE:-600}
  local pid age
  while ! mkdir "$lock" 2>/dev/null; do
    pid=$(cat "$lock/pid" 2>/dev/null)
    if [ -n "$pid" ] && ! kill -0 "$pid" 2>/dev/null; then
      rm -rf "$lock"; continue
    fi
    age=$(( $(date +%s) - $(stat -c %Y "$lock" 2>/dev/null || echo "$(date +%s)") ))
    if [ -z "$pid" ] && [ "$age" -gt "$stale" ]; then
      rm -rf "$lock"; continue
    fi
    if [ "$waited" -ge "$max" ]; then
      _lt_err "timed out waiting for another installer; if none is running, remove $lock"
      return 1
    fi
    sleep 1; waited=$((waited + 1))
  done
  echo $$ > "$lock/pid"
}

_lt_install() {
  local tool=$1 dest=$2 root=$3
  local missing=() need
  for need in curl tar; do command -v "$need" >/dev/null 2>&1 || missing+=("$need"); done
  command -v sha256sum >/dev/null 2>&1 || command -v shasum >/dev/null 2>&1 || missing+=("sha256sum")
  case "$TOOL_URL" in *.xz) command -v xz >/dev/null 2>&1 || missing+=("xz") ;; esac
  if [ ${#missing[@]} -gt 0 ]; then
    _lt_err "cannot install $tool: missing required utilities: ${missing[*]}. Install them or provide a native $tool on PATH."
    return 1
  fi

  mkdir -p "$root" || return 1
  local lock="$root/.lock-$tool"
  _lt_stage= _lt_lock=$lock
  _lt_lock_acquire "$lock" || return 1

  local rc=0
  local stage
  stage=$(mktemp -d "$root/.stage-$tool.XXXXXX") || { rm -rf "$lock"; return 1; }
  _lt_stage=$stage
  trap 'rm -rf "$_lt_stage" "$_lt_lock"' EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM HUP

  if [ -x "$dest/$TOOL_EXE" ] && [ -f "$dest/.complete" ]; then
    return 0 # another process finished while we waited for the lock
  fi

  _lt_err "installing $tool $TOOL_VERSION (one-time download)..."
  mkdir -p "$stage/content" || return 1
  curl --fail --silent --show-error --location --connect-timeout 15 --max-time 300 \
    --retry 3 --retry-delay 2 -o "$stage/archive" "$TOOL_URL" \
    || { _lt_err "download failed: $TOOL_URL"; return 1; }

  local actual
  actual=$(_lt_sha256 "$stage/archive") || return 1
  if [ "$actual" != "$TOOL_SHA256" ]; then
    _lt_err "checksum mismatch for $tool (expected $TOOL_SHA256, got $actual)"
    return 1
  fi

  if [ "$TOOL_STRIP" = 0 ]; then
    mkdir -p "$stage/content/bin"
    tar -xf "$stage/archive" -C "$stage/content/bin" || { _lt_err "extraction failed for $tool"; return 1; }
  else
    tar -xf "$stage/archive" -C "$stage/content" --strip-components="$TOOL_STRIP" \
      || { _lt_err "extraction failed for $tool"; return 1; }
  fi
  [ -f "$stage/content/$TOOL_EXE" ] || { _lt_err "expected $TOOL_EXE missing from $tool archive"; return 1; }
  chmod +x "$stage/content/$TOOL_EXE"
  "$stage/content/$TOOL_EXE" --version >/dev/null 2>&1 \
    || { _lt_err "downloaded $tool does not run on this system (unsupported libc/runtime?). Provide a native $tool on PATH."; return 1; }

  : > "$stage/content/.complete"
  mkdir -p "$(dirname "$dest")" || return 1
  rm -rf "$dest" # only reachable if a previous incomplete dir exists
  mv "$stage/content" "$dest" || return 1
  return $rc
}

lazy_tool_main() {
  local tool=$1 self=$2
  shift 2
  local libdir
  libdir=$(dirname "$(dirname "$(dirname "$self")")")/tools

  local ext
  if ext=$(_lt_find_external "$tool" "$self"); then
    exec "$ext" "$@"
  fi

  if [ "$(uname -s)" != Linux ]; then
    _lt_err "$tool is not on PATH and automatic install is only supported on Linux; install it natively."
    return 127
  fi
  local arch
  arch=$(_lt_arch) || { _lt_err "unsupported architecture $(uname -m); provide a native $tool on PATH."; return 127; }

  # shellcheck disable=SC1090
  . "${DOTFILES_TOOLS_METADATA:-$libdir/versions.sh}" || return 1
  tool_spec "$tool" "$arch" || { _lt_err "no pinned $tool release for $arch"; return 127; }

  local root=${DOTFILES_TOOLS_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles/tools}
  local dest="$root/$tool/$TOOL_VERSION/linux-$arch"
  if ! { [ -x "$dest/$TOOL_EXE" ] && [ -f "$dest/.complete" ]; }; then
    ( _lt_install "$tool" "$dest" "$root" ) || return 1
  fi
  exec "$dest/$TOOL_EXE" "$@"
}
