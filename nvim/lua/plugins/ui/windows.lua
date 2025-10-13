return {
    "anuvyklack/windows.nvim",
    dependencies = {
        { "anuvyklack/middleclass" },
        { "anuvyklack/animation.nvim" },
    },
    keys = {
        { "<C-w>z", "<cmd>WindowsMaximize<CR>",             desc = "Window maximize" },
        { "<C-w>_", "<cmd>WindowsMaximizeVertically<CR>",   desc = "Window maximize vertically" },
        { "<C-w>|", "<cmd>WindowsMaximizeHorizontally<CR>", desc = "Window maximize horizontally" },
        { "<C-w>=", "<cmd>WindowsEqualize<CR>",             desc = "Window equalize" },
    },
    init = function()
        vim.o.winwidth = 10
        vim.o.winminwidth = 10
        vim.o.equalalways = false
    end,
    opts = {
        autowidth = {
            enable = true,
        },
    },
}
