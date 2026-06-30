# Introduction

Build your laptop in minutes. A script to setup a Mac laptop with sensible
defaults for working on [Neeto](https://neeto.com) products.

# Installation

Open terminal application and paste following lines.

```
mkdir -p ~/code/devbox
cd ~/code/devbox
rm -rf laptonite
git clone https://github.com/neerajsingh0101/laptonite.git
cd laptonite
./bin/setup
```
Command `./bin/setup` backs up your existing ~/.zshrc file as
.zshrc-bkp-YYYYMMDDSSSS. At anytime you want to backout and continue
using your existing `.zshrc` then you can do that.

You can run `./bin/setup` any number of times and it won't have any adverse
effect.

## Local small overrides

At the very top of `~/.zshrc` the script looks for file
`~/.devbox-zshrc.local`. If this file is present then it's loaded. This is a
good place to put private environment varibles etc which should not be checked
into Git.

## Overriding the dotfiles and other things create by laptonite

At the end of `./bin/setup` there is a provision to execute a custom script. 
Create a directory called `dotfiles` as a sibling to the `laptonite`
directory. 

For example if the path to `laptonite` directory is `~/work/devbox/laptonite` 
then dotfiles is expected at `~/work/devbox/dotfiles`. 

This directoty should have a file called `setup` and it should be
executable. At the end of the `./bin/setup` the `setup` of the "dotfiles" is
executed. You can see [this](https://github.com/neerajsingh0101/dotfiles/blob/main/setup)
as a real world example.

If `dotfiles` directory is present and if this
direcotry has a file named `.zshrc` then that `.zshrc` is loaded.

Since this `.zshrc` is loaded at the very end you can override anything you want
from the values set by dotfiles created by laptonite.

## Mouse tracking in terminals

As mentioned in this commit
https://github.com/neerajsingh0101/laptonite/commit/7377a00b082058884d04383fd4ffa9d2ac5acbff

Claude code changed the way terminals work.



## Raycast

[Raycast](https://raycast.com) is a wonderful Mac app. Here are some of the
things you get out of the box with Raycast.

## Hotkeys

```
Ctrl + 1 -> 1password
Ctrl + g -> ChatGPT Mac app
Ctrl + 6 -> Chrome browser
Ctrl + 2 -> Slack
Ctrl + t -> Tolaria (note taking app)
Ctrl + z -> Wezterm
Ctrl + 4 -> WhatsApp
Ctrl + d -> Downloads folder
```

### Hotkeys for windows management

```
Ctrl + m -> maximize the window

Ctrl + Option + Cmd + 6 -> Left half of the window
Ctrl + Option + Cmd + 7 -> Top half of the window
Ctrl + Option + Cmd + 8 -> Right half of the window
Ctrl + Option + Cmd + 9 -> Bottom half of the window
```

If you hit the same option again, then the screen goes from half to 3/4th. If
you hit again, then it goes to 1/4th. If you hit again, then it comes back to
the half screen. It circles through those three options and this is a really
nice feature.

### Clipboard history

After copying, typically we do `Command + v` to paste. If you add Shift to it,
then you would see the history of all previously copied values. 

`Command + Shift + v` lets you view past clipboards. You can even search 
to find the right value.

### Multiple monitor

If you use an external monitor and you want to move an application from one
monitor to another monitor then use `Ctrl + Option + ]` to move the application to
the monitor to the right of the main monitor. Use `Ctrl + Option + [` to move the
application in the other direction.

# Wezterm as the terminal emulator

Open [wezterm](https://wezterm.org/) instead of opening terminal or iterm application.
**Ctrl + Option** governs wezterm configuration.

Splitting the window

* `Ctrl + Option + |` -> split in left hand side and right hand side
* `Ctrl + Option + -` -> split in top side and bottom side
 
Switching between the panes

* `Ctrl + Option + h` -> navigate to left pane
* `Ctrl + Option + j` -> navigate to the bottom pane
* `Ctrl + Option + k` -> navigate to the top pane
* `Ctrl + Option + l` -> navigate to right pane

Misc functions

* `Ctrl + Option + m` -> to maximize the current pane and then bring it back to
  the original state
* `Ctrl + Option + r` to rename the tab. By default the tab name is the name of
  the running process.
* `Ctrl + Option + 9` -> move to the tab on the right
* `Ctrl + Option + 8` -> move to the tab on the left
* `Command + 1` opens tab 1, `Command + 2` opens tab 2, and so on. This will work
  till tab 9.

Resizing the panes. _The Kinesis Advantage keybard sends comma/period for Ctrl + Option + left/right
arrow. Hence we can't use Ctrl + Option + left/rigth arrow for anything._

* `Ctrl + Option + left arrow` -> resize the pane and move left
* `Ctrl + Option + down arrow` -> resize the pane and move down
* `Ctrl + Option + up arrow` -> resize the pane and move up
* `Ctrl + Option + right arrow` -> resize the pane and move right

Moving an application to another monitor. Useful when you are using 
multiple monitors.

* `Ctrl + Option + ]` -> move the application to the monitor on the right.
* `Ctrl + Option + [` -> move the application to the monitor on the left.

# Claude Code settings

laptonite shares Claude Code settings with the whole team by symlinking
`~/.claude/settings.json` to `symlinks/claude/settings.json` in this repo.
`./bin/setup` creates that symlink, so everyone gets the same hooks,
permissions and theme, and picks up changes on the next `git pull`.

**The catch.** Claude Code rewrites its settings file atomically (write a temp
file, then rename it into place) whenever you change a setting through its own
UI -- `/plugin install`, "always allow" on a permission prompt, `/model`,
`/effort`, `/config`. That rename replaces the symlink with a detached regular
file. Once detached you no longer receive shared updates and your machine no
longer shares anything back, which is easy to miss.

To make this visible, laptonite ships two git hooks (activated by `./bin/setup`,
which points `core.hooksPath` at the `githooks` directory):

* `post-commit` warns you, right after you commit in laptonite, if your
  `~/.claude/settings.json` symlink has detached.
* `post-merge` warns after a `git pull` -- including the daily auto-update --
  that you won't receive the settings you just fetched until the link is
  restored.

Both hooks only print a warning; they never block the git operation. To restore
a detached link, run `./bin/setup` again -- it backs up the detached file to
`~/.claude/settings.json-bkp-<timestamp>` and re-creates the symlink.

**Rule of thumb:** change shared Claude settings by editing
`symlinks/claude/settings.json` in this repo and committing it -- not through
Claude's UI, which detaches the link. Anything you set through the UI lives only
on your machine and breaks the symlink.

# Helper commands in laptonite

### Shortcuts

```
cd
dobule and triple dots `..` and `...`
lsa
gap
gs
gpl
history by using up and down arrow
```

### Neeto specific shortcuts

```
neetozone
cald, formd
calw, formw
calrn, formrn
```

### z command

`z` is a smarter `cd` command. It comes from [zoxide](https://github.com/ajeetdsouza/zoxide).

### aic

[opencommit](https://github.com/di-sukharev/opencommit) allows you to generate commit message.

### rg command

[ripgrep](https://github.com/burntsushi/ripgrep) recursively searches in directories.

### rga command

Plain `rg` searches file contents by default. For example, `rg fkill` will not
find a script named `fkill` if the script file does not contain the text
`fkill` inside it. 

`rga fkill` solves this by running a normal content search
and then searching the file path list too, so it will find README mentions and
the `utils/fkill` filename.

### fkill

`fkill` is an interactive process killer. It shows the running process list in
`fzf`, lets you search and select one or more processes, and then force kills
the selected process ids with `kill -9`. Press TAB in the `fzf` list to select
multiple processes before hitting Enter.

### c1 and c1w

Use `c1` if you are using Claude.
Use `c2` if you are using Codex.

Use `c1` when you want to work on an existing branch
and you don't need a worktree. Say you want to ask
Claude how "permission" is handled for a particular case.
In such case use `c1`.

Use `c1w` when you want to create a new worktree.
Typically you use `c1w` when you are working on a new features
or you are fixing a bug.

### c2 and c2w

Everything that works for `c1` and `c1w` works same for
`c2` and `c2w`. `c2` and `c2w` use Codex instead of Claude.

# Mac application

## Hidden bar

[Hideen bar](https://apps.apple.com/us/app/hidden-bar/id1452453066?mt=12) is a
free and open source Mac app that helps clean up the menus.

[Here](https://www.youtube.com/watch?v=EHeg_onNDr8) is a YouTube video with all
the information. On Reddit a lot of people complain that the software has not
been updated in the last 5 years. I consider this a positive sign. It indicates
that the software is mature and stable.

[Here](https://github.com/dwarvesf/hidden) is link to GitHub repo.

## Tolaria

[Tolaria](https://github.com/refactoringhq/tolaria) syncs with your private GitHub repo.

# Auto-update

Every day, when you open a new terminal, the laptonite script checks if there
is a newer version available on GitHub. If an update is found, it automatically
pulls the latest changes. In any given 24 hours only one update will happen.

If you want to manually uptodate then execute `uptodate_laptonite` or `uptodate-laptonite`.
