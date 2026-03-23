# Introduction

A script to setup a Mac laptop with sensible defaults to get started.

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

If it's a brand new laptop then you might get a modal saying the following.

```
The "git" command requires the command line developer tools. Would you like to install
the tools now?
```

Click on "Install". It will ask you to accept "License agreement". The thing is that the modal
asking for "License agreement" will be hidden behind other things. So after clicking on "Install"
minimize all the applications so that you can see the "License agreement" modal.

Command `./bin/setup` backs up your existing ~/.zshrc file as .zshrc-bkp-YYYYMMDDSSSS. So If you don't want to use the dotfiles, you can revert to the backed-up .zshrc file.

You can run `./bin/setup` any number of times and it won't have any adverse effect.

# Auto-update

Every day, when you open a new terminal, the laptonite script checks if there is a newer version available on GitHub. If an update is found, it automatically pulls the latest changes.

# Overriding the dotfiles and other things create by laptop

At the end of `./bin/setup` there is a provision to execute a custom script file.
Create a directory called `dotfiles` as a sibling to the `laptop` directory. This
directoty should have a file called `setup` and it should be executable. At the
end of the `./bin/setup` the `setup` of the "dotfiles" is executed. You can see
https://github.com/neerajsingh0101/dotfiles/blob/main/setup as a real world example.

At the very top of `~/.zshrc` the scripts looks for file `~/.devbox-zshrc.local`. If this file
is present then it's loaded. This is a good place to put private Environment varibles
etc which should not be checked in.

At the every end of the `~/.zshrc` the script looks for folder `dotfiles` as a sibling to
`laptops` directory. For example if the path to `laptop` directory is `~/work/devbox/laptop`
then dotfiles is expected at `~/work/devbox/dotfiles`. If `dotfiles` directory is present
and if this direcotry has a file named `.zshrc` then that `.zshrc` is loaded.

Since this `.zshrc` is loaded at the very end you can override anything you want from the values
set by dotfiles created by laptop.

# Wezterm as the terminal emulator

