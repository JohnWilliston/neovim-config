local cmp = require("cmp")
local configutils = require("utils.config-utils")
local luasnip = require("luasnip")

local kind_icons = {
	Text = "",
	Method = "󰆧",
	Function = "󰊕",
	Constructor = "",
	Field = "󰇽",
	Variable = "󰂡",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈙",
	Reference = "",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "󰅲",
}

-- This is me fiddling around with alternate icons while working on some
-- issues with my fork of the  cmp-nvim-lsp-document-symbol plugin.
-- Glyph reference: https://raw.githubusercontent.com/archdroid20/nerd-fonts-complete/refs/heads/master/glyphnames.json
local unused_but_new_kind_icons = {
	File = "󰈙", -- 01 File
	Module = "", -- 02 Module
	Unit = "", -- 03 Namespace
	Folder = "󰉋", -- 04 Package
	Class = "󰠱", -- 05 Class
	Method = "󰆧", -- 06 Method
	Property = "󰜢", -- 07 Property
	Field = "󰇽", -- 08 Field
	Constructor = "", -- 09 Constructor
	Enum = "", -- 10 Enum
	Interface = "", -- 11 Interface
	Function = "󰊕", -- 12 Function
	Variable = "󰂡", -- 13 Variable
	Constant = "󰏿", -- 14 Constant
	Text = "", -- 15 String
	Value = "󰎠", -- 16 Number
	-- Boolean?
	Boolean = "", -- 17 Boolean
	-- Array?
	Array = "", -- 18 Array
	-- Object?
	Object = "O", -- 19 Object
	Keyword = "󰌋", -- 20 Key
	-- Null?
	Null = "󰟢", -- 21 Null
	EnumMember = "", -- 22 Enum Member
	Struct = "", -- 23 Struct
	Event = "", -- 24 Event
	Operator = "󰆕", -- 25 Operator
	TypeParameter = "󰅲", -- 26 Type Parameter
}

local custom_menu_icon = {
	Calc = " 󰃬 ",
}

-- My preferred default mappings, reused in multiple places below.
local cmd_mapping = {
	["<Up>"] = { c = cmp.mapping.select_prev_item() },
	["<Down>"] = { c = cmp.mapping.select_next_item() },
	["<C-Space>"] = { c = cmp.mapping.complete({}) },
	["<C-n>"] = { c = cmp.mapping.select_next_item() },
	["<C-p>"] = { c = cmp.mapping.select_prev_item() },
	["<C-e>"] = { c = cmp.mapping.abort() },
	["<C-y>"] = {
		c = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
	},
}

