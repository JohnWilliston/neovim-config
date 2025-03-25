return {
	"sindrets/diffview.nvim",
    cmd = {
        "DiffviewFileHistory",
        "DiffviewOpen",
        "DiffviewClose",
    },
    keys = {
        { "<leader>vd", "<cmd>DiffviewOpen<CR>", desc = "Git diff", mode = "n" },
        { "<leader>vh", "<cmd>DiffviewFileHistory %<CR>", desc = "Git history", mode = "n" },
        { "<leader>vH", "<cmd>DiffviewFileHistory<CR>", desc = "Git history", mode = "n" },
        { "<leader>vo", "<cmd>DiffviewOpen origin/master..HEAD<CR>", desc = "Diff to origin/master", mode = "n" },
        { "<leader>vO", "<cmd>DiffviewOpen origin/main..HEAD<CR>", desc = "Diff to origin/main", mode = "n" },
        { "<leader>vq", "<cmd>DiffviewClose<CR>", desc = "Close diff", mode = "n" },

    },
}
