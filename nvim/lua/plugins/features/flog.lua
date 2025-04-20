return {
    "rbong/vim-flog",
    cmd = { "Flog", "Flogsplit", "Floggit" },
    keys = {
        { "<leader>vB", "<cmd>Flog<CR>", desc = "Git branch tree" },
    },
    dependencies = {
        "tpope/vim-fugitive",
    },
}
