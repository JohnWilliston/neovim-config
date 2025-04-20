return {
    "nanozuki/tabby.nvim",
    enabled = true,
    lazy = false, -- Key bindings below will cause lazy load. This fixes it.
    dependencies = "nvim-tree/nvim-web-devicons",
    init = function()
        -- I'm adding a custom Vim global largely so heirline can know whether to
        -- provide a tab line or not.
        vim.g.tabby = true
    end,
    keys = {
        { "<leader>tp", "<cmd>Tabby jump_to_tab<cr>", desc = "Tab picker" },
        {
            "<leader>tr",
            function()
                local name = vim.fn.input("New tab name: ")
                vim.cmd("Tabby rename_tab " .. name)
            end,
            desc = "Rename tab",
        },
        { "<leader>tw", "<cmd>Tabby pick_window<cr>", desc = "Window picker" },
        -- NOTE: I've reserved this key bind spot in my telescope config. But I
        -- define it here for sake of plugin spec encapsulation.
        -- {
        --     "<leader>st",
        --     function()
        --         require("telescope").extensions.tele_tabby.list()
        --     end,
        --     desc = "Search tabs",
        -- },
    },
    opts = {
        nerdfont = true,
        preset = "active_wins_at_tail",
    },
}
