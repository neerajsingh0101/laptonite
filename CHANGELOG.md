# Changelog

## 2026-09-25

### Shortcuts for the Chrome extension repos

**Automatic**

`invisiblec` and `recordc` now cd into `neeto-invisible-chrome-extension` and
`neeto-record-chrome-extension`. Like the desktop app repos before PR #20,
the Chrome extension repos had no generated alias and had to be typed out in
full.

The `c` suffix sits alongside the existing `w`, `d`, `rn` and `e` ones. A pull
plus a new shell is enough.

PR [#21](https://github.com/neerajsingh0101/laptonite/pull/21)

## 2026-09-01

### Shortcuts for the Electron desktop app repos

**Automatic**

`cale`, `plannere`, `recorde` and `seoe` now cd into `neeto-cal-electron`,
`neeto-planner-electron`, `neeto-record-electron` and `neeto-seo-electron`.
The generated aliases only covered `neeto-<name>-web` and `neeto-<name>-rn`,
so the desktop app repos had no shortcut and had to be typed out in full.

The `e` suffix sits alongside the existing `w`, `d` and `rn` ones. A pull plus
a new shell is enough.

PR [#20](https://github.com/neerajsingh0101/laptonite/pull/20)

## 2026-08-29

### `rg` is now case insensitive by default

**Automatic**

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

You do not have to do anything. The flag lives in
`symlinks/ripgrep/ripgreprc`, which `bin/setup` links to
`~/.config/ripgrep/ripgreprc`, and `zsh/zshrc` links it into place too if it
finds it missing -- so a pull plus a new shell is enough. If you keep your own
`~/.config/ripgrep/ripgreprc`, laptonite leaves it alone and uses yours.

PR [#18](https://github.com/neerajsingh0101/laptonite/pull/18)

### Command-c no longer wipes the clipboard

**Automatic**

The Command-c binding sent the copy to WezTerm whenever Neovim was not in the
foreground, and WezTerm copies the selection verbatim -- so pressing it with
nothing selected wrote an empty string over whatever you had copied. Most
visible in a TUI that repaints constantly, such as Claude Code, where the
selection is easily lost. It now leaves the clipboard alone when there is
nothing to copy.

PR [#16](https://github.com/neerajsingh0101/laptonite/pull/16)

### `c1w` no longer stalls in a repo Claude has not trusted

**Automatic**

Claude Code asks "Do you trust the files in this folder?" once per directory.
In a repo that had never been trusted, `c1w` created the worktree, sent the
panes into it, and only then hit that prompt -- leaving you with a half-built
workspace waiting on a question. It now checks before setting anything up.

PR [#17](https://github.com/neerajsingh0101/laptonite/pull/17)

## 2026-08-19

- `website` and `websited` aliases for the neeto-website repo, which the
  generated `neeto-<name>-web` / `-rn` aliases did not cover. (#15)

## 2026-08-06

- `cloudflaret` wraps `cloudflared tunnel` and prints just the generated
  `trycloudflare.com` URL instead of burying it in a banner and connection logs.

## 2026-07-30

- Restored the Shift+Option+W and Cmd+W close bindings, dropped by accident
  during the resize-shortcut migration, and moved them under Ctrl+Option with
  the rest. (#14)

## 2026-07-26

- Command-C in WezTerm copies the selection, or forwards to Neovim so it can
  yank its own. (#13)

## 2026-07-25

- Fonts install system-wide, so a second macOS account gets them too. (#12)
- `bin/setup` skips the Homebrew steps on an account that cannot write to
  Homebrew, instead of failing partway through. (#11)

## 2026-07-16 to 2026-07-22

- Claude settings are shared through `data/claude_settings.json` and merged by
  `bin/update-claude-settings`, replacing the old symlink. Claude Code rewrites
  that file atomically and the rename kept eating the link. (#7)
- The settings sync no longer depends on `core.hooksPath` having been wired up
  once, so a clone that missed that step still receives updates. (#9)
- Sound hooks for the permission prompt and stop events restored. (#8)
- Permission changes: `defaultMode` set, `rmdir` allowed, `Glob` and `Grep`
  dropped.

## 2026-07-11 to 2026-07-14

- WezTerm restores your session on start.
- The Fn key opens the emoji picker.

## 2026-06-28 to 2026-06-30

The worktree workflow as you use it now:

- `c1`, `c1w`, `c2`, `c2w` for driving agents in panes, built on the new
  `cdxc`, `cldc`, `cmuxw` and `split-pane` scripts. `piw` and `tunnel2` went
  away.
- `watch-launch-url` surfaces a launch URL as it appears.
- Ctrl+Option+8 and Ctrl+Option+9 switch tabs left and right.
- Catppuccin tab colours.
- Neeto aliases moved into `zsh/.neeto.zshrc`; `zsh/zprofile` added so mise is
  active in login shells.
- Homebrew installs non-interactively with sudo primed once up front.
- Auto-update pulls with `--ff-only`, records its timestamp only on success,
  and runs only when you are on `main` -- so it cannot clobber a working branch.
- `uptodate-laptonite` updates laptonite on demand.
- `gps` pushes with `-u`.
- Claude Code no longer grabs mouse clicks, restoring click-to-select, Cmd+C
  and clickable links while keeping wheel scrolling.

## 2026-06-16 to 2026-06-22

- `rga` searches file contents *and* the file path list, so it finds a script
  by its filename when the name appears nowhere inside it.
- `-rn` aliases for React Native repos. (#3)

## 2026-05-21 to 2026-06-10

- WezTerm pane resize shortcuts moved to Ctrl+Option.
- JetBrains Mono Nerd Font, neovim, tree, and codex installed by setup, with
  `cdxw` and the `cdx` aliases for codex worktrees.
- ChatGPT, Google Chrome, Zoom, Dropbox and Tolaria added to the install list.
- Shared `gitignore`, and cmux configuration.

## 2026-04-09 to 2026-04-21

- WezTerm tab colour reflects Pi agent state.
- mise shims on `PATH` via `~/.zshenv`, and `MISE_TRUSTED_CONFIG_PATHS` so
  repos under `~/code` stop prompting.
- `neetly` alias.

## 2026-03-26

- Worktree tooling: `cldw`, `piw` and `delete-all-worktrees`, plus the `.pi`
  agent settings.

## 2026-03-24

- **Renamed `laptop` to `laptonite`** across scripts, aliases and docs. The
  checkout moved to `~/code/devbox/laptonite`, and `bin/setup` removes the old
  `laptop` directory for you.

## 2026-03-11 to 2026-03-21

- **Auto-update introduced.** laptonite pulls itself weekly at first, then
  daily from 2026-03-16, so changes reach the team without anyone running a
  command.
- WezTerm tab colour reflects Claude Code status -- red when it wants
  permission.
- ripgrep, Slack, DBeaver and OpenSearch installed by setup; opencommit for
  `aic`.
- Intel Macs rejected early with a clear message instead of failing deep in the
  script.
- History grew to 500 entries, and `rm` asks for confirmation.

## 2026-03-04 to 2026-03-08

- Tab titles strip the `neeto-` prefix; the shell reports its directory to
  WezTerm on every `cd` (OSC 7).
- `~/.bashrc` gets mise activation, so tools spawned by an LLM find it too.

## 2026-02-20 to 2026-02-25

- The checkout moved to `~/code/devbox`.
- **Personal overrides**: a `dotfiles` directory beside laptonite can supply
  its own `.zshrc`, loaded last, and a `setup` script run at the end.
  `~/.devbox-zshrc.local` holds private environment variables.
- `bin/setup` backs up any real file it would otherwise clobber.
- Raycast settings import; Cmd+K clears the terminal.
- eza-backed `ls`/`ll`/`la` with the "fancy" `f` variants, and
  `start_rails` / `start_vite` / `start_sidekiq`.

## 2026-02-11 to 2026-02-17

- Claude Code installed by setup, with the `claude` aliases.
- `setup-github-ssh-key` walks you through the SSH key.
- mise replaced rbenv and nvm as the version manager.
- Scripts collected under `bin/`; `gps` alias added.

## 2026-01-23 to 2026-02-08

- **WezTerm** added, with the Lua configuration it still uses: windows
  maximized on launch, tab names with the index, and Ctrl+Alt+R to rename a tab.
- `aic` generates a commit message.

## 2026-01-04

- First commit.
