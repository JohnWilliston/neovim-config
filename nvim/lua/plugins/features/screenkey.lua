return {
    "NStefan002/screenkey.nvim",
    cmd = "Screenkey",
    event = "VeryLazy",
    keys = {
        { "<leader>uk", "<cmd>Screenkey toggle<cr>", desc = "Screenkey toggle", mode = "n" },
    },
    opts = {
        win_opts = {
            row = 1, -- Position at the top to avoid conflict with which key.
        },
    },
}
