local M = {}

-- Platform names.
local platform_windows = "Windows_NT"
local platform_macos = "Darwin"

-- System host names.
local hostname_gandalf = "Gandalf"
local hostname_eomer = "Eomer.local"

M.whaler = {
	{
		platform = platform_windows,
		hostname = hostname_gandalf,
		directories = {
			{ path = "E:\\Src", alias = "Personal", key = "p" },
			{ path = "~/Dropbox", alias = "Dropbox", key = "d" },
			{ path = "~/Documents/Obsidian", alias = "Obsidian", key = "o" },
		},
		oneoff_directories = {
			{ path = "~/AppData/Local/nvim", alias = "Nvim Config", key = "c" },
			{ path = "~/AppData/Local/nvim-data", alias = "Nvim Data", key = "D" },
		},
	},
	{
		platform = platform_macos,
		hostname = hostname_eomer,
		directories = {
			{ path = "~/src", alias = "Personal", key = "p" },
			{ path = "~/Documents/Obsidian", alias = "Obsidian", key = "o" },
		},
		oneoff_directories = {
			{ path = "~/.config/nvim", alias = "Nvim Config", key = "c" },
			{ path = "~/.local/share", alias = "Nvim Data", key = "D" },
		},
	},
}

function M.get_env_data(section, key, opts)
	local defaults = {
		platform = vim.loop.os_uname().sysname,
		hostname = vim.fn.hostname(),
	}

	local search = vim.tbl_deep_extend("force", defaults, opts or {})
	for _, v in pairs(M[section]) do
		local pmatch = (
			v["platform"] == nil
			or search["platform"] == nil
			or (v.platform:upper() == search.platform:upper())
		)
		local hmatch = (
			v["hostname"] == nil
			or search["hostname"] == nil
			or (v.hostname:upper() == search.hostname:upper())
		)
		if pmatch and hmatch then
			return v[key]
		end
	end
end

return M
