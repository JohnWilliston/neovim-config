return {
    "folke/noice.nvim",
    event = "VeryLazy",
    enabled = false,
    init = function ()
       -- I'm adding a custom Vim global largely so lualine can know whether to
       -- make certain changes to accomodate noice.
       vim.g.noice = true
    end,
    opts = {
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
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
        },
        -- I guess this is supposed to help Noice show macro recording (and 
        -- maybe other?) notifications, but it doesn't seem to help. I had to
        -- add some configuration to lualine to show the recording notification.
        -- routes = {
        --     view = "notify",
        --     filter = {event = "msg_showmode" },
        -- },
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
    }
}
