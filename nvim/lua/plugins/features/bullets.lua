return {
	"bullets-vim/bullets.vim",
    cmd = {
        "BulletDemote",
        "BulletPromote",
        "RenumberSelection",
    },
    keys = {
        { "<leader>eb<", "<cmd>BulletPromote<CR>", desc = "Promote bullet" },
        { "<leader>eb>", "<cmd>BulletDemote<CR>", desc = "Demote bullet" },
        { "<leader>ebr", "<cmd>RenumberSelection<CR>", desc = "Renumber selection", mode = { "n", "v" } },
    },
}
