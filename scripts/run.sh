#!/bin/sh
# One config path on every platform (macOS would otherwise use ~/Library/Application Support).
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
export TUI_DO_CONFIG="${TUI_DO_CONFIG:-$HOME/.config/tui-do/config.yaml}"
if [ ! -f "$TUI_DO_CONFIG" ]; then
  echo "herdr-tuido: $TUI_DO_CONFIG is missing (chezmoi lays it). Press a key to close."; read -r _; exit 1
fi
exec "$root/bin/tui-do"
