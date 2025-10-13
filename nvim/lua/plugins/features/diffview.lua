return {
    "sindrets/diffview.nvim",
    cmd = {
        "DiffviewFileHistory",
        "DiffviewOpen",
        "DiffviewClose",
    },
    keys = {
        { "<leader>vd", "<cmd>DiffviewFileHistory %<CR>",            desc = "Git diff file history" },
        { "<leader>vD", "<cmd>DiffviewFileHistory<CR>",              desc = "Git diff repo history" },
        { "<leader>vo", "<cmd>DiffviewOpen origin/master..HEAD<CR>", desc = "Diff to origin/master" },
        { "<leader>vO", "<cmd>DiffviewOpen origin/main..HEAD<CR>",   desc = "Diff to origin/main" },
        { "<leader>vq", "<cmd>DiffviewClose<CR>",                    desc = "Close diff" },
        { "<leader>vS", "<cmd>DiffviewOpen<CR>",                     desc = "Git status w/diffs" },
    },
}
