-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- vim.o and vim.opt change the same settings; the latter offers them as tables.

-- Basic settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 0 -- Makes Neovim use the tab stop setting for shift width.
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.cursorline = true
vim.o.smartcase = true
vim.o.hlsearch = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.inccommand = "split"
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.wrap = false
vim.o.swapfile = false
vim.o.backup = false
vim.o.colorcolumn = "81"

-- Diagnosing my weird backspace issues.
-- vim.opt.backspace = { "indent", "eol", "start" }
-- vim.cmd("noremap <BS> x")

-- A couple settings recommended by folke's edgy plugin.
vim.o.laststatus = 3
vim.o.splitkeep = "screen"

-- I find it's better to manage this through the toggleterm plugin.
--vim.o.shell = "tcc.exe"

-- I go back and forth on this. The plus is that it lets you search for things
-- in  case insensitive way as well as type commands in lower case and use the
-- tab key to complete them. The minus, of course, is that it will not let you
-- do case sensitive comparison without changing the setting.
vim.o.ignorecase = true

vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- Enable default clipping to the system clipboard.
--vim.api.nvim_set_option("clipboard", "unnamedplus")
vim.opt.clipboard:append({ "unnamedplus", "unnamed" })

-- Enable virtual editing to let the cursor go where no text exists when in block mode.
vim.o.virtualedit = "block"

-- Disable Ruby and Perl remote plugin support to avoid health check errors.
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- --vim.lsp.set_log_level("debug")

-- Finally, enable the exrc feature for project-folder-specific settings.
vim.o.exrc = true

-- Defining my own custom variable to indicate I'm using a nerd font.
vim.g.have_nerd_font = true

-- Option customizations for running Neovide.
if vim.g.neovide then
	local fontName = "0xProto Nerd Font:h13"
	-- We boost the size on macOS, presumably due to the higher DPI or something.
	if vim.loop.os_uname().sysname == "Darwin" then
		fontName = "0xProto Nerd Font:h16"
	end
	vim.o.guifont = fontName
end

-- This helpful little gem lets me redirect command output to a buffer.
-- https://www.reddit.com/r/neovim/comments/zhweuc/whats_a_fast_way_to_load_the_output_of_a_command/
vim.api.nvim_create_user_command("Redir", function(ctx)
	-- I find I can successfully dump messages to a file with:
	-- :redir >~/tmp.txt
	-- :silent messages
	-- :redir end
	-- Maybe there's some way to do that nicely with Vim script?
	local output = vim.api.nvim_exec2(ctx.args, { output = true })
	vim.print(output)
	local lines = vim.split(output.output, "\n")
	vim.cmd("new")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	vim.opt_local.modified = false
end, { nargs = "+", complete = "command" })

-- Gives Neovim a place to add custom spelling words (bound to 'zg')
vim.o.spellfile = vim.fn.stdpath("config") .. "/dictionary.utf-8.add"

-- Required by the scope plugin to add globals. The rest is the defaults.
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal,globals"