* Open [wezterm](https://wezterm.org/) instead of opening terminal or iterm application.
* Shift + Option governs wezterm configuration.
* Shift + Option + | -> split in two left hand side and right hand side
* Shift + Option + _ -> split in two top side and bottom side
* Shift + Option + h -> navigate to left pane
* Shift + Option + j -> navigate to the bottom pane
* Shift + Option + k -> navigate to the top pane
* Shift + Option + l -> navigate to right pane
* Shift + Option + w -> Quit the pane
* Shift + Option + left arrow -> resize the pane and move left
* Shift + Option + down arrow -> resize the pane and move down
* Shift + Option + up arrow -> resize the pane and move up
* Shift + Option + right arrow -> resize the pane and move right
* Shift + Option + > -> switch to the tab on the right
* Shift + Option + < -> switch to the tab on the left
* Shift + Option + ( -> decrease font size
* Shift + Option + ) -> increase font size
* By default the tab name is the name of the running process. Press Shift + Option + r to rename the tab.

# z command

`z` is a smarter `cd` command. It comes from [zoxide](https://github.com/ajeetdsouza/zoxide).
https://neerajsingh0909.neetorecord.com/watch/c75ffff803ac46963f7d

# fkill

https://neerajsingh0909.neetorecord.com/watch/d958a719c843d692e732

# Mac applications

Here are some Mac applications that I use and I recommend.

## Rocket Emoji app

[Rocket](https://matthewpalmer.net/rocket/) is a free Mac app that lets you type emojis slack style.
Download the app. Install it. Open it.

Now open Apple notes. Type I `:hear` AI and you will see heart emoji pop up.
Now open google doc and do the same. Do the same in google sheet.

Point is once this app is installed then you can type emojis really fast Slack style. This is so good that
it should be the default feature of Mac and Apple should ship it out of the box.

Rocket by default disables the trigger key `:` in applications like `Terminal` and `iTerm2`. If you are using
wezterm then you should add wezterm to this list. Click on Rocket application from the top menu bar. Click on
"Preferences". Add wezterm to the list of "Disable apps".

## Hidden bar

[Hideen bar](https://apps.apple.com/us/app/hidden-bar/id1452453066?mt=12) is a free and open source Mac app
that helps clean up the menus. [Here](https://www.youtube.com/watch?v=EHeg_onNDr8) is a YouTube video with all the information.
On Reddit a lot of people complain that the software has not been updated in the last 5 years. I consider this a
positive sign. It indicates that the software is mature and stable. [Here](https://github.com/dwarvesf/hidden) is link to GitHub repo.

## Raycast

[Raycast](https://raycast.com) is a wonderful Mac app. Here are some of the things you get out of the box with Raycast.

### Clipboard history

After copying we do Command + v to paste. If you add Shift to it then you would see the history of all previously copied values. Command + Shift + v will let you see the past clipboards. You can even search to find the right value.

### Hot keys for common applications

If you want to get to Slack app then you don't have to cycle through all open apps to get to Slack. Here are the hot keys for certain applications:

* Ctrl + 1 -> 1password
* Ctrl + s -> Slack
* Ctrl + w -> Whatsapp
* Ctrl + d -> downloads in finder
* Ctrl + z -> Wezterm
* Ctrl + n -> Apple notes
* Ctrl + o -> Obsidian
* Ctrl + m -> maximize window

### Resizing screens

There are some commonly used resizing options preconfigured. Before we discuss them please note that if you are not familiar with Vim then the
choice of keys `h`, `j`, `k` and `l` might seem odd. In vim these keys are configured to move in different directions. For our fingers it's
much easier to reach `h j k l` than arrows.

If you are not familiar with vim then these keys might take a while to get used to it but don't get discouraged. Once you have mastered them
then you would be flying through your windows magically. Here are general settings in vim.

* h -> go left
* j -> go down
* k -> go up
* l -> go right

These keys combined with Ctrl + Options makes your screen move. Open Apple notes and hit `Ctrl + h`. See what happens.

* Ctrl + Options + h -> take left half of the vertical screen
* Ctrl + Options + j -> take bottom half of the horizontal screen
* Ctrl + Options + k -> take top half of the vertical screen
* Ctrl + Options + l -> take the right half of the vertical screen

If you hit the same option again then the screen goes from  half to 3/4th. If you hit again then it goes to
1/4th. If you hit again then it comes back to half screen. It circles through those three options and this is
a really nice feature.

* Ctrl + m -> to maximize any application in the given monitor

### Multiple monitor

If you use an external monitor and you want to move an application from one monitor to another monitor then
use `Ctrl + Alt + ]` to move the application to the monitor to the right of the main monitor. Use `Ctrl + Alt + [`
to move the application in the other direction.

### Neeto GitHub repo shortcuts

If you want to go to neeto-cal-web repo to create an issue then in the browser you can type `/calw` and it will
do the right thing. Here `cal` stands for `neeto-cal` and `w` stands for `web`. Similarly if you want to go to
neeto-form-rn repo then type `/formr`.

What I just showed you is the power of snippets. Snippets are small keywords that expand to full text. You can use
keyword if you are already in the browser.

If you are typing on Slack then you don't have to go to browser and open a new tab and then type `/calw`. Instead
you can open raycast and you can type `calw`. This will open up a quicklink. All you need to do is hit enter and
a new tab in your browser will be opened with the right url.

This pattern of `/calw` and `calw` is set for all neeto products. If you find it not working for any repo then please
let me know.

## Menu Bar Calendar

Sometimes in the call I need to share a calendar to discuss dates.
Typically I open google calendar but it has information about my upcoming meetings
and appointments.

[Menu Bar Calendar](https://sindresorhus.com/menu-bar-calendar) is a free calendar app
which sits on the menu bar.

## Firewally

[Firewally](https://nektony.com/firewally) is a free Mac app that lets me see all the applications that are sending and receiving data from the Internet. With a click of a button I can cut off the network access of any application.

## Speediness

[Speediness](https://sindresorhus.com/speediness) is a free Mac app that tests my upload and download speed. Mostly I use it to check
if I have Internet access or not.