return {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		-- Autocompletion snippets plugin
		{ "saadparwaiz1/cmp_luasnip" },
		-- Completion sources
		{ "hrsh7th/cmp-nvim-lsp" }, -- neovim builtin LSP client
		-- { "hrsh7th/cmp-path" }, -- path
		{ "FelipeLema/cmp-async-path" },
		{ "hrsh7th/cmp-buffer" }, -- buffer words
		{ "hrsh7th/cmp-nvim-lua" }, -- nvim lua
		{ "hrsh7th/cmp-emoji" }, -- emoji
		{ "dmitmel/cmp-digraphs" },
		{ "hrsh7th/cmp-cmdline" }, -- vim's cmdline.
		{ "hrsh7th/cmp-calc" }, -- doing simple calculations
		{ "hrsh7th/cmp-omni" }, -- Nvim's omnifunc
		{ "hrsh7th/cmp-nvim-lsp-document-symbol" }, -- improved searching through LSP data
		{ "chrisgrieser/cmp_yanky" },
		{ "dmitmel/cmp-cmdline-history" },
		{ "max397574/cmp-greek" },
		{ "kristijanhusak/vim-dadbod-completion" },
		{ "ray-x/cmp-sql" },
		{
			"SergioRibera/cmp-dotenv",
			init = function()
				-- Add a helpful function to dump all environment variables.
				vim.api.nvim_create_user_command("DotEnvDumpAll", function()
					local dotenv = require("cmp-dotenv.dotenv")
					local vars = dotenv.get_all_env()
					for var, tbl in pairs(vars) do
						print(string.format("%s = %s", var, tbl.value or ""))
					end
				end, {})
			end,
		},

		-- TODO: Look into https://github.com/teramako/cmp-cmdline-prompt.nvim
		-- TODO: Look into https://github.com/andersevenrud/cmp-tmux
	},
	init = function()
		-- I'm adding a custom Vim global to be able to toggle completion on
		-- the fly as needed. This will be used below.
		vim.g.cmp = true
	end,
	opts = {
		enabled = function()
			-- The following is copied from the plugin default.
			local disabled = false
			disabled = disabled or (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
			disabled = disabled or (vim.fn.reg_recording() ~= "")
			disabled = disabled or (vim.fn.reg_executing() ~= "")
			-- Check the buffer variable to see if it's been disabled.
			disabled = disabled or not configutils.is_buffer_completion_enabled(0)
			-- The 'and' condition is all I added for a global toggle option.
			return not disabled and vim.g.cmp
		end,

		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},

		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				-- Our little short circuit to provide a custom calculation icon.
				-- Requires the cmp-calc plugin to be in place to provide as a source.
				if entry.source.name == "calc" then
					vim_item.kind = custom_menu_icon.Calc
				else
					vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- Concatenates the icon with the name of the kind.
				end
				-- Source
				vim_item.menu = ({
					buffer = "[Buffer]",
					nvim_lsp = "[LSP]",
					luasnip = "[LuaSnip]",
					nvim_lua = "[Lua]",
					latex_symbols = "[LaTeX]",
					cmp_yanky = "[Yank]",
				})[entry.source.name]
				return vim_item
			end,
		},

		window = {
			completion = cmp.config.window.bordered({
				border = "rounded",
				winhighlight = "Normal:CmpPmenu,FloatBorder:DiffChange,CursorLine:PmenuSel,Search:None",
				col_offset = -3,
				side_padding = 2,
			}),
			documentation = cmp.config.window.bordered({
				border = "rounded",
				winhighlight = "Normal:CmpPmenu,FloatBorder:DiffChange,CursorLine:PmenuSel,Search:None",
				col_offset = -3,
				side_padding = 2,
			}),
		},

		mapping = cmp.mapping.preset.insert({
			["<C-u>"] = cmp.mapping.scroll_docs(-4),
			["<C-d>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.confirm(), -- Ctrl + Space doesn't seem to work at all.
			["<C-e>"] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
			["<CR>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					if luasnip.expandable() then
						luasnip.expand()
					else
						cmp.confirm({
							select = true,
						})
					end
				else
					fallback()
				end
			end),

			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.locally_jumpable(1) then
					luasnip.jump(1)
				else
					fallback()
				end
			end, { "i", "s" }),

			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.locally_jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),

		sources = cmp.config.sources({
			{ name = "lazydev" },
			{ name = "nvim_lsp" },
			-- {
			--              name = "path",
			--              option = {
			--                  trailing_slash = false,
			--                  label_trailing_slash = false,
			--              },
			--          },
			{
				name = "async_path",
				-- I can't seem to get these options to do anything.
				option = {
					trailing_slash = false,
					label_trailing_slash = false,
				},
			},
			{ name = "buffer" },
			{ name = "nvim_lua" },
			{ name = "luasnip" },
			{ name = "emoji" },
			{ name = "digraphs" },
			{ name = "calc" },
			{ name = "omni" },
			{ name = "nvim_lsp_document_symbol" },
			{
				name = "cmp_yanky",
				option = {
					onlyCurrentFiletype = false,
					minLength = 3,
				},
			},
			{ name = "greek" },
			{ name = "vim-dadbod-completion" },
			{ name = "sql" },
			{
				name = "dotenv",
				option = {
					eval_on_confirm = false,
				},
			},
		}),
	},
	config = function(_, opts)
		local cmp = require("cmp")
		cmp.setup(opts)

		-- Command-line history setup for all but commands.
		for _, cmd_type in ipairs({ "/", "?", "@" }) do
			cmp.setup.cmdline(cmd_type, {
				mapping = cmd_mapping,
				sources = {
					{ name = "cmdline_history" },
					{ name = "buffer" },
				},
			})
		end

		-- Command-line history setup for commands.
		cmp.setup.cmdline(":", {
			mapping = cmd_mapping,
			-- mapping = cmp.mapping.preset.cmdline({
			--     ["<C-n>"] = select_or_fallback(cmp.select_next_item),
			--     ["<C-p>"] = select_or_fallback(cmp.select_prev_item),
			-- }),
			-- mapping = cmp.mapping.preset.cmdline({
			--     ["<C-n>"] = { c = cmp.mapping.select_next_item() },
			--     ["<C-p>"] = { c = cmp.mapping.select_prev_item() },
			-- }),
			-- mapping = cmp.mapping.preset.cmdline(
			--              {
			--                  -- Use default nvim history scrolling
			--                  ["<C-n>"] = {
			--                      c = false,
			--                  },
			--                  ["<C-p>"] = {
			--                      c = false,
			--                  },
			--              }
			--          ),
			sources = cmp.config.sources({
				-- {
				-- 	name = "path",
				-- 	option = {
				-- 		trailing_slash = false,
				-- 		label_trailing_slash = false,
				-- 	},
				-- },
				{ name = "cmdline_history" },
				{
					name = "cmdline",
					option = {
						ignore_cmds = { "Man", "!" },
					},
				},
				{ name = "buffer" },
				{
					name = "async_path",
					-- I can't seem to get these options to do anything.
					option = {
						trailing_slash = false,
						label_trailing_slash = false,
					},
				},
			}),
		})
	end,
}
