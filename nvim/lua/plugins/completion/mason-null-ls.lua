-- This plugin provides automated installation of the tools defined in use by
-- the none-ls plugin, which is technically adapted from null-ls (even keeping
-- the same module name for sake of drop-in compatibility). I've defined the
-- actual tools in the setup for the none-ls plugin, so the configuration here
-- simply ensures the setup routines are called in the proper order and tells
-- the mason-null-ls plugin to do automatic installation of the tools. This 
-- seems to work nicely with all that I've already defined in none-ls.
return {
	"jay-babu/mason-null-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"nvimtools/none-ls.nvim",
	},
	config = function()
		require("mason").setup()
		require("null-ls").setup({})
		require("mason-null-ls").setup({
			ensure_installed = nil,
			automatic_installation = true,
		})
	end,
}
