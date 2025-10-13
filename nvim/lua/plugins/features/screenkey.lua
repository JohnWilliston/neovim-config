-- It should be noted that the screen key display does not cope well with the 
-- closing of underlying windows/buffers. Don't change projects with it open.
-- Use it only to illustrate a given concept, close when not in use. An external
-- application is better for more involved demonstrations.
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
