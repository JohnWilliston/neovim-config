-- Note that yanky includes a completion plugin integration for nvim-cmp.
return {
	"gbprod/yanky.nvim",
	opts = {
		ring = {
			history_length = 20, -- I can't imagine needing more entries
		},
	},
	keys = {
		{ "p", "<Plug>(YankyPutAfter)", desc = "Yanky put after", mode = { "n", "x" } },
		{ "P", "<Plug>(YankyPutBefore)", desc = "Yanky put before", mode = { "n", "x" } },
		{ "gp", "<Plug>(YankyPutAfter)", desc = "Yanky gput after", mode = { "n", "x" } },
		{ "gP", "<Plug>(YankyPutBefore)", desc = "Yanky gput before", mode = { "n", "x" } },
		{ "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Yanky previous entry", mode = { "n" } },
		{ "<c-n>", "<Plug>(YankyNextEntry)", desc = "Yanky previous entry", mode = { "n" } },
	},
}
