return {
    "akinsho/toggleterm.nvim",
    cmd = {
        "ToggleTerm",
        "ToggleTermSendCurrentLine",
        "ToggleTermSendVisualLines",
        "ToggleTermSendVisualSelection",
        "ToggleTermToggleAll",
    },
    keys = {
        { "<leader>t\\", "<cmd>1ToggleTerm direction=float name=Popup<cr>",            desc = "Terminal1 (Popup)" },
        { "<leader>t-",  "<cmd>2ToggleTerm direction=horizontal name=Horiztontal<cr>", desc = "Terminal2 (Horizontal)" },
        { "<leader>t|",  "<cmd>3ToggleTerm direction=vertical name=Vertical<cr>",      desc = "Terminal3 (Vertical)" },
        { "<leader>tt",  "<cmd>4ToggleTerm direction=tab name=Tab<cr>",                desc = "Terminal4 (Tab)" },
        { "<leader>tx",  "<cmd>ToggleTermSendCurrentLine 1<cr>",                       desc = "Send Line to Popup Terminal" },
    },
    opts = {
        start_in_insert = false,
        --direction = "float",
        direction = "horizontal",
        close_on_exit = false,
        float_opts = {
            border = "curved",
            title_pos = "center",
        },
        size = function(term)
            if term.direction == "horizontal" then
                vim.print("lines = " .. vim.o.lines)
                return vim.o.lines * 0.5
            elseif term.direction == "vertical" then
                return vim.o.columns * 0.5
            end
        end,
        -- I thought this was a fairly clever way to use the ternary operator.
        shell = vim.loop.os_uname().sysname == "Windows_NT" and "tcc.exe" or vim.o.shell,
    },
    -- I don't much use this technique of configuring dependents within the 
    -- "parent" spec, but in this case it makes sense: I'm never going to use
    -- the one without the other. They're an atomic dyad to my mind.
    dependencies = {
        {
            "ryanmsnyder/toggleterm-manager.nvim",
            keys = {
                { "<leader>tm", "<cmd>Telescope toggleterm_manager<cr>", desc = "Toggleterm manager", mode = "n" },
            },
            dependencies = {
                "nvim-telescope/telescope.nvim",
                "nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
            },
            opts = function ()
                local actions = require("toggleterm-manager").actions
                return {
                    mappings = {
                        -- Adding new mappings to be more in line with the Git
                        -- worktrees plugin and others.
                        i = {
                            ["<CR>"]  = { action = actions.toggle_term, exit_on_action = false }, -- toggles terminal open/closed
                            -- ["<C-i>"] = { action = actions.create_term, exit_on_action = false }, -- creates a new terminal buffer
                            -- ["<C-d>"] = { action = actions.delete_term, exit_on_action = false }, -- deletes a terminal buffer
                            -- ["<C-r>"] = { action = actions.rename_term, exit_on_action = false }, -- provides a prompt to rename a terminal
                            ["<A-c>"] = { action = actions.create_term, exit_on_action = false }, -- creates a new terminal buffer
                            ["<A-d>"] = { action = actions.delete_term, exit_on_action = false }, -- deletes a terminal buffer
                            ["<A-r>"] = { action = actions.rename_term, exit_on_action = false }, -- provides a prompt to rename a terminal
                        },
                        n = {
                            ["<A-c>"] = { action = actions.create_term, exit_on_action = false }, -- creates a new terminal buffer
                            ["<A-d>"] = { action = actions.delete_term, exit_on_action = false }, -- deletes a terminal buffer
                            ["dd"] = { action = actions.delete_term, exit_on_action = false }, -- deletes a terminal buffer
                            ["<A-r>"] = { action = actions.rename_term, exit_on_action = false }, -- provides a prompt to rename a terminal
                        },
                    },
                }
            end,
            config = true,
        }
    },
}
