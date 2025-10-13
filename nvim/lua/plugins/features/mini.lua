return {
	"echasnovski/mini.nvim",
	keys = {
		{
			"<leader>eC",
			function()
				require("mini.colors").interactive()
			end,
			desc = "Mini colors",
			mode = "n",
		},
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
		local ai = require("mini.ai")
		require("mini.ai").setup({
			n_lines = 500,
			-- Most of this is cribbed from LazyVim:
			-- https://github.com/LazyVim/LazyVim
			custom_textobjects = {
				o = ai.gen_spec.treesitter({ -- code block
					a = { "@block.outer", "@conditional.outer", "@loop.outer" },
					i = { "@block.inner", "@conditional.inner", "@loop.inner" },
				}),
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
				c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
				t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
				d = { "%f[%d]%d+" }, -- digits
				-- The "perfect word textobject", which I found in a discussion:
				-- https://github.com/echasnovski/mini.nvim/discussions/1434
				e = 				-- snake_case, camelCase, PascalCase, etc; all capitalizations
{
					-- Lua 5.1 character classes and the undocumented frontier pattern:
					-- https://www.lua.org/manual/5.1/manual.html#5.4.1
					-- http://lua-users.org/wiki/FrontierPattern
					-- note: when I say "letter" I technically mean "letter or digit"
					{
						-- Matches a single uppercase letter followed by 1+ lowercase letters.
						-- This covers:
						-- - PascalCaseWords (or the latter part of camelCaseWords)
						"%u[%l%d]+%f[^%l%d]", -- An uppercase letter, 1+ lowercase letters, to end of lowercase letters

						-- Matches lowercase letters up until not lowercase letter.
						-- This covers:
						-- - start of camelCaseWords (just the `camel`)
						-- - snake_case_words in lowercase
						-- - regular lowercase words
						"%f[^%s%p][%l%d]+%f[^%l%d]", -- after whitespace/punctuation, 1+ lowercase letters, to end of lowercase letters
						"^[%l%d]+%f[^%l%d]", -- after beginning of line, 1+ lowercase letters, to end of lowercase letters

						-- Matches uppercase or lowercase letters up until not letters.
						-- This covers:
						-- - SNAKE_CASE_WORDS in uppercase
						-- - Snake_Case_Words in titlecase
						-- - regular UPPERCASE words
						-- (it must be both uppercase and lowercase otherwise it will
						-- match just the first letter of PascalCaseWords)
						"%f[^%s%p][%a%d]+%f[^%a%d]", -- after whitespace/punctuation, 1+ letters, to end of letters
						"^[%a%d]+%f[^%a%d]", -- after beginning of line, 1+ letters, to end of letters
					},
					"^().*()$",
				},
				u = ai.gen_spec.function_call(), -- u for "Usage"
				U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
			},
		})

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
