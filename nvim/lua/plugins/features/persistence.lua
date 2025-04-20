-- I'm trying out this plugin that always saves the last session essentially as
-- a hail-mary backup option for when I quit Neovim and forgot to save.
return {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    keys = {
        {
            "<leader>p.",
            function()
                require("persistence").load({ last = true })
            end,
            desc = "Project restore last session",
        },
    },
    opts = {},
}
