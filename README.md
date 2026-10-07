# herdr-tuido

Vikunja tasks in a herdr split pane, via [tui-do](https://github.com/sjwasko/tui-do) (pinned v1.0.2,
checksum-verified at install).

- Open: the `herdr-tuido.open` action (bound in chezmoi's herdr config).
- In the pane: `r` syncs now (push, then fetch changes); `R` syncs everything, catching deletions
  made elsewhere. Background sync runs every `sync.interval_seconds` (chezmoi sets 30).
- Config: `~/.config/tui-do/config.yaml` on every platform (`TUI_DO_CONFIG`); the token file next
  to it comes from 1Password through chezmoi.
- Agents keep using Vikunja's own MCP through Midgard; this is the human view of the same data.

Upgrading tui-do: bump `version` and the three hashes in `scripts/fetch.sh` from the release's
`SHA256SUMS`.
