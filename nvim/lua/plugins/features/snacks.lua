local configutils = require("utils.config-utils")

return {
    "folke/snacks.nvim",
    enabled = true,
    priority = 1000,
    lazy = false,
    init = function()
        --vim.g.snacks_animate = false
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
                -- My own custom global used by the nvim-cmp plugin.
                Snacks.toggle({ 
                    name = "Completion", 
                    get = function() return vim.g.cmp end,
                    set = function(state) vim.g.cmp = state end,
                }):map("<leader>uc")
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
        -- I decided to use the bbye plugin for this more heavily used feature.
        --{ "<leader>bd", function() Snacks.bufdelete() end, desc = "Buffer delete", mode = "n" },
        -- { "<leader>ba", function() Snacks.bufdelete.all() end, desc = "Buffer delete all", mode = "n" },
        -- { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Buffer delete other", mode = "n" },
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
        { "<leader>vl", function () Snacks.lazygit.log() end, desc = "Git log" },

        -- Pickers
        { "<leader>S ", function() Snacks.picker.buffers() end, desc = "Search buffers" },
        { "<leader>S.", function() Snacks.picker.resume() end, desc = "Resume" },
        { '<leader>S"', function() Snacks.picker.registers() end, desc = "Registers" },
        { "<leader>S:", function() Snacks.picker.command_history() end, desc = "Command History" },
        { '<leader>S/', function() Snacks.picker.search_history() end, desc = "Search History" },
        { "<leader>S?", function() Snacks.picker.help() end, desc = "Help Pages" },
        { "<leader>Sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
        { "<leader>Sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>SB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
        { "<leader>Sc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>SC", function() Snacks.picker.commands() end, desc = "Commands" },
        { "<leader>Sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
        { "<leader>SD", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>Se", function() Snacks.explorer() end, desc = "File Explorer" },
        { "<leader>Sf", function() Snacks.picker.smart() end, desc = "Search files" },
        { "<leader>SF", function() Snacks.picker.files() end, desc = "Find Files" },    -- What's the difference?
        { "<leader>Sg", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>Si", function() Snacks.picker.icons() end, desc = "Icons" },
        { "<leader>Sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
        { "<leader>Sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>Sl", function() Snacks.picker.loclist() end, desc = "Location List" },
        { "<leader>SL", function() Snacks.picker.highlights() end, desc = "Highlights" },
        -- NOTE: I'm reserving "leader<sm>" for searching whatever marks tool (harpoon, grapple, etc.) I like best.
        -- { "<leader>Sm", function() Snacks.picker.man() end, desc = "Man Pages" },
        { "<leader>SM", function() Snacks.picker.marks() end, desc = "Marks" },
        { "<leader>Sn", function() Snacks.picker.notifications() end, desc = "Notification History" },
        { "<leader>So", function() Snacks.picker.recent() end, desc = "Recent" },
        { "<leader>Sp", function() Snacks.picker.projects() end, desc = "Projects" },
        { "<leader>SP", function() Snacks.picker() end, desc = "Pickers" },
        { "<leader>Sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
        { "<leader>Sr", function() Snacks.picker.registers() end, desc = "Registers" },
        { "<leader>Ss", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
        { "<leader>Su", function() Snacks.picker.undo() end, desc = "Undo History" },
        { "<leader>Sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },

        { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },

        -- git
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
        { "<leader>gf", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
        { "<leader>gF", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
        { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
        { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },

        -- LSP
        { "<leader>Ld", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
        { "<leader>LD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
        { "<leader>Lr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        { "<leader>LI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        { "<leader>Ly", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
        { "<leader>Ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
        { "<leader>LS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
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
            },
            -- formats = {
            --     header = { "%s", align = "center" },
            -- },
            sections = {
                { section = "header" },
                -- {
                --     pane = 2,
                --     section = "terminal",
                --     --cmd = "colorscript -e square",    -- Not on Windows
                --     height = 5,
                --     padding = 1,
                -- },
                { section = "keys", gap = 1, padding = 1 },
                {
                    pane = 2,
                    icon = " ",
                    title = "Recent Files",
                    section = "recent_files",
                    indent = 2,
                    padding = 1,
                    limit = configutils.is_git_repo() and 5 or 20,
                },
                {
                    pane = 2,
                    icon = " ",
                    title = "Projects",
                    section = "projects",
                    indent = 2,
                    padding = 1,
                    limit = configutils.is_git_repo() and 5 or 10,
                },
                -- {
                --     pane = 2,
                --     icon = " ",
                --     title = "Git Status",
                --     section = "terminal",
                --     enabled = function()
                --         return Snacks.git.get_root() ~= nil
                --     end,
                --     cmd = "git status --short --branch --renames",
                --     height = 5,
                --     padding = 1,
                --     ttl = 5 * 60,
                --     indent = 3,
                -- },

                {
                    enabled = configutils.is_git_repo(),
                    pane = 2,
                    icon = " ",
                    desc = "Browse Repo",
                    padding = 1,
                    key = "b",
                    action = function()
                        Snacks.gitbrowse()
                    end,
                },
                function()
                    local in_git = Snacks.git.get_root() ~= nil
                    local cmds = {
                        {
                            icon = " ",
                            title = "GitHub Account",
                            cmd = "gh auth status --active",
                            height = 3,
                            key = "S",
                            ttl = 0,    -- Gets rid of caching for this data.
                            action = function ()
                                vim.fn.jobstart("gh auth switch")
                                Snacks.dashboard.update()
                            end
                        },
                        {
                            icon = " ",
                            title = "Git Status",
                            section = "terminal",
                            enabled = function()
                                return Snacks.git.get_root() ~= nil
                            end,
                            cmd = "git status --short --branch --renames",
                            height = 5,
                            padding = 1,
                            ttl = 5 * 60,
                            indent = 3,
                        },
                        {
                            title = "Notifications",
                            cmd = "gh notify -s -a -n3",
                            action = function()
                                vim.ui.open("https://github.com/notifications")
                            end,
                            key = "N",
                            icon = " ",
                            height = 3,
                            ttl = 30,
                        },
                        {
                            title = "Open Issues",
                            cmd = "gh issue list -L 3",
                            key = "i",
                            action = function()
                                vim.fn.jobstart("gh issue list --web", { detach = true })
                            end,
                            icon = " ",
                            height = 3,
                            ttl = 30,
                        },
                        {
                            icon = " ",
                            title = "Open PRs",
                            cmd = "gh pr list -L 3",
                            key = "P",
                            action = function()
                                vim.fn.jobstart("gh pr list --web", { detach = true })
                            end,
                            height = 3,
                            ttl = 30,
                        },
                        -- {
                        --     icon = " ",
                        --     title = "Git Status",
                        --     cmd = "git --no-pager diff --stat -B -M -C",
                        --     height = 10,
                        -- },

                    }
                    return vim.tbl_map(function(cmd)
                        return vim.tbl_extend("force", {
                            pane = 2,
                            section = "terminal",
                            enabled = in_git,
                            padding = 1,
                            ttl = 5 * 60,
                            indent = 3,
                        }, cmd)
                    end, cmds)
                end,

                { section = "startup" },
            },
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

        picker = {
            enabled = true,
            -- Tried this as a workaround for the flashing cursor issue. Failed.
            -- explorer = {
            --     watch = false,
            -- },
        },

        --notifier = { enabled = true },
        quickfile = { enabled = true },
        scratch = { enabled = true, },
        scroll = { 
            -- Neovide has its own smooth scrolling, so leave it disabled.
            enabled = not vim.g.neovide,
            animate = {
                duration = { step = 10, total = 100 },
                easing = "linear",
            },
            -- faster animation when repeating scroll after delay
            animate_repeat = {
                delay = 100, -- delay in ms before using the repeat animation
                duration = { step = 5, total = 50 },
                easing = "linear",
            },
            -- what buffers to animate
            filter = function(buf)
                return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype ~= "terminal"
            end,
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
