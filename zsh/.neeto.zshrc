alias neetozone='cd ~/code/neetozone'
alias neetozoned='cd ~/code/neetozone'
alias neetob='cd ~/code/neetozone/neetob'
alias neetobd='cd ~/code/neetozone/neetob'
alias neetlyd='cd ~/code/neetozone/neetly'
alias website='cd ~/code/neetozone/neeto-website'
alias websited='cd ~/code/neetozone/neeto-website'
unalias setup 2>/dev/null

setup() {
  if [[ -x ./bin/setup ]]; then
    ./bin/setup "$@"
  else
    ./bin/setup-mise "$@"
  fi
}

unalias launch 2>/dev/null
launch() {
  ./bin/launch "$@"
}

stl() {
  local repo_name=$(basename "$(pwd)")
  if [[ "$repo_name" == "neetly" ]]; then
    swift run neetly-app
  elif [[ "$repo_name" == *-website ]]; then
    yarn install
    yarn dev &
    local dev_pid=$!
    local url="http://localhost:3000"
    local attempts=120
    while (( attempts-- > 0 )); do
      if curl -s -o /dev/null -w '' "$url" 2>/dev/null; then
        open "$url"
        break
      fi
      sleep 0.5
    done
    wait $dev_pid
  else
    local setup_cmd
    if [[ -f ./bin/setup-mise ]]; then
      setup_cmd="./bin/setup-mise"
    else
      setup_cmd="./bin/setup"
    fi
    SIDEBAR_TITLE="$SIDEBAR_TITLE" $setup_cmd "$@" \
      && SIDEBAR_TITLE="$SIDEBAR_TITLE" ./bin/launch "$@"
  fi
}

# neeto repos
neeto_repos=(
  auth form cal chat desk kb
  quiz site runner replay invoice
  planner course wireframe engage crm
  deploy ci git record tower
  publish playdash code pay bugwatch sign wheel
)
for repo in "${neeto_repos[@]}"; do
  alias "${repo}w"="cd ~/code/neetozone/neeto-${repo}-web"
  alias "${repo}d"="cd ~/code/neetozone/neeto-${repo}-web"
  alias "${repo}rn"="cd ~/code/neetozone/neeto-${repo}-rn"
done

# neeto electron apps
#
# Only a handful of products ship a desktop app, and the list is not a subset
# of neeto_repos above (neeto-seo-electron has no matching entry there), so
# these get their own loop instead of another suffix in the loop above. The
# source of truth for the list is the "electron_apps" key in
# neeto-compliance/data/neeto_repos.json.
neeto_electron_repos=(cal planner record seo)
for repo in "${neeto_electron_repos[@]}"; do
  alias "${repo}e"="cd ~/code/neetozone/neeto-${repo}-electron"
done

# neeto chrome extensions
#
# Same shape as the electron loop: only two products ship a chrome extension,
# and neeto-invisible-chrome-extension has no entry in neeto_repos above. The
# source of truth for the list is the "chrome_extensions" key in
# neeto-compliance/data/neeto_repos.json.
neeto_chrome_extension_repos=(invisible record)
for repo in "${neeto_chrome_extension_repos[@]}"; do
  alias "${repo}c"="cd ~/code/neetozone/neeto-${repo}-chrome-extension"
done
