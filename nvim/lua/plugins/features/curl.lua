return {
    "oysandvik94/curl.nvim",
    cmd = { "CurlOpen" },
    keys = {
        -- Not sure what the collection does.
        { "<leader>tuc", "<cmd>CurlCollection<cr>", desc = "HTTP collection" },
        { "<leader>tuo", "<cmd>CurlOpen<cr>",       desc = "HTTP open" },
        { "<leader>tuq", "<cmd>CurlClose<cr>",      desc = "HTTP quit" },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = true,
}
