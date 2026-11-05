# My Dotfiles

1. clone this repo in home directory
2. `cd dotfiles && ./setup.sh`
3. This will overwrite local dotfiles with symlinks to ones in the repo
   (existing files are backed up). The script is idempotent.

Setup is configuration-only: it never downloads tools or touches your login
shell. On Linux it also links first-use launchers for `fish`, `zellij` and
`nvim` into `~/.local/bin`.

## First-use launchers

Each launcher runs, in order:

1. an existing native tool on `PATH` (never replaced or overridden),
2. a previously installed managed copy under
   `${XDG_DATA_HOME:-~/.local/share}/dotfiles/tools/<tool>/<version>/<platform>/`,
3. otherwise a one-time download of the pinned release in `tools/versions.sh`,
   checksum-verified and published atomically, then run.

Nothing is downloaded at setup or Bash startup; only explicitly running
`fish`, `zellij` or `nvim` can trigger an install. Bash stays the default shell.
Requirements on first use: `curl`, `tar`, `sha256sum` (or `shasum`), plus `xz`
for Fish. Supported: Linux x86_64 and aarch64 (Neovim needs glibc >= 2.34;
otherwise install a native Neovim). Failures are reported and a later run
retries. To bump a version, edit `tools/versions.sh` (URL and SHA-256).
An abandoned install lock is recovered automatically; manually remove
`<tools dir>/.lock-<tool>` if needed.

Run `tests/lazy-tools.sh` for the mocked-download test suite.
