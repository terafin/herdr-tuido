#!/bin/sh
# prefix+t: jump to the board; from inside it, hide it (and stop following); when hidden, bring
# it back and keep following.
. "$(dirname "$0")/lib.sh"
lock || exit 0
set -- $(current); cur="${1:-}"
id=$(board_id); btab=""; [ -n "$id" ] && btab=$(board_tab "$id")
if [ -e "$STATE/off" ] || [ -z "$btab" ]; then
  rm -f "$STATE/off"
  rm -rf "$STATE/lock"; trap - EXIT
  sh "$(dirname "$0")/follow.sh"
  id=$(board_id); [ -n "$id" ] && "$HERDR" plugin pane focus "$id" >/dev/null 2>&1
elif [ "$cur" = "$id" ]; then
  touch "$STATE/off"
  "$HERDR" plugin pane close "$id" >/dev/null 2>&1
  rm -f "$STATE/pane"
else
  rm -rf "$STATE/lock"; trap - EXIT
  sh "$(dirname "$0")/follow.sh"
  "$HERDR" plugin pane focus "$(board_id)" >/dev/null 2>&1
fi
exit 0
