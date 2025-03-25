return {
	"echasnovski/mini.nvim",
    keys = {
        { "<leader>ec", function () require("mini.colors").interactive() end, desc = "Mini colors", mode = "n" },
    },
	config = function()
        -- I'm using Snacks animation for now, so this is disabled.
        -- local animate = require("mini.animate")
        -- -- Only enable animation if we're not using Neovide.
        -- if not vim.g.neovide then
        --     animate.setup({
        --         scroll = {
        --             enable = true,
        --             timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        --         },
        --     })
        -- end

        -- Extended a/i text object support. I don't see any difference. Hmph.
        -- require("mini.ai").setup()

        require("mini.align").setup()

		-- Lets me dump current colors to a file and such. Helpful utility.
		require("mini.colors").setup()

		require("mini.cursorword").setup()
		-- I like the current word underlined.
		vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { underline = true })
		--vim.cmd([[hi MiniCursorwordCurrent gui=underline]])

		--require("mini.indentscope").setup()

        require("mini.move").setup()
        require("mini.pairs").setup()

		--require("mini.tabline").setup()

		--require("mini.icons").setup()
		--require('mini.diff').setup()  -- Can't figure out how to use this.
	end,
}
