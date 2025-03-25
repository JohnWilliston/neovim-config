return {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
        -- The most basic use of flash: just start typing and hit char to jump.
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        -- Starts treesitter search, hit 'c' to expand to surrounding scope.
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        -- Use with a motion to remotely do one thing and then return.
        -- For example, y r starts search, jump to one, hit y to yank and return.
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        -- Operator pending or visual select with treesiter searching.
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        -- Use when searching for a pattern to enable flash mode. Very helpful.
        { "<C-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
}
