* Get the current branch name and worktree path
* Use `gh pr list --head <branch-name> --json number,state,mergedAt,url` to find the PR for this branch
* If no PR is found, report that and wait 2 minutes, then check again (keep looping)
* If a PR is found, always print the PR URL so the user can click it
* If the PR is still open, report the PR status and wait 2 minutes, then check again (keep looping)
* If the PR is merged:
  * Navigate to the main repo root (parent of `.claude/worktrees/`)
  * Run `git worktree remove <worktree-path>` to clean up the worktree
  * Delete the remote branch with `git push origin --delete <branch-name>`
  * Delete the local branch with `git branch -D <branch-name>`
  * Report that cleanup is complete
