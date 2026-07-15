#!/usr/bin/env bash

set -euo pipefail

CCMUX_VERSION="1.1.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH_FILE="$SCRIPT_DIR/patches/v${CCMUX_VERSION}-show-window-name.patch"
INSTALL_DIR="${CCMUX_INSTALL_DIR:-$HOME/.local/bin}"
INSTALL_PATH="$INSTALL_DIR/ccmux"
STAMP_PATH="$INSTALL_DIR/.ccmux-dotfiles-patch"
PATCH_SUM="$(cksum < "$PATCH_FILE")"

if [[ -x "$INSTALL_PATH" ]] &&
   [[ -f "$STAMP_PATH" ]] &&
   [[ "$(cat "$STAMP_PATH")" == "$PATCH_SUM" ]]; then
    echo "Patched ccmux is current: $INSTALL_PATH"
    exit 0
fi

for command_name in bun git; do
    if ! command -v "$command_name" >/dev/null; then
        echo "Missing required command: $command_name" >&2
        exit 1
    fi
done

build_dir="$(mktemp -d "${TMPDIR:-/tmp}/ccmux-build.XXXXXX")"
trap 'rm -rf "$build_dir"' EXIT

git clone --quiet --depth 1 --branch "v$CCMUX_VERSION" \
    https://github.com/epilande/ccmux.git "$build_dir"
git -C "$build_dir" apply --unidiff-zero --whitespace=nowarn "$PATCH_FILE"

(
    cd "$build_dir"
    bun install --frozen-lockfile
    bun run build
    bun build dist/index.js --compile \
        --no-compile-autoload-bunfig \
        --outfile "$build_dir/ccmux"
)

mkdir -p "$INSTALL_DIR"
install -m 755 "$build_dir/ccmux" "$INSTALL_PATH"
printf '%s\n' "$PATCH_SUM" > "$STAMP_PATH"
echo "Installed patched ccmux: $INSTALL_PATH"
