return {
	"ThePrimeagen/refactoring.nvim",
	cmd = "Refactor",
    -- NB: The trailing spaces in the first three bindings below are necessary
    -- because the function expects an additional argument and leaves the user
    -- in command mode. You can see this on the main repo page here:
    -- https://github.com/ThePrimeagen/refactoring.nvim
    keys = {
        { "<leader>re", "<cmd>Refactor extract <cr>", desc = "Refactor extract", mode = "x" },
        { "<leader>rf", "<cmd>Refactor extract_to_file <cr>", desc = "Refactor extract to file", mode = "x" },

        { "<leader>rv", "<cmd>Refactor extract_var <cr>", desc = "Refactor extract var", mode = "x" },

        { "<leader>ri", "<cmd>Refactor inline_var<cr>", desc = "Refactor inline var", mode = { "n", "x" } },

        { "<leader>rI", "<cmd>Refactor inline_func<cr>", desc = "Refactor inline func", mode = "n" },

        { "<leader>rb", "<cmd>Refactor extract_block<cr>", desc = "Refactor extract block", mode = "n" },
        { "<leader>rbf", "<cmd>Refactor extract_block_to_file<cr>", desc = "Refactor extract block to file", mode = "n" },

        -- I prefer using telescope, though I have had issues with it before.
        -- { "<leader>rr", function () require("refactoring").select_refactor() end, desc = "Prompt refactoring", mode = { "n", "x" } },
        { "<leader>rr", function () require("telescope").extensions.refactoring.refactors() end, desc = "Refactoring prompt", mode = { "n", "x" } },
    },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
}
