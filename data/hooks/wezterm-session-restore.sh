#!/usr/bin/env bash
# wezterm-session-restore — Claude Code SessionStart hook.
# Records the Claude session id, session cwd, and the claude command line
# (for flags like --dangerously-skip-permissions) for the WezTerm pane it is
# running in, so a restored pane can resume the same session after a machine
# restart. Consumed by the wezterm-session-restore WezTerm plugin when
# building its claude-manifest.json snapshot.
set -uo pipefail
trap 'exit 0' ERR        # never disturb session startup
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

[[ -z "${WEZTERM_PANE:-}" ]] && exit 0

REG_DIR="$HOME/.local/state/wezterm-session-restore/claude"
mkdir -p "$REG_DIR"

# Walk up to the claude process (hooks may run under an intermediate shell)
# to capture its real command line.
cmd=""
pid=$PPID
for _ in 1 2 3 4 5; do
  [[ -z "$pid" || "$pid" == "0" || "$pid" == "1" ]] && break
  name="$(basename "$(ps -o comm= -p "$pid" 2>/dev/null || true)")"
  if [[ "$name" == "claude" ]]; then
    cmd="$(ps -o args= -p "$pid" 2>/dev/null || true)"
    break
  fi
  pid="$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')"
done

cat | jq --arg cmd "$cmd" '{session_id: .session_id, cwd: .cwd, command: $cmd}' \
  > "$REG_DIR/pane-$WEZTERM_PANE.json"

# Pane ids are recycled across WezTerm restarts; drop entries from panes that
# have not seen a Claude session in 30 days.
find "$REG_DIR" -name 'pane-*.json' -mtime +30 -delete 2>/dev/null

exit 0
