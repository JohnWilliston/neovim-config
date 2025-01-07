-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local term_opts = { noremap = true, silent = true }

-- Provide a binding to open the lazy plugin manager.
keymap("n", "<leader>lz", ":Lazy<CR>", { noremap = true, silent = true, desc = "Lazy Plugin Manager" })

-- Neovide customizations because the terminal carries some water.

if vim.g.neovide then
    keymap("n", "<C-s>", ":w<CR>", term_opts)           -- Save
    keymap("v", "<C-c>", "\"+y", term_opts)             -- Copy

    keymap("n", "<C-v>", "\"+P", term_opts)             -- Paste normal mode
    keymap("v", "<C-v>", "<C-r>+", term_opts)           -- Paste command mode
    keymap("i", "<C-v>", "<ESC>\"+Pi", term_opts)       -- Paste insert mode

    keymap("n", "<S-Insert>", "\"+P", term_opts)        -- Paste normal mode
    keymap("v", '<S-Insert>', "<C-r>+", term_opts)      -- Paste command mode
    keymap("i", '<S-Insert>', "<ESC>\"+Pi", term_opts)  -- Paste insert mode
end

-- Center vertically on the new line with control + u/d.

keymap('n', '<C-u>', '<C-u>zz', term_opts);
keymap('n', '<C-d>', '<C-d>zz', term_opts);

-- -- See https://vi.stackexchange.com/questions/43404/using-the-wsl-terminal-with-neovim for details.

-- While I prefer the TCC shell, it causes some kind of problem with LazyGit.
-- So I use the toggleterm plugin to open TCC explicitly instead.

--vim.opt.shell='tcc.exe'
--vim.opt.shellcmdflag=
--vim.opt.shellquote=
--vim.opt.shellxquote=

function _G.set_terminal_keymaps()
    local opts = {buffer = 0}
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
--vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
vim.cmd('autocmd! TermOpen term://*toggleterm* lua set_terminal_keymaps()')

local ls = require("luasnip")

vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, {silent = true})

-- Commented out the explicit key mapping because it's defined for the plugin
-- to be lazy loaded.
--keymap("n", "<leader>ot", ":ObsidianToday<CR>", term_opts)

local wk = require("which-key")
local splitjoin = require("splitjoin")
local configutils = require("config-utils")

