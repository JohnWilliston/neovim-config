return {
    "folke/noice.nvim",
    event = "VeryLazy",
    cmd = "Noice",
    keys = {
        { "<leader>nh", "<cmd>Noice history<CR>", desc = "Notification history" },
        { "<leader>nd", "<cmd>Noice dismiss<CR>", desc = "Dismiss notifications" },
        { "<leader>ne", "<cmd>Noice errors<CR>", desc = "Error notifications" },
        { "<leader>nl", "<cmd>Noice last<CR>", desc = "Last notification" },
        { "<leader>nt", "<cmd>Noice telescope<CR>", desc = "Notifications in telescope" },
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
    },
    init = function ()
       -- I'm adding a custom Vim global largely so lualine can know whether to
       -- make certain changes to accomodate noice.
       vim.g.noice = true
    end,
    opts = {
        cmdline = {
            enabled = true,
            view = "cmdline_popup",
        },
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            },
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = false, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
        },
        routes = {
            -- Enables mode messages, like macro recording. I have a status line
            -- indicator, so I'm not using it for now.
            -- {
            --     view = "notify",
            --     filter = { event = "msg_showmode" },
            -- },
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                    find = "",
                },
                opts = { skip = true },
            },
        },
    },
}
