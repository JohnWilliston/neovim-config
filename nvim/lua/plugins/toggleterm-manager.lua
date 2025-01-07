
    return {
        "ryanmsnyder/toggleterm-manager.nvim",
        enabled = true,
        dependencies = {
            "akinsho/nvim-toggleterm.lua",
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
        },
        -- opts = function ()
        --     local actions = require("toggleterm-manager").actions
        --     return {
        --         mappings = { -- key mappings bound inside the telescope window
        --             i = {
        --                 ["<CR>"]  = { action = actions.toggle_term, exit_on_action = false }, -- toggles terminal open/closed
        --                 ["<C-i>"] = { action = actions.create_term, exit_on_action = false }, -- creates a new terminal buffer
        --                 ["<C-d>"] = { action = actions.delete_term, exit_on_action = false }, -- deletes a terminal buffer
        --                 ["<C-r>"] = { action = actions.rename_term, exit_on_action = false }, -- provides a prompt to rename a terminal
        --             },
        --         },
        --     }
        -- end,
        config = true,
    }