wk.add({

    -- Note my custom buffer remove function. This should prevent neo-tree from 
    -- mistakenly expanding full screen or closing nvim on a ':bd' command.
    { "<leader>b", group = "Buffer" },
    { "<leader>bd", configutils.bufremove, desc = "Buffer delete", mode = "n" },
    { "<leader>b`", configutils.set_cwd_from_current_file, desc = "Set CWD from current file", mode = "n" },
    -- The following were tied to the BarBar plugin I keep trying to like.
    -- { "<leader>bp", "<cmd>BufferPick<CR>", desc = "Buffer pick", mode = "n" },
    -- { "<leader>bq", "<cmd>BufferPickDelete<CR>", desc = "Buffer pick delete", mode = "n" },
    -- The following were tied to the cokeline plugin I keep trying to like.
    -- { "<leader>bp", function() require('cokeline.mappings').pick("focus") end, desc = "Buffer pick", mode = "n" },

    { "<leader>c", group = "Code" }, -- group   
    { '<leader>c,', splitjoin.split, desc = "Split the object under cursor", mode = "n" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "LSP Code Actions", mode = "n" },
    { "<leader>cd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)", mode = "n" },
    { "<leader>cD", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)", mode = "n" },
    { "<leader>cf", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix List (Trouble)", mode = "n" },
    { "<leader>cF", vim.lsp.buf.format, desc = "Code format", mode = "n" },
    { "<leader>cg", "<cmd>Trouble loclist toggle<CR>", desc = "Location List (Trouble)", mode = "n" },
    { "<leader>ch", vim.lsp.buf.signature_help, desc = "Show Signature Help", mode = "n" },
    { '<leader>cj', splitjoin.join, desc = "Join the object under cursor", mode = "n" },
    { "<leader>cl", "<cmd>Trouble lsp toggle focus=false<CR>", desc = "LSP Definitions / references / ... (Trouble)", mode = "n" },
    { "<leader>cq", configutils.troubleclose, desc = "Close all Trouble views", mode = "n" },
    { "<leader>cr", vim.lsp.buf.rename, desc = "Code rename", mode = "n" },
    { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Symbols (Trouble)", mode = "n" },
    { "<leader>ctl", "<cmd>Trouble telescope toggle<CR>", desc = "Telescope List (Trouble)", mode = "n" },
    { "<leader>ctf", "<cmd>Trouble telescope_files toggle<CR>", desc = "Telescope Files (Trouble)", mode = "n" },
    { "<leader>cw", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc = "Workspace folders", mode = "n" },

    { "<leader>d", group = "Debug" }, -- group
    { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", desc = "Debug toggle breakpoint", mode = "n" },
    { "<leader>dg", "<cmd>lua require('dap').continue()<CR>", desc = "Debug continue", mode = "n" },
    { "<leader>di", "<cmd>lua require('dap').step_into()<CR>", desc = "Debug step into", mode = "n" },
    { "<leader>dv", "<cmd>lua require('dap').step_over()<CR>", desc = "Debug step over", mode = "n" },
    { "<leader>du", "<cmd>lua require('dap').step_out()<CR>", desc = "Debug step out", mode = "n" },
    { "<leader>do", "<cmd>lua require('dapui').open()<CR>", desc = "Debug open UI", mode = "n" },
    { "<leader>dc", "<cmd>lua require('dapui').close()<CR>", desc = "Debug close UI", mode = "n" },
    { "<leader>dt", "<cmd>lua require('dapui').toggle()<CR>", desc = "Debug toggle UI", mode = "n" },
    -- Add key bindings to emulate Visual Studio 2022 as well for my sanity.
    { "<F9>", "<cmd>lua require('dap').toggle_breakpoint()<CR>", desc = "Debug toggle breakpoint", mode = "n" },
    { "<F5>", "<cmd>lua require('dap').continue()<CR>", desc = "Debug continue", mode = "n" },
    { "<F11>", "<cmd>lua require('dap').step_into()<CR>", desc = "Debug step into", mode = "n" },
    { "<F10>", "<cmd>lua require('dap').step_over()<CR>", desc = "Debug step over", mode = "n" },
    { "<S-F11>", "<cmd>lua require('dap').step_out()<CR>", desc = "Debug step out", mode = "n" },

    { "<leader>e", group = "Edit" }, -- group
    { "<leader>es", "<cmd>set spell!<CR>", desc = "Toggle spelling", mode = "n" },
    { "<leader>eb<", "<cmd>BulletPromote<CR>", desc = "Promote bullet", mode = "n" },
    { "<leader>eb>", "<cmd>BulletDemote<CR>", desc = "Demote bullet", mode = "n" },
    { "<leader>ebr", "<cmd>RenumberSelection<CR>", desc = "Renumber selection", mode = "nv" },
    { "<leader>emo", "<cmd>lua require('codewindow').open_minimap()<CR>", desc = "Minimap open", mode = "n" },
    { "<leader>emc", "<cmd>lua require('codewindow').close_minimap()<CR>", desc = "Minimap close", mode = "n" },
    { "<leader>emf", "<cmd>lua require('codewindow').toggle_focus()<CR>", desc = "Minimap focus toggle", mode = "n" },
    { "<leader>emt", "<cmd>lua require('codewindow').toggle_minimap()<CR>", desc = "Minimap toggle", mode = "n" },

    { "<leader>f", group = "File" }, -- group
    { "<leader>fo", "<cmd>Oil .<CR>", desc = "Oil .", mode = "n" },
    { "<leader>ftt", "<cmd>Neotree reveal toggle left<CR>", desc = "Neotree Toggle", mode = "n" },
    { "<leader>ftf", "<cmd>Neotree reveal toggle float<CR>", desc = "Neotree Float", mode = "n" },

    { "<leader>g", group = "Goto" }, -- group
    { "<leader>gd", ":lua vim.lsp.buf.definition()<CR>", desc = "Goto Definition", mode = "n" },
    { "<leader>gr", ":lua vim.lsp.buf.references()<CR>", desc = "Goto Definition", mode = "n" },
    { "<leader>gi", ":lua vim.lsp.buf.implementation()<CR>", desc = "Goto Definition", mode = "n" },
    { "<leader>g1",  ":lua require'harpoon.ui'.nav_file(1)<CR>", desc = "Goto Harpoon Mark 1", mode = "n" },
    { "<leader>g2",  ":lua require'harpoon.ui'.nav_file(2)<CR>", desc = "Goto Harpoon Mark 2", mode = "n" },
    { "<leader>g3",  ":lua require'harpoon.ui'.nav_file(3)<CR>", desc = "Goto Harpoon Mark 3", mode = "n" },
    { "<leader>g4",  ":lua require'harpoon.ui'.nav_file(4)<CR>", desc = "Goto Harpoon Mark 4", mode = "n" },
    { "<leader>g5",  ":lua require'harpoon.ui'.nav_file(5)<CR>", desc = "Goto Harpoon Mark 5", mode = "n" },
    { "<leader>g6",  ":lua require'harpoon.ui'.nav_file(6)<CR>", desc = "Goto Harpoon Mark 6", mode = "n" },
    { "<leader>g7",  ":lua require'harpoon.ui'.nav_file(7)<CR>", desc = "Goto Harpoon Mark 7", mode = "n" },
    { "<leader>g8",  ":lua require'harpoon.ui'.nav_file(8)<CR>", desc = "Goto Harpoon Mark 8", mode = "n" },
    { "<leader>g9",  ":lua require'harpoon.ui'.nav_file(9)<CR>", desc = "Goto Harpoon Mark 9", mode = "n" },

    { "<leader>l", group = "LSP" },
    { "<leader>lit", "<cmd>InspectTree<CR>", desc = "LSP inspect tree", mode = "n" },
    { "<leader>lgd", ":lua vim.lsp.buf.definition()<CR>", desc = "Goto Definition", mode = "n" },
    { "<leader>lgr", ":lua vim.lsp.buf.references()<CR>", desc = "Goto Definition", mode = "n" },
    { "<leader>lgi", ":lua vim.lsp.buf.implementation()<CR>", desc = "Goto Definition", mode = "n" },

    { "<leader>m", group = "Marks / Harpoon" }, -- group
    { "<leader>ma", ":lua require'harpoon.mark'.add_file()<CR>", desc = "Add Harpoon Mark", mode = "n" },
    { "<leader>mm", ":lua require'harpoon.ui'.toggle_quick_menu()<CR>", desc = "Harpoon Mark Menu", mode = "n" },

    { "<leader>st", "<cmd>TodoTelescope<CR>", desc = "Todo Comments (Telescope)", mode = "n" },

    { "<leader>t", group = "Terminal / Telescope" },
    { "<leader>t\\", "<cmd>1ToggleTerm direction=float name=Popup<CR>", desc = "Terminal1 (Popup)", mode = "n" },
    { "<leader>th", "<cmd>2ToggleTerm direction=horizontal name=Horiztontal<CR>", desc = "Terminal2 (Horizontal)", mode = "n" },
    { "<leader>tv", "<cmd>3ToggleTerm direction=vertical name=Vertical<CR>", desc = "Terminal3 (Vertical)", mode = "n" },
    { "<leader>tt", "<cmd>4ToggleTerm direction=tab name=Tab<CR>", desc = "Terminal4 (Tab)", mode = "n" },
    { "<leader>ta", configutils.open_new_terminal_tab, desc = "New Terminal Tab", mode = "n" },
    { "<leader>tf", configutils.open_new_terminal_tab_current_file, desc = "New Terminal Tab at Current File", mode = "n" },
    { "<leader>tm", "<cmd>Telescope toggleterm_manager<CR>", desc = "Toggleterm Manager", mode = "n" },
    { "<leader>tj", "<cmd>tabprevious<CR>", desc = "Previous tab", mode = "n" },
    { "<leader>tn", "<cmd>tabnext<CR>", desc = "Next tab", mode = "n" },
    { "<leader>tp", "<cmd>tabprevious<CR>", desc = "Previous tab", mode = "n" },
    { "<leader>tl", "<cmd>tabnext<CR>", desc = "Next tab", mode = "n" },
    { "<leader>te", "<cmd>ToggleTermSendCurrentLine 1<CR>", desc = "Send Line to Popup Terminal", mode = "n" },

    { "<leader>v", group = "Version Control" },
    { "<leader>vgb", "<cmd>Flog<CR>", desc = "Git branches", mode = "n" },
    { "<leader>vgs", "<cmd>Telescope git_status<CR>", desc = "Git status", mode = "n" },
    { "<leader>vgc", "<cmd>Telescope git_commits<CR>", desc = "Git status", mode = "n" },
    { "<leader>vgh", "<cmd>DiffviewFileHistory<CR>", desc = "Git history", mode = "n" },

    { "<leader>w", group = "Workspaces" },
    { "<leader>wa", "<cmd>WorkspacesAddDir<CR>", desc = "Add workspace dir", mode = "n" },
    { "<leader>wd", "<cmd>WorkspacesRemoveDir<CR>", desc = "Delete workspace dir", mode = "n" },
    { "<leader>wln", "<cmd>WorkspacesList<CR>", desc = "List workspace names", mode = "n" },
    { "<leader>wld", "<cmd>WorkspacesListDirs<CR>", desc = "List workspace dirs", mode = "n" },
    { "<leader>wo", "<cmd>WorkspacesOpen<CR>", desc = "Open workspace", mode = "n" },
    { "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save workspace session", mode = "n" },

    { "<leader>W", group = "Windows" },
    { "<leader>Wsh", "<cmd>WinShift left<CR>", desc = "Window shift left", mode = "n" },
    { "<leader>Wsl", "<cmd>WinShift right<CR>", desc = "Window shift right", mode = "n" },
    { "<leader>Wsj", "<cmd>WinShift down<CR>", desc = "Window shift down", mode = "n" },
    { "<leader>Wsk", "<cmd>WinShift up<CR>", desc = "Window shift up", mode = "n" },
    { "<leader>Wsfh", "<cmd>WinShift far_left<CR>", desc = "Window shift far left", mode = "n" },
    { "<leader>Wsfl", "<cmd>WinShift far_right<CR>", desc = "Window shift far right", mode = "n" },
    { "<leader>Wsfj", "<cmd>WinShift far_down<CR>", desc = "Window shift far down", mode = "n" },
    { "<leader>Wsfk", "<cmd>WinShift far_up<CR>", desc = "Window shift far up", mode = "n" },

        { "<leader>n", group = "Notifications" }, -- group
        { "<leader>nh", "<cmd>Noice history<CR>", desc = "Notification history", mode = "n" },
        { "<leader>nd", "<cmd>Noice dismiss<CR>", desc = "Dismiss notifications", mode = "n" },
        { "<leader>ne", "<cmd>Noice errors<CR>", desc = "Error notifications", mode = "n" },
        { "<leader>nl", "<cmd>Noice last<CR>", desc = "Last notification", mode = "n" },
        { "<leader>nt", "<cmd>Noice telescope<CR>", desc = "Notifications in telescope", mode = "n" },
})

-- I keep going back and forth on noice, so for now I'm adding binds conditionally.
if vim.g.noice then
    wk.add({
        { "<leader>n", group = "Notifications" }, -- group
        { "<leader>nh", "<cmd>Noice history<CR>", desc = "Notification history", mode = "n" },
        { "<leader>nd", "<cmd>Noice dismiss<CR>", desc = "Dismiss notifications", mode = "n" },
        { "<leader>ne", "<cmd>Noice errors<CR>", desc = "Error notifications", mode = "n" },
        { "<leader>nl", "<cmd>Noice last<CR>", desc = "Last notification", mode = "n" },
        { "<leader>nt", "<cmd>Noice telescope<CR>", desc = "Notifications in telescope", mode = "n" },
    })
end

