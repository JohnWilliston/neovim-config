return {
	name = "NMAKE Build",
	builder = function()
		-- Full path to current file (see :help expand())
		-- local file = vim.fn.expand("%:p")
		return {
			cmd = { "nmake" },
			args = { },
			components = { { "on_output_quickfix", open = true }, "default" },
		}
	end,
	condition = {
		filetype = { "cpp" },
	},
}
