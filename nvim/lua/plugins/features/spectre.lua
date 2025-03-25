return {
    "nvim-pack/nvim-spectre",
    keys = {
        { "<leader>es", function () require('spectre').toggle() end, desc = "Search & replace (spectre)" },
    },
    opts = {},
}
