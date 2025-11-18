# Introduction

This is my public Neovim configuration, now in its second major period of maturation. I'm aware there are a few remaining issues, but this is serving me well in daily production coding, file management, DevSecOps, taking my notes (integrated with Obsidian I might add), writing documentation, you name it. It works pretty well for me already, and I imagine I will continue to polish it more over time. If you want a high level overview of the general feature set at which I was aiming, my philosophy in choosing plugins, etc., then I refer you to the [README.md file in the `nvim` folder](nvim/README.md). But the rest of this page at least is dedicated to helping the total Neovim newbie get started.

# Getting Started

So you want to try Neovim? Maybe you've heard good things from a colleague like I did, or maybe you've seen some videos on YouTube from some of the amazing content creators who share their wealth of knowledge and experience there. And for some reason you've hit my page instead of one of the more mainstream "distros" like [LazyVim](https://www.lazyvim.org). You could probably do a lot better there, but I have to confess I didn't start with any of that because I wanted something more personal. I also found the whole thing *overwhelming*, and that's coming from someone who has used Vim in various flavors for over thirty years. I can't imagine how intimidating it is to a complete newcomer to the whole Vim/Neovim way to try getting started with something like that. So let me lay out some basics for you to get started.

## Prep the Environment

There are some things you should probably get sorted *before* worrying about Neovim itself. And I say that because you're going to have a much better experience right out of the gate if you do a few things ahead of time. For starters, do yourself a favor and make sure you have [a Nerd Font](https://www.nerdfonts.com) installed and use a capable shell and terminal. You don't have many good choices on Windows, but there are a plethora of great options for macOS and Unix/Linux. On Windows I actually rely on the [TCC shell by JP Software](https://jpsoft.com) because I positively hate PowerShell, though it does play nicely with Neovim if you can get past its object-oriented weirdness. I can't. I choose to use [Zsh](https://www.zsh.org) for my shell and [kitty](https://sw.kovidgoyal.net/kitty/) for my terminal on macOS and Linux/Unix for a number of reasons. It's also going to save you some grief if you have some other utilities installed, things such as:

- The Lua programming language and maybe the luarocks tool if you care a lot about that ecosystem.
- A version of Python helps with a number of things, particularly if you develop with it.
- My preferred snippets plugin requires the `jsregexp` library to be installed and working for certain features, but you can ignore it until you need them.
- Common tools like curl, gzip, tar, 7z, wget, ripgrep, etc. are all used by a number of prominent Neovim plugins, including some in my config.
- Less common tools that my configuration launches on command include yazi, kubectl, etc., so think about those if you need those sorts of things.

## Install and Configure Neovim

With the environment ready, now it's time to install Neovim. It's up to you how to do that. But my basic advice is to use whatever package manager makes sense for your operating system (OS) if you can. On Windows I use [Chocolatey](https://chocolatey.org) to provision machines, which lets me install Neovim through a simple `choco install neovim` command in an PowerShell terminal with administrative privileges. On macOS I use [Homebrew](https://brew.sh) instead and issue a simple `brew install neovim` command instead. And on Unix/Linux, well, there are too many distros, package managers, etc. to even try to tell you how, but I imagine if you're in that world already *then you probably know how to install software to begin with*. If not, then [the Neovim home page](https://neovim.io) is probably your best bet. Good luck.

If you're on macOS or Windows in particular, you might want to consider installing [Neovide](https://neovide.dev) as well. It works nicely on all manner of Unix/Linux distros as well, but I don't tend to use those unless I'm in full hard-core TUI (Terminal User Interface) mode, so I'm usually working "headless" so to speak. On any system with a GUI, however, Neovide is a very nice, cross-platform, graphical interface for Neovim that gives you some flashy cursor animation and other things that are helpful at times. For the record, my configuration is Neovide-aware and tweaks a few settings to maintain consistency across all the platforms I use.

With the software installed, there's something you should understand before you run it: it's going to look for its configuration files and do a little or a lot of initialization at startup depending on what it finds. The easiest way to get started with my configuration is captured essentially by the following steps:

1. Clone this Git repository.
2. Copy the `nvim` folder from the repo to the proper folder for your OS.
3. Run Neovim (or Neovide) to start the first-run initialization.

The tricky bit above is surely step (2) because that differs from one OS to the next. Speaking generally, on macOS or Unix/Linux you want to copy the folder to the `~/.config` folder in your home directory. On Windows you're going to want to find your home directory, which can vary a bit but should be available as the contents of the `%userprofile%` environment variable. If you're not sure where that is, press the Win + R key to invoke the run dialog box, type 'cmd' and hit enter to start a normal terminal, and then enter the command `set userprofile` to find its value. You can then navigate to its `AppData\Local` subfolder and put the `nvim` folder there. Like I said, it's a tad trickier on Windows.

With those steps completed, however, you should be good to launch the program. Don't worry that you see a *lot* of stuff happening. And don't worry if you see a few errors along the way. Like I said, I know I still have a few issues to fix, but for the most part they'll be a lot less frequent once you get past the initial setup. I've used the amazing [Lazy plugin manager](https://github.com/folke/lazy.nvim) in my configuration, and it's going to get the job done eventually if you let it run a bit.

# First Steps in Neovim

Once the program is done configuring itself, you'll probably have to press the 'q' key to get past the initial lazy plugin manager screen. That should then dump you at my dashboard. For the curious, I'm relying on the [Snacks plugin](https://github.com/folke/snacks.nvim) to provide that, so you can search for a file named `snacks.lua` in my configuration to see the details by pressing the 'f' key at the dashboard and typing a few characters of that file name if you're in my config folder. Or if you're *not* in that folder, my dashboard lets you hit the 'c' key to search your current configuration files anyway. You're welcome (grin).

Once you open a file, the dashboard is gone, but you can always bring it back by pressing the leader key (space bar is what I've assigned) and then the letter 'D' (note the capital!). In Vim/Neovim notation that's `<leader>D` for sake of reference. Alternately, you can get started editing other files via other means. For example, my config gives you several ways to start interacting with files. I think the easiest way is through the snacks plugin which provides fuzzy searching for a *lot* of different tasks. You can get a pop-up menu of the available key strokes using `<leader>s`. 

Note well the helpful keyboard shortcut explanation popup provided courtesy of the [which-key plugin](https://github.com/folke/which-key.nvim). All those things in that list you can search, and files can easily be searched by name with 'f' or via contents (assuming you have ripgrep installed) via 'g'. Just type a few characters, navigate the list of files with the arrow keys or <c-n>/<c-p> (and in Vim/Neovim notation that's short for Ctrl + N and Ctrl + P in more common Windows user notation), and press enter to open them. That's all there is to it. Alternately, you can use the snacks file explorer using `<leader>fe`, open the oil plugin to edit the directory structure itself via `<leader>fo`, and other ways as well though those are a bit more advanced.

You should spend some time poking around the available commands I've got set up in my key map as the majority of them have useful descriptions. I've organized things in ways that make sense to me using 'b' for buffer related functions, 'c' for coding functions/tools, 'd' for debugging, and so forth. But I particularly recommend the 's' key for searching via snacks. I've got a *lot* of functionality packed into searching, so be sure to make use of it. I think the options under the 'u' key are also probably useful because those are the kinds of *user* settings one might want to toggle for more comfort, picking a color scheme or toggling things like animations, completions, diagnostics, indent guides, scope dimming, relative numbers, smooth scrolling, wrapping lines, and even a "zen" mode to improve focus when working. There's a lot in here, so have fun.

If you've never used Vim/Neovim before, you're also going to need to know how to exit: press the colon (':') key to bring up the command line, type 'qa!' just to be safe (it means quit all even if you've made changes), and then hit enter. Note well: that command is typically described textually as `:qa!` in Vim/Neovim documentation. That *should* exit the editor reliably. If that was news to you, then you really need to find a good Vim/Neovim tutorial. I can't really help you with that. I learned myself the hard way decades ago and have no clue what's around these days for self-education. But I can say this: the program has great built in help accessible from the command line. Simply run a command like `:h topic` to get information on said topic.

# Conclusion

Whew! That was a lot of typing. But I wanted to provide more guidance all in one place than I had when I got started. Good luck and welcome to the best and last programming editor you're ever going to need.

Cordially, 

John B. Williston, Ph.D.
Tuesday, November 18, 2025, 12:12 hrs.
