return {
    "bennypowers/splitjoin.nvim",
    keys = {
        { "<leader>c,", function () require("splitjoin").split() end, desc = "Split under cursor" },
        { "<leader>cj", function () require("splitjoin").join() end, desc = "Join under cursor" },
    },
}
