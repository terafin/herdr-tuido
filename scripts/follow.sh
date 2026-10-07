#!/bin/sh
# Event + startup handler: keep the board in the focused tab, as a right-hand column, without
# taking focus. Does nothing while the board is toggled off.
. "$(dirname "$0")/lib.sh"
[ -e "$STATE/off" ] && exit 0
lock || exit 0
set -- $(current); cur="${1:-}"; tab="${2:-}"
[ -n "$cur" ] || exit 0
id=$(board_id)
[ "$cur" = "$id" ] && exit 0
is_mirror "$cur" && exit 0
btab=""; [ -n "$id" ] && btab=$(board_tab "$id")
if [ -z "$btab" ]; then
  open_board "$cur" no-focus
elif [ "$btab" != "$tab" ]; then
  new=$("$HERDR" pane move "$id" --tab "$tab" --split right --target-pane "$cur" \
         --ratio "$WIDTH_RATIO" --no-focus 2>/dev/null | json "d['result']['move_result']['pane']['pane_id']")
  # Moving to another workspace renumbers the pane; keep the id current.
  [ -n "$new" ] && printf '%s\n' "$new" > "$STATE/pane"
fi
exit 0
