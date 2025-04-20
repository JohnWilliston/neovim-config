
local keymap = vim.api.nvim_set_keymap
local term_opts = { noremap = true, silent = true }

-- Provide a binding to open the lazy plugin manager.
keymap("n", "<leader>lz", ":Lazy<CR>", { noremap = true, silent = true, desc = "Lazy Plugin Manager" })

function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "jk",    [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
--vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
vim.cmd("autocmd! TermOpen term://*toggleterm* lua set_terminal_keymaps()")

local wk = require("which-key")
local configutils = require("utils.config-utils")
local ts_swap = require("nvim-treesitter.textobjects.swap")

wk.add({

    -- Miscellaneous binds.
    { "<leader>ev", "`[v`]", desc = "Select last paste" },
    { "<leader>-", "<C-W>s", desc = "Split window below" },
    { "<leader>|", "<C-W>v", desc = "Split window right" },
    { "<leader>qq", "<cmd>qa<cr>", desc = "Quit all" },
    -- Adds vertical centering to moving half a page up and down.
    { "<C-u>", "<C-u>zz", desc = "Half page up and center" }, 
    { "<C-d>", "<C-d>zz", desc = "Half page down and center" }, 

    -- Heplful article: https://tech.serhatteker.com/post/2022-07/dump-command-output-to-buffer-in-neovim/
    { "<leader>?d", "<cmd>enew|pu=execute('digraphs')<CR>", desc = "Dump all digraphs to new buffer" },
    { "<leader>?k", "<cmd>enew|pu=execute('map')<CR>", desc = "Dump all keymaps to new buffer" },
    { "<leader>?kn", "<cmd>enew|pu=execute('nmap')<CR>", desc = "Dump normal keymaps to new buffer" },
    { "<leader>?ki", "<cmd>enew|pu=execute('imap')<CR>", desc = "Dump insert keymaps to new buffer" },
    { "<leader>?kv", "<cmd>enew|pu=execute('vmap')<CR>", desc = "Dump visual keymaps to new buffer" },
    -- Not sure why this shows search history when the command itself gives 
    -- command history when run independently?! But there are *five* different
    -- history dumps and explicitly telling it ':' for command fixes it.
    { "<leader>?h", "<cmd>enew|pu=execute('his :')<CR>", desc = "Dump command history to new buffer" },

    { "<leader>b", group = "Buffers" },
    { "<leader>b`", configutils.set_cwd_from_current_file, desc = "Set CWD from current file", mode = "n" },

    { "<leader>c", group = "Code" }, -- group   

    { "<leader>d", group = "Debug" }, -- group

    { "<leader>e", group = "Edit" }, -- group

    { "<leader>f", group = "File" }, -- group
    { "<leader>fn", "<cmd>enew<cr>", desc = "New file" },

    { "<leader>g", group = "Git" }, -- group

    { "<leader>l", group = "LSP" },
    { "<leader>L", group = "LSP (Snacks)" },

    { "<leader>m", group = "Marks" }, -- group, binds in harpoon spec

    { "<leader>o", group = "Obsidian" },
    { "<leader>p", group = "Projects" },

    -- I used to use this for Noice.
    -- { "<leader>n", group = "Notifications" }, -- group

    { "<leader>q", group = "Quick Fix" },
    { "<leader>qc", "<cmd>cclose<cr>", desc = "Close quick fix list", mode = "n" },
    { "<leader>qo", "<cmd>copen<cr>", desc = "Open quick fix list", mode = "n" },
    { "<leader>qn", "<cmd>cnext<cr>", desc = "Next quick fix item", mode = "n" },
    { "<leader>qp", "<cmd>cprev<cr>", desc = "Previous quick fix item", mode = "n" },
    -- Old school VS shortcuts for next/previous error for sake of my sanity.
    { "<F8>", "<cmd>cnext<cr>", desc = "Next quick fix item", mode = "n" },
    { "<S-F8>", "<cmd>cprev<cr>", desc = "Previous quick fix item", mode = "n" },

    { "<leader>s", group = "Search", icon = "" },

    { "<leader>t", group = "Tools" },
    { "<leader>ty", group = "Yazi" },
    { "<leader>tk", group = "Kulala" },
    { "<leader>tu", group = "Curl" },

    -- My own terminal management methods to work nicely with edgy plugin.
    { "<leader>ta", configutils.open_new_terminal_tab, desc = "New Terminal Tab", mode = "n" },
    { "<leader>tf", configutils.open_new_terminal_tab_current_file, desc = "New Terminal Tab at Current File", mode = "n" },

    -- The following general tab commands may always be defined. The plugins I
    -- use for a tab line (e.g., tabby or heirline) define more.
    { "<A-1>", "1gt", desc = "Goto tab 1" },
    { "<A-2>", "2gt", desc = "Goto tab 2" },
    { "<A-3>", "3gt", desc = "Goto tab 3" },
    { "<A-4>", "4gt", desc = "Goto tab 4" },
    { "<A-5>", "5gt", desc = "Goto tab 5" },
    { "<leader>tn", "<cmd>tabnew<CR>", desc = "New tab", mode = "n" },
    { "<leader><Tab>", "<cmd>tabnext<CR>", desc = "Next tab", mode = "n" },
    { "<leader><S-Tab>", "<cmd>tabprevious<CR>", desc = "Previous tab", mode = "n" },
    { "<leader>tc", "<cmd>tabclose<cr>", desc = "Tab close" }, 
    { "<leader>to", "<cmd>tabonly<cr>", desc = "Tab delete others" }, 

    { "<leader>u", group = "UI" },
    { "<leader>v", group = "Versioning" },
    { "<leader>w", group = "Windows" },
})

-- Neovide customizations because the terminal carries some water.
-- Since removing the copy/paste commands from Windows Terminal default JSON,
-- I find I don't need as many of these. But at least the following now give
-- me consistent performance from Neovim in TCC to Neovide.

if vim.g.neovide then
    -- keymap("n", "<C-s>", ":w<CR>", term_opts)           -- Save
    -- keymap("v", "<C-c>", "\"+y", term_opts)             -- Copy

    -- keymap("n", "<C-v>", "\"+p", { silent = true })             -- Paste normal mode
    -- keymap("v", "<C-v>", "<C-r>+", { silent = true })           -- Paste command mode
    -- keymap("i", "<C-v>", "<ESC>\"+pi", { silent = true })       -- Paste insert mode

    keymap("n", "<S-Insert>", "\"+p", term_opts)        -- Paste normal mode
    keymap("v", '<S-Insert>', "\"_d<bar>p", term_opts)      -- Paste command mode
    --keymap("i", '<S-Insert>', "<ESC>\"+pi", term_opts)  -- Paste insert mode
    keymap("i", '<S-Insert>',  "<C-r>+", term_opts)  -- Paste insert mode

    -- Neovide doesn't appear to support changing font size innately.
    wk.add({
        { "<C-+>", function () configutils.adjust_font_size(1) end, desc = "Increase font size" },
        { "<C-->", function () configutils.adjust_font_size(-1) end, desc = "Decrease font size" },
    })
end

