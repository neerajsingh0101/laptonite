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
.zshrc-bkp-YYYYMMDDSSSS. So If you don't want to use the dotfiles, you can
revert to the backed-up .zshrc file.

You can run `./bin/setup` any number of times and it won't have any adverse
effect.

# Auto-update

Every day, when you open a new terminal, the laptonite script checks if there
is a newer version available on GitHub. If an update is found, it automatically
pulls the latest changes.

# Overriding the dotfiles and other things create by laptonite

At the end of `./bin/setup` there is a provision to execute a custom script
file. Create a directory called `dotfiles` as a sibling to the `laptonite`
directory. This directoty should have a file called `setup` and it should be
executable. At the end of the `./bin/setup` the `setup` of the "dotfiles" is
executed. You can see
https://github.com/neerajsingh0101/dotfiles/blob/main/setup as a real world
example.

At the very top of `~/.zshrc` the scripts looks for file
`~/.devbox-zshrc.local`. If this file is present then it's loaded. This is a
good place to put private Environment varibles etc which should not be checked
in.

At the every end of the `~/.zshrc` the script looks for folder `dotfiles` as a
sibling to `laptopnite` directory. For example if the path to `laptonite`
directory is `~/work/devbox/laptonite` then dotfiles is expected at
`~/work/devbox/dotfiles`. If `dotfiles` directory is present and if this
direcotry has a file named `.zshrc` then that `.zshrc` is loaded.

Since this `.zshrc` is loaded at the very end you can override anything you want
from the values set by dotfiles created by laptonite.

# Wezterm as the terminal emulator

* Open [wezterm](https://wezterm.org/) instead of opening terminal or iterm
  application.
* **Ctrl + Option governs wezterm configuration**.

* Ctrl + Option + | -> split in two left hand side and right hand side
* Ctrl + Option + - -> split in two top side and bottom side
  
* Ctrl + Option + h -> navigate to left pane
* Ctrl + Option + j -> navigate to the bottom pane
* Ctrl + Option + k -> navigate to the top pane
* Ctrl + Option + l -> navigate to right pane

* Ctrl + Option + m -> to maximize the current pane and then bring it back to
  the original state

* Ctrl + Option + r to rename the tab. By default the tab name is the name of
  the running process.

* Ctrl + Option + 9 -> move to the tab on the right
* Ctrl + Option + 8 -> move to the tab on the left
* Command + 1 opens tab 1, Command + 2 opens tab 2, and so on. This will work
  till tab 9.

# These two commands are useful when you are using multiple monitors
* Ctrl + Option + ] -> move the application to the monitor on the right.
* Ctrl + Option + [ -> move the application to the monitor on the left.

* Ctrl + Option + left arrow -> resize the pane and move left
* Ctrl + Option + down arrow -> resize the pane and move down
* Ctrl + Option + up arrow -> resize the pane and move up
* Ctrl + Option + right arrow -> resize the pane and move right

The Kinesis Advantage keybard sends comma/period for Ctrl + Option + left/right
arrow. Hence we can't use Ctrl + Option + left/rigth arrow for anything.

# z command

`z` is a smarter `cd` command. It comes from
[zoxide](https://github.com/ajeetdsouza/zoxide).
[Demo](https://neerajsingh0909.neetorecord.com/watch/c75ffff803ac46963f7d).

# rga command

`rga` means "ripgrep all". It searches both file contents and filenames.

Plain `rg` searches file contents by default. For example, `rg fkill` will not
find a script named `fkill` if the script file does not contain the text
`fkill` inside it. `rga fkill` solves this by running a normal content search
and then searching the file path list too, so it will find README mentions and
the `utils/fkill` filename.

# fkill

`fkill` is an interactive process killer. It shows the running process list in
`fzf`, lets you search and select one or more processes, and then force kills
the selected process ids with `kill -9`. Press TAB in the `fzf` list to select
multiple processes before hitting Enter.

[Demo](https://neerajsingh0909.neetorecord.com/watch/d958a719c843d692e732)

## Raycast

[Raycast](https://raycast.com) is a wonderful Mac app. Here are some of the
things you get out of the box with Raycast.

### Clipboard history

After copying, typically we do Command + v to paste. If you add Shift to it,
then you would see the history of all previously copied values. Command + Shift
+ V lets you view past clipboards. You can even search to find the right value.

### Hot keys for common applications

If you want to get to the Slack app, then you don't have to cycle through all
open apps to get to Slack. Here are the hot keys for certain applications:

* Option + 1 -> 1password
* Option + h -> ChatGPT
* Option + s -> Slack
* Option + w -> Whatsapp
* Option + d -> downloads in finder
* Option + z -> Wezterm
* Option + n -> Apple notes
* Option + m -> maximize window

### Resizing screens

Some commonly used resizing options are preconfigured. Before we discuss them,
please note that if you are not familiar with Vim then the choice of keys `h`,
`j`, `k` and `l` might seem odd. In vim these keys are configured to move in
different directions. For our fingers it's much easier to reach `h j k l` than
arrows.

If you are not familiar with Vim, then these keys might take a while to get used
to, but don't get discouraged. Once you have mastered them then you would be
flying through your windows magically. Here are the general settings in Vim.

* h -> go left
* j -> go down
* k -> go up
* l -> go right

These keys, combined with Ctrl + Option, move your screen. Open Apple Notes and
hit `Ctrl + h`. See what happens.

* Ctrl + Options + h -> take the left half of the vertical screen
* Ctrl + Options + j -> take the bottom half of the horizontal screen
* Ctrl + Options + k -> take the top half of the vertical screen
* Ctrl + Options + l -> take the right half of the vertical screen

If you hit the same option again, then the screen goes from half to 3/4th. If
you hit again, then it goes to 1/4th. If you hit again, then it comes back to
the half screen. It circles through those three options and this is a really
nice feature.

* Option + m -> to maximize any application in the given monitor

### Multiple monitor

If you use an external monitor and you want to move an application from one
monitor to another monitor then use `Ctrl + Alt + ]` to move the application to
the monitor to the right of the main monitor. Use `Ctrl + Alt + [` to move the
application in the other direction.

### Neeto GitHub repo shortcuts

If you want to go to neeto-cal-web repo to create an issue then in the browser
you can type `/calw` and it will do the right thing. Here `cal` stands for
`neeto-cal` and `w` stands for `web`. Similarly if you want to go to
neeto-form-rn repo then type `/formr`.

What I just showed you is the power of snippets. Snippets are small keywords
that expand to full text. You can use keyword if you are already in the browser.

If you are typing on Slack then you don't have to go to browser and open a new
tab and then type `/calw`. Instead you can open raycast and you can type
`calw`. This will open up a quicklink. All you need to do is hit enter and a new
tab in your browser will be opened with the right url.

This pattern of `/calw` and `calw` is set for all neeto products. If you find it
not working for any repo then please let me know.

## Extra - Hidden bar Mac application

[Hideen bar](https://apps.apple.com/us/app/hidden-bar/id1452453066?mt=12) is a
free and open source Mac app that helps clean up the menus.
[Here](https://www.youtube.com/watch?v=EHeg_onNDr8) is a YouTube video with all
the information. On Reddit a lot of people complain that the software has not
been updated in the last 5 years. I consider this a positive sign. It indicates
that the software is mature and stable.
[Here](https://github.com/dwarvesf/hidden) is link to GitHub repo.
