# Shared by follow.sh and toggle.sh. One tui-do pane per machine follows the focused tab.
HERDR="${HERDR_BIN_PATH:-herdr}"
STATE="${HERDR_PLUGIN_STATE_DIR:-$HOME/.local/state/herdr-tuido}"
mkdir -p "$STATE"
WIDTH_RATIO=0.7   # share kept by the pane to its left; the board gets the rest (~30%)

json() { python3 -c "import json,sys; d=json.load(sys.stdin); print($1)" 2>/dev/null; }
# The saved id if it still names a pane, else this plugin's pane by label + cwd (e.g. after herdr
# restores a session), so a restart never leaves two boards.
board_id() {
  id=$(cat "$STATE/pane" 2>/dev/null)
  if [ -n "$id" ] && "$HERDR" pane get "$id" >/dev/null 2>&1; then printf '%s\n' "$id"; return; fi
  id=$("$HERDR" pane list 2>/dev/null | json "next((p['pane_id'] for p in d['result']['panes'] if p.get('label') == 'Vikunja' and 'herdr-tuido' in (p.get('cwd') or '')), '')")
  [ -n "$id" ] && printf '%s\n' "$id" | tee "$STATE/pane"
}
board_tab() { "$HERDR" pane get "$1" 2>/dev/null | json "d['result']['pane']['tab_id']"; }
current() { "$HERDR" pane current 2>/dev/null | json "d['result']['pane']['pane_id'] + ' ' + d['result']['pane']['tab_id']"; }
# herdr-mirror's panes run `herdr terminal session control` over ssh; a local split there would
# desync the mirrored layout, so the board never moves into one.
is_mirror() {
  "$HERDR" pane process-info --pane "$1" 2>/dev/null | grep -q "terminal session control"
}
# mkdir is atomic on Linux and macOS (no flock on macOS); a lock older than 20 s is stale.
lock() {
  if ! mkdir "$STATE/lock" 2>/dev/null; then
    [ -n "$(find "$STATE/lock" -maxdepth 0 -mmin +0.33 2>/dev/null)" ] || return 1
    rm -rf "$STATE/lock"; mkdir "$STATE/lock" 2>/dev/null || return 1
  fi
  trap 'rm -rf "$STATE/lock"' EXIT
}
open_board() { # open_board <target pane> <focus|no-focus>
  id=$("$HERDR" plugin pane open --plugin herdr-tuido --entrypoint board --placement split \
        --direction right --target-pane "$1" "--$2" 2>/dev/null \
        | json "d['result']['plugin_pane']['pane']['pane_id']")
  [ -n "$id" ] && printf '%s\n' "$id" > "$STATE/pane"
}
