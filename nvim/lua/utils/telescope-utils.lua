local M = {}

local devicons = require("nvim-web-devicons")
local entry_display = require("telescope.pickers.entry_display")

-- Custom buffer entry maker.
function M.buffer_entry_maker(opts)
	opts = opts or {}
	local default_icons, _ = devicons.get_icon("file", "", { default = true })

	local bufnrs = vim.tbl_filter(function(b)
		return 1 == vim.fn.buflisted(b)
	end, vim.api.nvim_list_bufs())

	local max_bufnr = math.max(unpack(bufnrs))
	local bufnr_width = #tostring(max_bufnr)

	local max_bufname = math.max(unpack(vim.tbl_map(function(bufnr)
		return vim.fn.strdisplaywidth(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:t"))
	end, bufnrs)))

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = bufnr_width },
			{ width = 4 },
			{ width = vim.fn.strwidth(default_icons) },
			{ width = max_bufname },
			{ remaining = true },
		},
	})

	local make_display = function(entry)
		return displayer({
			{ entry.bufnr, "TelescopeResultsNumber" },
			{ entry.indicator, "TelescopeResultsComment" },
			{ entry.devicons, entry.devicons_highlight },
			entry.file_name,
			{ entry.dir_name, "Comment" },
		})
	end

	return function(entry)
		local bufname = entry.info.name ~= "" and entry.info.name or "[No Name]"
		local hidden = entry.info.hidden == 1 and "h" or "a"
		local readonly = vim.api.nvim_buf_get_option(entry.bufnr, "readonly") and "=" or " "
		local changed = entry.info.changed == 1 and "+" or " "
		local indicator = entry.flag .. hidden .. readonly .. changed

		local dir_name = vim.fn.fnamemodify(bufname, ":p:h")
		local file_name = vim.fn.fnamemodify(bufname, ":p:t")

		local icons, highlight = devicons.get_icon(bufname, string.match(bufname, "%a+$"), { default = true })

		return {
			valid = true,

			value = bufname,
			ordinal = entry.bufnr .. " : " .. file_name,
			display = make_display,

			bufnr = entry.bufnr,

			lnum = entry.info.lnum ~= 0 and entry.info.lnum or 1,
			indicator = indicator,
			devicons = icons,
			devicons_highlight = highlight,

			file_name = file_name,
			dir_name = dir_name,
		}
	end
end

-- A cool YAML symbol picker I got working from the following:
-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#fuzzy-search-among-yaml-objects
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")

local function visit_yaml_node(node, name, yaml_path, result, file_path, bufnr)
	local key = ""
	if node:type() == "block_mapping_pair" then
		local field_key = node:field("key")[1]
		key = vim.treesitter.get_node_text(field_key, bufnr)
	end

	if key ~= nil and string.len(key) > 0 then
		table.insert(yaml_path, key)
		local line, col = node:start()
		table.insert(result, {
			lnum = line + 1,
			col = col + 1,
			bufnr = bufnr,
			filename = file_path,
			text = table.concat(yaml_path, "."),
		})
	end

	for node, name in node:iter_children() do
		visit_yaml_node(node, name, yaml_path, result, file_path, bufnr)
	end

	if key ~= nil and string.len(key) > 0 then
		table.remove(yaml_path, table.maxn(yaml_path))
	end
end

local function gen_from_yaml_nodes(opts)
	local displayer = entry_display.create({
		separator = " │ ",
		items = {
			{ width = 5 },
			{ remaining = true },
		},
	})

	local make_display = function(entry)
		return displayer({
			{ entry.lnum, "TelescopeResultsSpecialComment" },
			{
				entry.text,
				function()
					return {}
				end,
			},
		})
	end

	return function(entry)
		return make_entry.set_default_entry_mt({
			ordinal = entry.text,
			display = make_display,
			filename = entry.filename,
			lnum = entry.lnum,
			text = entry.text,
			col = entry.col,
		}, opts)
	end
end

function M.yaml_symbols_picker(opts)
    local opts = opts or {}
	local yaml_path = {}
	local result = {}
	local bufnr = vim.api.nvim_get_current_buf()
	local ft = vim.api.nvim_buf_get_option(bufnr, "ft")
	local tree = vim.treesitter.get_parser(bufnr, ft):parse()[1]
	local file_path = vim.api.nvim_buf_get_name(bufnr)
	local root = tree:root()
	for node, name in root:iter_children() do
		visit_yaml_node(node, name, yaml_path, result, file_path, bufnr)
	end

	-- return result
	pickers
		.new(opts, {
			prompt_title = "YAML symbols",
			finder = finders.new_table({
				results = result,
				entry_maker = opts.entry_maker or gen_from_yaml_nodes(opts),
			}),
			sorter = conf.generic_sorter(opts),
			previewer = conf.grep_previewer(opts),
		})
		:find()
end

return M

