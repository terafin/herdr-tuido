# herdr-tuido

Vikunja tasks in a herdr split pane, via [tui-do](https://github.com/sjwasko/tui-do) (pinned v1.0.2,
checksum-verified at install).

- Always present: one board per machine follows you. On every tab or workspace switch (and at herdr
  startup) it moves into the focused tab as a full-height right-hand column, without taking focus and
  without restarting tui-do. It never moves into a herdr-mirror workspace (a local split there would
  desync the mirror); it stays where it was.
- Width: 30% of the tab to start. Resize it and that width is kept: it is recorded as a share of the
  tab whenever the board leaves a tab or hides, and each move splits the tab's rightmost full-height
  pane so the board gets that share of the whole tab (15-70%).
- `prefix+t` (the `herdr-tuido.open` action): jump to the board; from inside it, hide it and stop
  following; when hidden, bring it back.
- In the pane: `r` syncs now (push, then fetch changes); `R` syncs everything, catching deletions
  made elsewhere. Background sync runs every `sync.interval_seconds` (chezmoi sets 30).
- Config: `~/.config/tui-do/config.yaml` on every platform (`TUI_DO_CONFIG`); the token file next
  to it comes from 1Password through chezmoi.
- Agents keep using Vikunja's own MCP through Midgard; this is the human view of the same data.

Upgrading tui-do: bump `version` and the three hashes in `scripts/fetch.sh` from the release's
`SHA256SUMS`.
