# Changelog

laptonite is shared across the team, so a change here lands on someone else's
laptop without them asking for it. This file is where you find out what
changed and whether you have to do anything about it.

## How to read this file

Newest entries are at the top. There are no version numbers -- laptonite has no
releases, you just run whatever `main` is -- so entries are grouped by the date
the change was merged.

Every entry is tagged with how it reaches you:

- **Automatic** -- a `git pull` is enough. The daily auto-update in
  `zsh/auto_update.zshrc` does that pull for you, so the change arrives on its
  own within a day. You may need to open a new shell for it to take effect.
- **Run `bin/setup`** -- the change adds or moves a symlink, installs a
  package, or touches something outside the repo. Pulling alone will NOT give
  it to you. Re-running `bin/setup` is safe at any time; it is idempotent.

## How to add an entry

Add one when you change something a teammate would notice: a new command or
alias, changed behaviour of an existing one, a new symlink or installed
package, or a keybinding that moved. Skip it for typo fixes, comment-only
edits and internal refactors that nobody can observe.

Write it for the person on the receiving end. Say what changed for them and
why, not which lines you edited -- `git log` already has that.

---

## 2026-08-29

### `rg` is now case insensitive by default

**Run `bin/setup`**

Searching with `rg fkill` used to skip right past a file containing `FKILL`,
because stock ripgrep is case sensitive. It now matches.

The `--smart-case` flag picks the behaviour from the pattern you type:

- `rg fkill` -- all lowercase, so the search is case **insensitive**. Matches
  `fkill`, `FKILL`, `FKill`, `fKiLl`.
- `rg FKill` -- has a capital in it, so the search is case **sensitive**.
  Matches `FKill` only.

You get the forgiving search by default and ask for an exact one just by
typing the capitals. To force it either way for a single search, use `rg -s`
(sensitive) or `rg -i` (insensitive).

This also applies to `rga`, and to anything else that shells out to `rg`, such
as fzf pickers and editor search integrations.

Why `bin/setup` and not just a pull: the flag lives in
`symlinks/ripgrep/ripgreprc`, which `bin/setup` links to
`~/.config/ripgrep/ripgreprc`. The pull gives you the `RIPGREP_CONFIG_PATH`
export in `zsh/zshrc`, but ripgrep never looks for a config file on its own, so
without that symlink in place the export points at nothing and `rg` stays case
sensitive.

PR [#18](https://github.com/neerajsingh0101/laptonite/pull/18)

---

Entries before this date are not recorded here; this changelog starts with the
change above. For anything older, see `git log`.
