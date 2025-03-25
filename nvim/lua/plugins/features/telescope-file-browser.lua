return {
	"nvim-telescope/telescope-file-browser.nvim",
	keys = {
		{ "<leader>fb", "<cmd>Telescope file_browser<cr>", desc = "Telescope file browser" },
	},
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
}
