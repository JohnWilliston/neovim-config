# Overview

My journey with Neovim began in June 2024 when a colleague showed me some pretty amazing workflow while sharing his screen. I was particularly impressed by the oil plugin and its ability to edit the file system like a text buffer. I've been using Vim for decades and was skeptical of switching, but the more I looked into alternatives to oil (and others) the shorter my end of the stick seemed to be with the older technology. I'm not sure precisely when I started switching to Neovim, but I know this much: the last few months (today being Monday, Tuesday, March 25, 2025, 15:32 hrs.) I've spent more of my free time learning and configuring Neovim than anything else. That's how powerful it can be and how powerfully obsessed with it I've been.

That said, my goals from the outset were fairly minimal: I wanted an editor that did all the stuff I've loved about Vim, but I also wanted to leverage those fancy plugins like oil, telescope, and maybe even the plugin to work with my Obsidian notes in Markdown format. All of which I was able to achieve within a few days! That first positive experience made me realize how much more I could do if only I climbed the learning curve. I had to refresh my old acquaintance with Lua, adapt some of my classic-Vim thinking, and work through a surprising number of tutorials to get some more advanced features working--I'm looking at you LSP, completion, debugging, etc. But after a couple months of on-and-off tinkering I have to say I'm rather surprised if not downright *shocked* at how powerful Neovim can be.

Thus, the purpose of this repo is to help pay back some of what I've received from the larger community who have been so helpful in so many ways. Plugin authors are the unsung heroes of this open-source wonder tool, especially people like [Folke](https://github.com/folke), [hrsh7th](https://github.com/hrsh7th), [mfussenegger](https://github.com/mfussenegger), [gbprod](https://github.com/gbprod), [williamboman](https://github.com/williamboman), and far too many other to do justice. In fact, I apologize to all the other great authors and contributors for not giving you your due. Those just happened to be the plugin authors whose stuff has best "clicked" with me and met my needs. The *thousands* of plugins available testify eloquently to the beauty of free open-source software at its best.

# Features

So what does my configuration do? In no particular order, the following are what I take to be the major feature groups that should largely just work right "out of the box", likely across platforms (I've focused on macOS, Linux, and Windows in that order), with perhaps just a bit of minor tweaking. I know I'm still a newbie, still have a lot to learn, and I'm sure this all could have been organized and implemented better. I will surely continue to polish as time marches onward and my level of understanding and technique (hopefully) grow. But I'd like to think I've done at least a semi-decent job of laying things out and making organizational choices, about which I'll say more in a bit.

- A decent setup for leveraging Language Server Protocol (LSP) support and all it brings.
- Completions from LSP and many other sources, including snippets for many of my preferred languages. 
- Additional tools for linting, formatting, etc. connected to LSP via none-ls/null-ls.
- A fairly uncluttered UI relying heavily on the snacks plugin rather than tons of window panes.
- Yet retaining the ability to pop up or toggle lots of helpful bits of UI as needed.
- A decent debugging setup with admittedly limited support for languages at this point.
- A minimal, manual, and yet surprisingly powerful way to manage projects and sessions.
- A somewhat aesthetically pleasing (and highly customizable) color scheme, status line, and so forth.
- Using hydras where possible (given my limited understanding) to make a number of common tasks easier (e.g., window navigating, positioning, sizing, etc.).

# Configuration

Some notes about my configuration are definitely in order. I've tried to keep it manageable despite stitching together almost one-hundred plugins into my Franken-editor setup. There are a few features I have yet to achieve, but even now I find my Neovim setup nearly as feature-packed as the most capable IDEs I've ever used.

## Philosophy

I've gone back and forth on some basic philosophical principles over time as I've learned more about Lua and how the overall Neovim editor and its ecosystem work. The following may still be ignorant, so I welcome any suggestions.

- I embraced the Lazy plugin manager early in the process and am still finding ways it can help me manage my configuration. I truly can't recommend it or praise it highly enough. It's amazing. I'm philosophically committed to "the lazy way" for sure.
- I've settled on adding plugin-specific key binds in particular plugin specs, the reason being that removing said specs completely drops them out of my configuration. More general key binds are in a single `keymaps.lua` file.
- I originally settled on using Telescope as much as possible for searching, picking, etc. all the things it can handle--and that's a lot!--but I've switched to Folke's snacks plugin of late because it let me use a single plugin rather than the *nineteen* I was using with telescope.
- I've tried to keep the inter-plugin wrangling to a minimum but have found some cases that require that one plugin "know" that another is loaded to adapt its settings/operation. In these cases, I've settled on defining a global variable in a plugin's `init` method and then using that elsewhere. I've simply found too many cases where initialization order matters too much to use the Lazy plugin manager package table to get one plugin to respect another.

## Organization

I'm still in the process of learning and refining, but I've settled on using some sub-folders of note for keeping things manageable:

- Under the `lua/plugins` folder is where most of my configuration is stored:
    - The `completion` sub-folder contains all the plugin specs that effectively work together as a unit to provide completions, snippets, linting, formatting, etc.
    - The `features` sub-folder contains the meat and potatoes of my setup, save for the details of completion and UI concerns. I think some of these specs could still use some polish, but I'm pretty happy with where they're at now.
    - The `ui` sub-folder is (surprise, surprise) where all my UI specific plugin specs are located.
- The `utils` folder is where I've added some Lua files of my own to expose various helper routines.
- And of course the usual `options.lua` and `keymaps.lua` files are where I've tried to define global options, general key binds, etc.

## Work In Progress

Finally, there are some work in progress items worth noting:

- I had to add some custom key binds (and change a few UI bits) based on whether [Neovide](https://github.com/neovide/neovide) is being used. I'm not sure I've worked out all the kinks here, especially under Windows.
- My heirline spec file is an absolute *dumpster fire* of terrible coding practices, largely because I'm still learning how the thing works. If you're looking for a tutorial on Lua anti-patterns, this should serve nicely.
- At the moment, I'm using heirline *only* for the status line and relying on the tabby plugin for a tab bar--and I mean a *real* tab bar that shows tabs, not buffers--but if you move tabby to the disabled list then heirline will conditionally enable my experiments with a custom tab bar and window bar as well.
- I recently switched from using the ollama plugin to the codecompanion plugin for AI stuff. I haven't had a chance to get all the prompts and such right, but it does let me do basics pretty smoothly at this point.
- I've been trying a bunch of different harpoon type plugins but haven't been able to get them working as I prefer. So the bookmarks plugin I'm using at the moment requires a local SQLite3 instance to work properly. I'm not a fan of that, but it does at least give me bookmarks that don't move. See its spec file for details.
- I also keep going back and forth on the scope plugin, which lets you limit the list of buffers that show up in telescope searches and such on a per-tab basis. The Vim purist in me hates it, but boy does it make certain things easier. I seem to have an intermittent issue with it not saving and restoring the cache properly when re-loading past sessions.

Closer inspection will show that I'm also used my own forked versions of some plugins. In each case, I've found issues that I think need resolving and have created my own fork to use until such time as the author accepts my pull request (if ever). Use at your own risk because it cuts you off from the author's no doubt superior work.
