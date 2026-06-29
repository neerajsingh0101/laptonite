#!/usr/bin/env bash
#
# Verify that ~/.claude/settings.json is still a symlink into the laptonite
# repo. Claude Code rewrites its settings file atomically (write temp + rename),
# which silently replaces the symlink with a detached regular file -- after that
# you neither receive shared updates nor share your own. This check warns when
# that has happened. It NEVER blocks the git operation; it only prints guidance.
#
# Usage: check-claude-symlink.sh [commit|merge]
set -u

context="${1:-}"

# Resolve the repo root from this script's own location so the check works no
# matter where a teammate cloned laptonite. This file lives at
# <repo>/githooks/lib/check-claude-symlink.sh
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
expected="$repo_root/symlinks/claude/settings.json"
dst="$HOME/.claude/settings.json"

# Healthy: dst is a symlink that resolves to the repo's settings file.
if [ -L "$dst" ] \
  && [ "$(readlink -f "$dst" 2>/dev/null)" = "$(readlink -f "$expected" 2>/dev/null)" ]; then
  exit 0
fi

yellow=$'\033[1;33m'
reset=$'\033[0m'

{
  echo "${yellow}⚠️  laptonite: ~/.claude/settings.json is no longer linked to the laptonite repo.${reset}"
  if [ -L "$dst" ]; then
    echo "   It points somewhere unexpected: $(readlink "$dst")"
  elif [ -e "$dst" ]; then
    echo "   It is a detached regular file now -- Claude Code most likely overwrote the"
    echo "   symlink, so your Claude settings are out of sync with the team."
  else
    echo "   It is missing."
  fi
  if [ "$context" = "merge" ]; then
    echo "   You just pulled laptonite updates, but the latest shared Claude settings"
    echo "   will NOT reach you until the link is restored."
  fi
  echo "   Fix it by running:  bin/setup"
  echo "   (bin/setup backs up your current file to a *-bkp-* copy, then re-links it.)"
} >&2

exit 1
