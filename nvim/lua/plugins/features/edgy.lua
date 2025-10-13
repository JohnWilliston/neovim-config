return {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
        -- Settings recommended for edgy. Setting them here for safety.
        vim.opt.laststatus = 3
        vim.opt.splitkeep = "screen"
    end,
    opts = {
        animate = {
            enabled = false,
        },
        bottom = {
            -- toggleterm / lazyterm at the bottom with a height of 40% of the screen
            {
                ft = "toggleterm",
                size = { height = 0.4 },

                -- I'm a little bit proud of this filter function. The way I've
                -- defined my toggleterm key bindings, the default terminal 1 is
                -- a popup, 2 and 3 are reserved for horizontal and vertical
                -- respectively, and 4 is my first "full-tab" terminal. After
                -- that, you can create more via key bindings that leverage a
                -- utility function in my config-utils that uses an increasing
                -- integer starting at five. So because all full-tab terminals
                -- will have a number four or greater, I can use the lovely
                -- Lua pattern matching function to pull off the terminal
                -- number from the buffer name (which for a toggleterm shell
                -- always ends in 'toggleterm::[number]'), convert that to a
                -- number, and then let those full-tab terminals pass simply by
                -- checking if its less than three (to allow the vertical option
                -- to slip through edgy as well).
                --
                -- Here's a truth table I put together to figure this out,
                -- given that we want the filter function to return FALSE
                -- for edgy to ignore the window/buffer.
                --
                -- Terminal type                    Condition 1:        Condition 2:            Output I Need
                --                                  Relative == ""      term number < 3
                --
                -- Popup terminal (floating) will   FALSE               TRUE                    FALSE
                -- have 'editor' for relative
                --
                -- Normal terminals have ''         TRUE                TRUE                   TRUE
                --
                -- All full-tab terminals           TRUE                FALSE                  FALSE
                --
                --That truth table showed me that all I need to do is combine
                -- my two existing conditions in a logical-and to get what I want.
                -- And I'm happy to say it works as anticipated.
                filter = function(buf, win)
                    local bufname = vim.api.nvim_buf_get_name(buf)
                    local match = bufname:match("toggleterm[:#]+(%d+)")
                    return vim.api.nvim_win_get_config(win).relative == "" and tonumber(match) < 3
                end,
            },
            -- Dadbod customizations for SQL script and query output.
            {
                ft = "sql",
                filter = function(buf, win)
                    return false
                end,
            },
            {
                ft = "dbout", size = { height = 0.4 },
            },
            -- Other stuff we manage on the bottom includes a horizontal 
            -- terminal, all the trouble-related quick fix lists and such, my 
            -- two file search/replace tools (viz., spectre and grug), and then 
            -- the dadbod database UI output stuff when doing queries.
            "Trouble",
            { ft = "qf",      title = "QuickFix" },
            { ft = "trouble", title = "Trouble" },
            { ft = "spectre_panel", size = { height = 0.4 } },
            { ft = "grug-far",      size = { height = 0.4 } },
        },
        -- In contrast, stuff we manage on the left is limited to  the neo-tree 
        -- file manager with its Git and buffers panes. This was a little tricky
        -- to get working correctly and required setting up the key bindings
        -- in such a way as to call the functions with certain parameters so
        -- edgy can catch them and segregate/manage them properly.
        left = {
            {
                title = "Neo-Tree Filesystem",
                ft = "neo-tree",
                filter = function(buf, win)
                    return vim.b[buf].neo_tree_source == "filesystem"
                        and vim.api.nvim_win_get_config(win).relative == ""
                end,
                -- Neo-tree filesystem always takes half the screen height
                size = { height = 0.5, width = 0.25 },
            },
            {
                title = "Neo-Tree Git",
                ft = "neo-tree",
                filter = function(buf, win)
                    return vim.api.nvim_win_get_config(win).relative ~= "win"
                        and vim.b[buf].neo_tree_source == "git_status"
                end,
                --pinned = true,
                -- collapsed = false, -- show window as closed/collapsed on start
                open = "Neotree position=right git_status",
            },
            {
                title = "Neo-Tree Buffers",
                ft = "neo-tree",
                filter = function(buf, win)
                    return vim.api.nvim_win_get_config(win).relative ~= "win"
                        and vim.b[buf].neo_tree_source == "buffers"
                end,
                --pinned = true,
                -- collapsed = false, -- show window as closed/collapsed on start
                open = "Neotree position=top buffers",
            },
        },
        -- Finally, we come to the things I prefer to have on the right: the
        -- LSP symbols outline pane and any built-in help query results. 
        right = {
            {
                title = function()
                    local buf_name = vim.api.nvim_buf_get_name(0) or "[No Name]"
                    return vim.fn.fnamemodify(buf_name, ":t")
                end,
                ft = "Outline",
                pinned = false,
                open = "Outline",
                --open = "SymbolsOutline",
            },
            {
                ft = "help",
                size = { width = 0.4 },
                -- only show help buffers
                filter = function(buf)
                    -- return vim.bo[buf].buftype == "help"
                    -- TODO: Figure out what to do with help.
                    return false
                end,
            },
        },
        -- It's essential to be able to tweak the edgy panes through these key
        -- mappings because I can't use my typical Hydra to manage them.
        keys = {
            -- increase width
            ["<c-w>>"] = function(win)
                win:resize("width", 5)
            end,
            -- decrease width
            ["<c-w><lt>"] = function(win)
                win:resize("width", -5)
            end,
            -- increase height
            ["<c-w>+"] = function(win)
                win:resize("height", 3)
            end,
            -- decrease height
            ["<c-w>-"] = function(win)
                win:resize("height", -3)
            end,
        },
    },
}
