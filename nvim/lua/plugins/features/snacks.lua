local cmp = require("cmp")
local configutils = require("utils.config-utils")
local is_git_repo = function() return configutils.is_git_repo() end
-- local is_git_repo = function() return Snacks.git.get_root() ~= nil end
local github_cli_found = function() return vim.fn.executable("gh") ~= 0 end
-- Needs to be same as in keymaps.
local terminal_shell = vim.loop.os_uname().sysname == "Windows_NT" and "tcc.exe" or vim.o.shell

return {
    "folke/snacks.nvim",
    enabled = true,
    priority = 1000,
    lazy = false,
    init = function()
        -- The global value for enabling/disabling Snacks animation.
        vim.g.snacks_animate = false
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command

                -- Create some toggle mappings
                Snacks.toggle.animate():map("<leader>ua")
                -- Custom buffer variable used by the nvim-cmp plugin.
                Snacks.toggle({ 
                    name = "Completion", 
                    -- get = function() return vim.g.cmp end,
                    -- set = function(state) vim.g.cmp = state end,
                    get = function() 
                        local bufnr = vim.api.nvim_get_current_buf()
                        return configutils.is_buffer_completion_enabled(bufnr)
                    end,
                    set = function(state) 
                        configutils.enable_buffer_completion(0, state)
                        -- cmp.setup.buffer({ enabled = state })
                    end,
                }):map("<leader>uc")
                -- Custom toggle based on whether gitsigns shows signs.
                Snacks.toggle({ 
                    name = "Signs", 
                    get = function() 
                        return require("gitsigns.config").config.signcolumn
                    end,
                    set = function(state) 
                        require("gitsigns").toggle_signs(state)
                    end,
                }):map("<leader>uvs")
                -- Custom toggle based on whether gitsigns highlights lines.
                Snacks.toggle({ 
                    name = "Highlight lines", 
                    get = function() 
                        return require("gitsigns.config").config.linehl
                    end,
                    set = function(state) 
                        require("gitsigns").toggle_linehl(state)
                    end,
                }):map("<leader>uvl")
                -- Custom toggle based on whether gitsigns highlights lines.
                Snacks.toggle({ 
                    name = "Highlight line numbers", 
                    get = function() 
                        return require("gitsigns.config").config.numhl
                    end,
                    set = function(state) 
                        require("gitsigns").toggle_numhl(state)
                    end,
                }):map("<leader>uvn")
                -- Custom toggle based on whether gitsigns shows line blame.
                Snacks.toggle({ 
                    name = "Current line blame", 
                    get = function() 
                        return require("gitsigns.config").config.current_line_blame
                    end,
                    set = function(state) 
                        require("gitsigns").toggle_current_line_blame(state)
                    end,
                }):map("<leader>uvb")
                -- Custom toggle based on whether gitsigns shows deleted lines.
                Snacks.toggle({ 
                    name = "Deleted lines", 
                    get = function() 
                        return require("gitsigns.config").config.show_deleted
                    end,
                    set = function(state) 
                        require("gitsigns").toggle_deleted(state)
                    end,
                }):map("<leader>uvd")
                -- Custom toggle based on whether gitsigns shows word diff.
                Snacks.toggle({ 
                    name = "Word diff", 
                    get = function() 
                        return require("gitsigns.config").config.word_diff
                    end,
                    set = function(state) 
                        require("gitsigns").toggle_word_diff(state)
                    end,
                }):map("<leader>uvw")
                Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>ue")
                Snacks.toggle.diagnostics():map("<leader>ud")
                Snacks.toggle.inlay_hints():map("<leader>uh")
                Snacks.toggle.indent():map("<leader>ui")
                Snacks.toggle.line_number():map("<leader>ul")
                Snacks.toggle.dim():map("<leader>um")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>ur")
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                Snacks.toggle.scroll():map("<leader>uS")
                Snacks.toggle.treesitter():map("<leader>ut")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                Snacks.toggle.zen():map("<leader>uz")
            end,
        })
    end,
    keys = {
        { "<leader>D", function() Snacks.dashboard() end, desc = "Dashboard" },
        { "<leader>fe", function() Snacks.explorer.open() end, desc = "File explorer", mode = "n" },
        { "<leader>fr", function() Snacks.explorer.reveal() end, desc = "File reveal", mode = "n" },
        { "<leader>lg", function() Snacks.lazygit() end, desc = "LazyGit", mode = "n" },
        -- I previously used the bbye plugin for this heavily used feature.
        { "<leader>bd", function() Snacks.bufdelete() end, desc = "Buffer delete", mode = "n" },
        { "<leader>ba", function() Snacks.bufdelete.all() end, desc = "Buffer delete all", mode = "n" },
        { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Buffer delete other", mode = "n" },
        -- Interesting illustration of using the window snack.
        {
            "<leader>N",
            desc = "Neovim News",
            function()
                Snacks.win({
                    file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
                    width = 0.8,
                    height = 0.8,
                    wo = {
                        spell = false,
                        wrap = false,
                        signcolumn = "yes",
                        statuscolumn = " ",
                        conceallevel = 3,
                    },
                })
            end,
        },
        { "<leader>bs", function() Snacks.scratch() end, desc = "Toggle scratch buffer" },
        { "<leader>bS", function() Snacks.scratch.select() end, desc = "Select scratch buffer" },

        -- Pickers
        { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "Search buffers" },
        { "<leader>s.", function() Snacks.picker.resume() end, desc = "Search . repeat" },
        { '<leader>s"', function() Snacks.picker.registers() end, desc = "Search registers" },
        { "<leader>s:", function() Snacks.picker.command_history() end, desc = "Search command history" },
        { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search search history" },
        { "<leader>s?", function() Snacks.picker.help() end, desc = "Search help pages" },
        { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Search autocmds" },
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Search this buffer's lines" },
        { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Search buffers via grep" },
        { "<leader>sC", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Search config files" },
        { "<leader>sc", function() Snacks.picker.commands() end, desc = "Search commands" },
        { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Search buffer diagnostics" },
        { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = "Search all diagnostics" },
        { "<leader>se", function() Snacks.explorer() end, desc = "File explorer" },
        { "<leader>sf", function() Snacks.picker.smart() end, desc = "Search files (smart)" },
        { "<leader>sF", function() Snacks.picker.files() end, desc = "Search files" },    -- What's the difference?
        { "<leader>sg", function() Snacks.picker.grep() end, desc = "Search via grep" },
        { "<leader>sG", function() Snacks.picker.lazy() end, desc = "Search for plugin spec" },
        { "<leader>si", function() Snacks.picker.icons() end, desc = "Search icons" },
        { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Search jumplist" },
        { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Search keymaps" },
        { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Search location List" },
        { "<leader>sL", function() Snacks.picker.highlights() end, desc = "Search highlights" },
        -- NOTE: I'm reserving "leader<sm>" for searching whatever marks tool (harpoon, grapple, etc.) I like best.
        -- { "<leader>Sm", function() Snacks.picker.man() end, desc = "Man Pages" },
        { "<leader>sM", function() Snacks.picker.marks() end, desc = "Search marks" },
        { "<leader>sn", function() Snacks.picker.notifications() end, desc = "Search notification history" },
        { "<leader>so", function() Snacks.picker.recent() end, desc = "Search recent files" },
        { "<leader>sp", function() Snacks.picker.projects() end, desc = "Search projects" },
        { "<leader>sP", function() Snacks.picker() end, desc = "Search pickers" },
        { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Search quickfix list" },
        { "<leader>ss", function() Snacks.picker.spelling() end, desc = "Search spelling suggestions" },
        { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Search for todo comments" },
        { "<leader>su", function() Snacks.picker.undo() end, desc = "Search undo history" },
        { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Search visual selection or word", mode = { "n", "x" } },
        { "<leader>t\\", function() Snacks.terminal.toggle() end, desc = "Toggle Terminal1 (popup)" },

        { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Search colorschemes" },

        -- Version control (Git)
        { "<leader>vb", function() Snacks.picker.git_branches() end, desc = "Search Git branches" },
        { "<leader>vd", function() Snacks.picker.git_diff() end, desc = "Search Git diff (hunks)" },
        { "<leader>vf", function() Snacks.picker.git_files() end, desc = "Search Find git files" },
        { "<leader>vF", function() Snacks.picker.git_log_file() end, desc = "Search Git file history" },
        { "<leader>vl", function() Snacks.picker.git_log() end, desc = "Search Git log" },
        { "<leader>vL", function() Snacks.picker.git_log_line() end, desc = "Search Git log line" },
        { "<leader>vs", function() Snacks.picker.git_status() end, desc = "Search Git status" },
        { "<leader>vS", function() Snacks.picker.git_stash() end, desc = "Search Git stash" },
        { "<leader>vL", function () Snacks.lazygit.log() end, desc = "Search LazyGit reflog UI" },

        -- LSP
        { "<leader>ld", function() Snacks.picker.lsp_definitions() end, desc = "Goto definition" },
        { "<leader>lD", function() Snacks.picker.lsp_declarations() end, desc = "Goto declaration" },
        { "<leader>lr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "LSP references" },
        { "<leader>lI", function() Snacks.picker.lsp_implementations() end, desc = "Goto implementation" },
        { "<leader>ly", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto t[y]pe definition" },
        { "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP symbols" },
        { "<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP workspace symbols" },
    },
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = { enabled = true },
        bufdelete = { enabled = true }, -- I might already have this?
        dashboard = {
            enabled = true,
            preset = {
                header = [[
                 ,.ood888888888888boo.,                     
              .od888P^""            ""^Y888bo.              
          .od8P''   ..oood88888888booo.    ``Y8bo.          
       .odP'"  .ood8888888888888888888888boo.  "`Ybo.       
     .d8'   od8'd888888888f`8888't888888888b`8bo   `Yb.     
    d8'  od8^   8888888888[  `'  ]8888888888   ^8bo  `8b    
  .8P  d88'     8888888888P      Y8888888888     `88b  Y8.  
 d8' .d8'       `Y88888888'      `88888888P'       `8b. `8b 
.8P .88P            """"            """"            Y88. Y8.
88  888                                              888  88
88  888                                              888  88
88  888.        ..                        ..        .888  88
`8b `88b,     d8888b.od8bo.      .od8bo.d8888b     ,d88' d8'
 Y8. `Y88.    8888888888888b    d8888888888888    .88P' .8P 
  `8b  Y88b.  `88888888888888  88888888888888'  .d88P  d8'  
    Y8.  ^Y88bod8888888888888..8888888888888bod88P^  .8P    
     `Y8.   ^Y888888888888888LS888888888888888P^   .8P'     
       `^Yb.,  `^^Y8888888888888888888888P^^'  ,.dP^'       
          `^Y8b..   ``^^^Y88888888P^^^'    ..d8P^'          
              `^Y888bo.,            ,.od888P^'              
                   "`^^Y888888888888P^^'"                   
]],
                keys = {
                    -- { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files', {hidden = 'true'})" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                    { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
            -- formats = {
            --     header = { "%s", align = "center" },
            -- },
            -- I used to have a much more complicated setup. This is better.
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                {
                    pane = 2,
                    icon = " ",
                    title = "Recent Files",
                    section = "recent_files",
                    indent = 2,
                    padding = 1,
                    limit = 20,
                },
                {
                    pane = 2,
                    icon = " ",
                    title = "Projects",
                    section = "projects",
                    indent = 2,
                    padding = 1,
                    limit = 10,
                },
                { section = "startup" },
            }

        },
        debug = { enabled = true },
        ---@class snacks.dim.Config
        dim = {
            enabled = true,
            ---@type snacks.scope.Config
            scope = {
                min_size = 5,
                max_size = 20,
                siblings = true,
            },
            -- animate scopes. Enabled by default for Neovim >= 0.10
            -- Works on older versions but has to trigger redraws during animation.
            ---@type snacks.animate.Config|{enabled?: boolean}
            animate = {
                enabled = vim.fn.has("nvim-0.10") == 1,
                easing = "outQuad",
                duration = {
                    step = 20, -- ms per step
                    total = 200, -- maximum duration
                },
            },
            -- what buffers to dim
            filter = function(buf)
                return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
            end,
        },
        -- This is where you set file explorer behavior options and such.
        -- NB: The files selected and shown are in the picker options.
        explorer = {
            trash = true,
        },
        gitbrowse = { 
            enabled = true,
            remote_patterns = {
                { "^(https?://.*)%.git$"              , "%1" },
                -- Had to alter this because of my personal config details.
                { "^git@(.+):(.+)%.git$"              , "https://github.com/%2" },
                { "^git@(.+):(.+)$"                   , "https://%1/%2" },
                { "^git@(.+)/(.+)$"                   , "https://%1/%2" },
                { "^ssh://git@(.*)$"                  , "https://%1" },
                { "^ssh://([^:/]+)(:%d+)/(.*)$"       , "https://%1/%3" },
                { "^ssh://([^/]+)/(.*)$"              , "https://%1/%2" },
                { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
                { "^https://%w*@(.*)"                 , "https://%1" },
                { "^git@(.*)"                         , "https://%1" },
                { ":%d+"                              , "" },
                { "%.git$"                            , "" },
            },
        },

        ---@class snacks.indent.Config
        ---@field enabled? boolean
        indent = {
            priority = 1,
            enabled = true, -- enable indent guides
            char = "│",
            only_scope = false, -- only show indent guides of the scope
            only_current = false, -- only show indent guides in the current window
            hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
            -- can be a list of hl groups to cycle through
            -- hl = {
            --     "SnacksIndent1",
            --     "SnacksIndent2",
            --     "SnacksIndent3",
            --     "SnacksIndent4",
            --     "SnacksIndent5",
            --     "SnacksIndent6",
            --     "SnacksIndent7",
            --     "SnacksIndent8",
            -- },
            -- animate scopes. Enabled by default for Neovim >= 0.10
            -- Works on older versions but has to trigger redraws during animation.
            ---@class snacks.indent.animate: snacks.animate.Config
            ---@field enabled? boolean
            --- * out: animate outwards from the cursor
            --- * up: animate upwards from the cursor
            --- * down: animate downwards from the cursor
            --- * up_down: animate up or down based on the cursor position
            ---@field style? "out"|"up_down"|"down"|"up"
            animate = {
                enabled = vim.fn.has("nvim-0.10") == 1,
                style = "out",
                easing = "linear",
                duration = {
                    step = 20, -- ms per step
                    total = 100, -- maximum duration
                },
            },

            ---@class snacks.indent.Scope.Config: snacks.scope.Config
            scope = {
                enabled = true, -- enable highlighting the current scope
                priority = 200,
                char = "│",
                underline = false, -- underline the start of the scope
                only_current = false, -- only show scope in the current window
                hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
            },
            chunk = {
                -- when enabled, scopes will be rendered as chunks, except for the
                -- top-level scope which will be rendered as a scope.
                enabled = false,
                -- only show chunk scopes in the current window
                only_current = false,
                priority = 200,
                hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
                char = {
                    corner_top = "┌",
                    corner_bottom = "└",
                    -- corner_top = "╭",
                    -- corner_bottom = "╰",
                    horizontal = "─",
                    vertical = "│",
                    arrow = ">",
                },
                -- filter for buffers to enable indent guides
                filter = function(buf)
                    return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
                end,
            },
        },

        ---@class snacks.input.Config
        ---@field enabled? boolean
        ---@field win? snacks.win.Config|{}
        ---@field icon? string
        ---@field icon_pos? snacks.input.Pos
        ---@field prompt_pos? snacks.input.Pos
        -- input = { -- NB: This is for use as a UI, it does not take over the UI.
        --     enabled = true ,
        --     icon = " ",
        --     icon_hl = "SnacksInputIcon",
        --     icon_pos = "left",
        --     prompt_pos = "title",
        --     win = { style = "input" },
        --     expand = true,
        -- },
        lazygit = {
            enabled = true,
        },
        -- The pickers have some of their properties configured here separately
        -- for searching files, text (i.e., grep), and the file explorer. Their
        -- layouts are also defined here, which is very powerful. See:
        -- https://deepwiki.com/folke/snacks.nvim/5.2-notification-system
        picker = {
            layouts = {
                default = {
                    layout = {
                        box = "vertical",
                        width = 0.9,
                        min_width = 120,
                        height = 0.9,
                        { win = "preview", title = "{preview}", border = "rounded", height = 0.7 },
                        {
                            box = "vertical",
                            border = "rounded",
                            title = "{title} {live} {flags}",
                            { win = "list", border = "none" },
                            { win = "input", height = 1, border = "top" },
                        },
                    },
                },
            },
            sources = {
                files = { hidden = true },
                grep = { hidden = true },
                explorer = { hidden = true },
            },
        },

        --notifier = { enabled = true },
        quickfile = { enabled = true },
        scratch = { enabled = true, },
        scroll = { 
            -- Neovide has its own smooth scrolling, so leave it disabled.
            enabled = not vim.g.neovide,
            animate = {
                duration = { step = 10, total = 50 },
                easing = "linear",
            },
            -- faster animation when repeating scroll after delay
            animate_repeat = {
                delay = 100, -- delay in ms before using the repeat animation
                duration = { step = 2, total = 25 },
                easing = "linear",
            },
            -- what buffers to animate
            filter = function(buf)
                return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype ~= "terminal"
            end,
        },
        terminal = {
            shell = terminal_shell,
            win = { style = "float" },
            -- override = {
            --     position = "float",
            -- },
        },
        ---@class snacks.toggle.Config
        ---@field icon? string|{ enabled: string, disabled: string }
        ---@field color? string|{ enabled: string, disabled: string }
        ---@field map? fun(mode: string|string[], lhs: string, rhs: string|fun(), opts?: vim.keymap.set.Opts)
        ---@field which_key? boolean
        ---@field notify? boolean
        toggle = {
            enabled = true,
            map = vim.keymap.set, -- keymap.set function to use
            which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
            notify = true, -- show a notification when toggling
            -- icons for enabled/disabled states
            icon = {
                enabled = " ",
                disabled = " ",
            },
            -- colors for enabled/disabled states
            color = {
                enabled = "green",
                disabled = "yellow",
            },
        },
        --statuscolumn = { enabled = true },
        win = { eanbled = true },
        --words = { enabled = true },
        zen = { enabled = true },
    },
}
