-- The good news: it's a harpoon-like plugin that actually saves your marks.
-- The bad news: it updates the bloody mark positions. They're really links to
-- a file than a location. I don't know if that's going to work for me.
return {
    "cbochs/grapple.nvim",
    dependencies = {
        { "nvim-tree/nvim-web-devicons", lazy = true }
    },
    opts = {
        scope = "git", -- also try out "git_branch"
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    keys = {
        { "<leader>ma", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
        { "<leader>mm", "<cmd>Grapple toggle_tags<cr>", desc = "Open Grapple window" },
        { "<leader>mp", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple go to previous" },
        { "<leader>mn", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple go to next" },
        { "<leader>sm", "<cmd>Telescope grapple tags<cr>", desc = "Search grapple tags" },
    },
    config = function (_, opts)
        require("grapple").setup(opts)
        require("telescope").load_extension("grapple")
    end
}

