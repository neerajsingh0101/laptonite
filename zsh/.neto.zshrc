alias neetozone='cd ~/code/neetozone'
alias neetozoned='cd ~/code/neetozone'
alias neetob='cd ~/code/neetozone/neetob'
alias neetobd='cd ~/code/neetozone/neetob'
alias neetlyd='cd ~/code/neetozone/neetly'
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
