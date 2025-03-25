-- I think I need to start keeping track of things edgy essentially breaks:
--  * I can't really use my normal terminal bindings.
--  * It conflicts pretty badly with tabby. Maybe scope. Not sure which.
--  * I had to fiddle with neotree quite a bit and disable some bindings.
return {
	"folke/edgy.nvim",
	enabled = true,
	event = "VeryLazy",
	init = function()
        -- Settings recommended for edgy. Setting them here for safety.
		vim.opt.laststatus = 3
		vim.opt.splitkeep = "screen"

       -- I'm adding a custom Vim global largely so plugins can know whether to
       -- make certain changes to accomodate edgy.
       vim.g.edgy = true
	end,
	opts = {
		animate = {
			enabled = false,
		},
		bottom = {
			-- toggleterm / lazyterm at the bottom with a height of 40% of the screen
			-- {
			--     ft = "toggleterm",
			--     size = { height = 0.4 },
			--     -- exclude floating windows
			--     filter = function(buf, win)
			--         return vim.api.nvim_win_get_config(win).relative == ""
			--     end,
			-- },
			{
				ft = "toggleterm",
				size = { height = 0.4 },

                -- I'm a little bit proud of this filter function. The way I've
                -- defined my toggleterm key bindings, the default terminal 1 is
                -- a popup, 2 and 3 are reserved for horizontal and vertical
                -- respectively, and 4 is my first "full-tab" terminal. After 
                -- that, you can create more via key bindings that leverage a
                -- utility function in my config-utils that uses an increasing
                -- integer starting at five. So because all full-tab terminals
                -- will have a number four or greater, I can use the lovely
                -- Lua pattern matching function to pull off the terminal
                -- number from the buffer name (which for a toggleterm shell
                -- always ends in 'toggleterm::[number]'), convert that to a
                -- number, and then let those full-tab terminals pass simply by
                -- checking if its less than four.
                --
                -- A little truth table I put together to figure this out,
                -- given that we want the filter function to return FALSE
                -- for edgy to ignore the window/buffer.
                --
                -- Terminal type                    Condition 1:        Condition 2:            Output I Need
                --                                  Relative == ""      term number < 4
                --
                -- Popup terminal (floating) will   FALSE               TRUE                    FALSE
                -- have 'editor' for relative
                --
                -- Normal terminals have ''         TRUE                TRUE                   TRUE
                --
                -- All full-tab terminals           TRUE                FALSE                  FALSE
                --
                --That truth table showed me that all I need to do is combine
                -- my two existing conditions in a logical-and to get what I want.
                -- And I'm happy to say it works as anticipated. NB: the full-tab
                -- terminal has "toggleterm::4" in its name due to the way I've
                -- configured the toggleterm key bindings, so that's the only
                -- terminal definition to which that will apply.

				filter = function(buf, win)
                    --vim.print("buf = ".. buf .. ", win = " .. win)
                    local bufname = vim.api.nvim_buf_get_name(buf)
                    local match = bufname:match("toggleterm[:#]+(%d+)")
                    -- vim.print("bufname = " .. bufname )
				    return vim.api.nvim_win_get_config(win).relative == ""
                        and tonumber(match) < 4
				end,
			},
			"Trouble",
			{ ft = "qf", title = "QuickFix" },
			{ ft = "trouble", title = "Trouble" },
			{
				ft = "help",
				size = { height = 20 },
				-- only show help buffers
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
			},
			{ ft = "spectre_panel", size = { height = 0.4 } },
			{ ft = "grug-far", size = { height = 0.4 } },
		},
		left = {
			{
				title = "Neo-Tree Filesystem",
				ft = "neo-tree",
				filter = function(buf, win)
					return vim.b[buf].neo_tree_source == "filesystem"
                        and vim.api.nvim_win_get_config(win).relative == ""
				end,
                -- Neo-tree filesystem always takes half the screen height
				size = { height = 0.5 },
			},
			{
				title = "Neo-Tree Git",
				ft = "neo-tree",
				filter = function(buf, win)
					return vim.api.nvim_win_get_config(win).relative ~= "win"
                        and vim.b[buf].neo_tree_source == "git_status"
				end,
				--pinned = true,
				-- collapsed = false, -- show window as closed/collapsed on start
				open = "Neotree position=right git_status",
			},
			{
				title = "Neo-Tree Buffers",
				ft = "neo-tree",
				filter = function(buf, win)
					return vim.api.nvim_win_get_config(win).relative ~= "win"
                        and vim.b[buf].neo_tree_source ==  "buffers"
				end,
				--pinned = true,
				-- collapsed = false, -- show window as closed/collapsed on start
				open = "Neotree position=top buffers",
			},
		},
		right = {
			{
				title = function()
					local buf_name = vim.api.nvim_buf_get_name(0) or "[No Name]"
					return vim.fn.fnamemodify(buf_name, ":t")
				end,
				ft = "Outline",
				pinned = false,
				open = "Outline",
				--open = "SymbolsOutline",
			},
		},
	},
}
