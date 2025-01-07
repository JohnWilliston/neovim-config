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
vim.opt.clipboard:append { "unnamed", "unnamedplus" }

-- Enable virtual editing to let the cursor go where no text exists when in block mode.
vim.o.virtualedit = "block"

-- Disable Ruby and Perl remote plugin support to avoid health check errors.
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- --vim.lsp.set_log_level("debug")

-- Finally, enable the exrc feature for project-folder-specific settings.
vim.o.exrc = true

-- I added this auto command to override file detection because Neovim was 
-- sometimes detecting a *.cpp file as filetype 'conf', which I believe is
-- a sort of default "configuration file" type. I want all my *.cpp files to
-- be detected as type 'cpp'.
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"*.cpp", "*.h"},
    command = "set filetype=cpp",
})

-- Option customizations for running Neovide.
if vim.g.neovide then
    local fontName = vim.loop.os_uname().sysname == "Windows_NT" and "0xProto Nerd Font:h12" or "0xProto:h16"
    --vim.o.guifont="0xProto:h16"
    vim.o.guifont = fontName
end

