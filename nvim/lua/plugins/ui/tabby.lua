return {
    "nanozuki/tabby.nvim",
    enabled = true,
    lazy = false, -- Key bindings below will cause lazy load. This fixes it.
    dependencies = "nvim-tree/nvim-web-devicons",
    init = function ()
       -- I'm adding a custom Vim global largely so heirline can know whether to
       -- provide a tab line or not.
       vim.g.tabby = true
    end,
    keys = {
        { "<A-1>", "1gt", desc = "Goto tab 1" },
        { "<A-2>", "2gt", desc = "Goto tab 2" },
        { "<A-3>", "3gt", desc = "Goto tab 3" },
        { "<A-4>", "4gt", desc = "Goto tab 4" },
        { "<A-5>", "5gt", desc = "Goto tab 5" },

        { "<leader>tc", "<cmd>tabclose<cr>", desc = "Tab close" }, 
        { "<leader>to", "<cmd>tabonly<cr>", desc = "Tab delete others" }, 
        { "<leader>tp", "<cmd>Tabby jump_to_tab<cr>", desc = "Tab picker" },
        {
            "<leader>tr",
            function()
                local name = vim.fn.input("New tab name: ")
                vim.cmd("Tabby rename_tab " .. name)
            end,
            desc = "Rename tab"
        },
        { "<leader>tw", "<cmd>Tabby pick_window<cr>", desc = "Window picker" },
    },
    opts = {
        nerdfont = true,
        preset = "active_wins_at_tail",
    },
}
