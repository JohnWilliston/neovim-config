return {
	-- Manages workspaces tied to working directories. Provides a telescope
	-- powered selection tool to choose and switch.
	{
		"natecraddock/workspaces.nvim",
		cmd = {
			"WorkspacesAdd",
			"WorkspacesAddDir",
			"WorkspacesRemove",
			"WorkspacesRemoveDir",
			"WorkspacesRename",
			"WorkspacesList",
			"WorkspacesListDirs",
			"WorkspacesSyncDirs",
		},
		keys = {
			{ "<leader>pa", "<cmd>WorkspacesAddDir<CR>", desc = "Project add dir" },
			{ "<leader>pd", "<cmd>WorkspacesRemoveDir<CR>", desc = "Project delete dir" },
			{ "<leader>pln", "<cmd>WorkspacesList<CR>", desc = "Project list names" },
			{ "<leader>pld", "<cmd>WorkspacesListDirs<CR>", desc = "Project list dirs" },
			{ "<leader>po", "<cmd>WorkspacesOpen<CR>", desc = "Project open" },
			{ "<leader>ps", "<cmd>AutoSession save<CR>", desc = "Project save session" },
		},
		opts = {
			hooks = {
				open = { "AutoSession restore" }, -- Calls the auto-session plugin.
			},
		},
	},
	-- Manages open windows, layout, files, etc. saved to standard session
	-- files. Invoked automatically when switching workspace.
	{
		"rmagatti/auto-session",
		lazy = false,

		---enables autocomplete for opts
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
			auto_restore = false,
			auto_save = false,
			suppressed_dirs = { "~/", "~/Dropbox", "~/Downloads", "/" },
			-- log_level = 'debug',

			-- Ties scope plugin into the process. I didn't find it worked
			-- reliably, however, so I'm not sure it's worth it. Still, using
			-- code here worked better than the auto-session configuration I
			-- tried in the scope plugin spec. Go figure.
			pre_save_cmds = {
				-- "ScopeSaveState",
			},
			pre_restore_cmds = {
				-- might not be necessary, but save current harpoon data when we're about to restore a session
				-- function()
				-- 	require("harpoon"):sync()
				-- end,
			},
			post_restore_cmds = {
				-- function()
				-- 	-- vim.notify('calling harpoon sync after restore')
				-- 	local harpoon = require("harpoon")
				-- 	local hdata = require("harpoon.data")
				--
				-- 	-- this is the only way i found to force harpoon to reread data from the disk rather
				-- 	-- than using what's in memory
				-- 	require("harpoon").data = hdata.Data:new(harpoon.config)
				-- end,
				-- "ScopeLoadState",
			},
		},
	},
}
