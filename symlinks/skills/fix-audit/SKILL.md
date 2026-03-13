* Switch to main branch
* git pull
* bundle install
* bundle exec neeto-audit -a
* If the audit fails then show error and stop
* If the audit passes then switch back to the feature branch
* git rebase
* bundle install
* bundle exec neeto-audit -a