return {
    "folke/noice.nvim",
    event = "VeryLazy",
    cmd = "Noice",
    keys = {
        { "<leader>nh", "<cmd>Noice history<CR>",   desc = "Notification history" },
        { "<leader>nd", "<cmd>Noice dismiss<CR>",   desc = "Dismiss notifications" },
        { "<leader>ne", "<cmd>Noice errors<CR>",    desc = "Error notifications" },
        { "<leader>nl", "<cmd>Noice last<CR>",      desc = "Last notification" },
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
    init = function()
        -- I'm adding a custom Vim global largely so lualine can know whether to
        -- make certain changes to accommodate noice.
        vim.g.noice = true
    end,
    opts = {
        -- NB: If you disable the cmdline in noice, you'll need to un-comment
        -- the setting below to disable messages as well.
        -- See https://github.com/folke/noice.nvim/issues/560
        cmdline = {
            enabled = true,
            view = "cmdline_popup",
        },
        -- messages = {
        --     enabled = false,
        -- },
        lsp = {
            -- The following is the *second* signature popup I was seeing and
            -- did not want and didn't even know was something noice did. Nice!
            signature = {
                enabled = false,
            },
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
            inc_rename = false,  -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
        },
        -- It's worth noting that the "filter" options in this section are not
        -- the usual negative filter-something-out, but rather by default are
        -- to INCLUDE a thing that you want.
        routes = {
            -- This filters out annoying code action messages from null-ls.
            -- https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#ignore-certain-lsp-servers-for-progress-messages
            {
                filter = {
                    event = "lsp",
                    kind = "progress",
                    cond = function(message)
                        local client = vim.tbl_get(message.opts, "progress", "client")
                        return client == "null-ls"
                    end,
                },
                opts = { skip = true },
            },
            -- I probably shouldn't be doing this because deprecated stuff can
            -- end up biting you, but I'm sick of the messages at startup.
            {
                filter = {
                    find = "deprecated",
                },
                opts = { skip = true },
            },
            -- Show mode messages include notification of macro recording and
            -- the insert/replace mode announcements. I find the former useful
            -- and the latter annoying, so this selectively enables the one.
            {
                view = "notify",
                filter = { 
                    event = "msg_showmode",
                    find = "recording",
                },
            },
            -- This gets rid of messages like change of directory and such, the
            -- utility of which I go back and forth on it seems.
            -- {
            --     filter = {
            --         event = "msg_show",
            --         kind = "",
            --         find = "",
            --     },
            --     opts = { skip = true },
            -- },
        },
    },
}
