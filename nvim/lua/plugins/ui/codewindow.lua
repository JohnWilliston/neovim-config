return {
	"gorbit99/codewindow.nvim",
	event = "VeryLazy",
    keys = {
        { "<leader>emo", function () require("codewindow").open_minimap() end,   desc = "Minimap open" },
        { "<leader>emc", function () require("codewindow").close_minimap() end,  desc = "Minimap close" },
        { "<leader>emf", function () require("codewindow").toggle_focus() end,   desc = "Minimap focus toggle" },
        { "<leader>emt", function () require("codewindow").toggle_minimap() end, desc = "Minimap toggle" },
    },
	opts = {
		width_multiplier = 4,
	},
}
