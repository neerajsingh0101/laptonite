# Auto-update laptonite repo every day
_laptonite_auto_update() {
  local update_stamp="$HOME/.laptonite_update"
  local now=$(date +%s)
  local last=0
  local days=1

  if [[ -f "$update_stamp" ]]; then
    last=$(cat "$update_stamp")
  fi

  if (( (now - last) >= (days * 86400) )); then
    if (
      cd "$LAPTONITED" &&
      # Only auto-update when sitting on main. Being on any other branch means
      # the developer is working on changes, and pulling origin/main into that
      # branch would clobber their work. (A working branch like `next` also has
      # no upstream, which is what produced the "no upstream configured" error.)
      # Friends always run on main, so they still receive every main update.
      [[ "$(git symbolic-ref --quiet --short HEAD)" == "main" ]] &&
      git fetch --quiet origin 2>/dev/null &&
      # Compare against origin/main explicitly (not @{u}) and only update when
      # local main is strictly behind origin/main, i.e. HEAD is an ancestor of
      # origin/main. This avoids announcing an "update" when local main is just
      # ahead of (or diverged from) origin/main because of unpushed commits.
      if [[ $(git rev-parse HEAD) != $(git rev-parse origin/main) ]] &&
         git merge-base --is-ancestor HEAD origin/main; then
        echo "[laptonite] A new version of the laptonite script is available."
        echo "[laptonite] Updating... hang tight."
        # --ff-only avoids surprise merge commits / a half-merged repo if the
        # local history has diverged from origin/main.
        git pull --ff-only --quiet origin main &&
        echo "[laptonite] Done! Laptonite script is now up to date."
      fi
    ); then
      # Only record the timestamp once the check/update completed cleanly, so a
      # failed fetch or a non-fast-forward pull is retried on the next shell
      # instead of being silently skipped for another 24h.
      echo "$now" > "$update_stamp"
    fi
  fi
}
_laptonite_auto_update
