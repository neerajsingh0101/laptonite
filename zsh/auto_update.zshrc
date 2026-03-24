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
    echo "$now" > "$update_stamp"
    (
      cd "$LAPTONITED" &&
      git fetch --quiet origin 2>/dev/null &&
      if [[ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]]; then
        echo "[laptonite] A new version of the laptonite script is available."
        echo "[laptonite] Updating... hang tight."
        git pull --quiet origin main
        echo "[laptonite] Done! Laptonite script is now up to date."
      fi
    )
  fi
}
_laptonite_auto_update
