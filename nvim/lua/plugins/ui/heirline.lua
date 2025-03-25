-- This is not my finest configuration coding to say the least. The following
-- is a complete MESS of false starts, half-finished things, and problems I've
-- yet to resolve because there are too many things I still don't understand
-- about the heirline plugin and its mechanisms. I set out to create a status
-- line for myself that would be essentially what I had with lualine, only more
-- easily configurable and flexible. After spending a couple days knocing this
-- out, I can absolutely see how heirline is more powerful and customizable, but
-- I'm not sure it was worth the effort. Perhaps it will be once I better grasp
-- its subtleties, particularly in terms of graphical flair.
return {
	"rebelot/heirline.nvim",
	dependencies = {
		"Zeioth/heirline-components.nvim",
		"SmiteshP/nvim-navic",
	},
	enabled = true,
	config = function()
		local heirline = require("heirline")
		local utils = require("heirline.utils")
		local conditions = require("heirline.conditions")
		local lib = require("heirline-components.all")

		-- This might well be more trouble than it's worth, but I'm trying to
		-- make my heirline configuration colorscheme independent. The way one
		-- does that is apparently to base colors on the current scheme via
		-- their highlight names. We'll see if it's worth it.
		--
		-- I've learned there are some colors built in by name, such as "fg"
		-- as described by the help for 'fg'. The following are the values from
		-- string.format("%x", vim.api.nvim_get_color_by_name("name"))
		--
		-- NONE		no color (transparent)
		-- bg		use normal background color "#0a0b16"
		-- background	use normal background color
		-- fg		use normal foreground color "#c0cAF5"
		-- foreground	use normal foreground color
		--
		-- And then there are the actual color names as well, see the help
		-- on 'ctermbg' for more details:
		--
		-- NR-16   NR-8    COLOR NAME ~
		-- 0	    0	    Black
		-- 1	    4	    DarkBlue
		-- 2	    2	    DarkGreen
		-- 3	    6	    DarkCyan
		-- 4	    1	    DarkRed
		-- 5	    5	    DarkMagenta
		-- 6	    3	    Brown, DarkYellow
		-- 7	    7	    LightGray, LightGrey, Gray, Grey
		-- 8	    0*	    DarkGray, DarkGrey
		-- 9	    4*	    Blue, LightBlue
		-- 10	    2*	    Green, LightGreen
		-- 11	    6*	    Cyan, LightCyan
		-- 12	    1*	    Red, LightRed
		-- 13	    5*	    Magenta, LightMagenta
		-- 14	    3*	    Yellow, LightYellow
		-- 15	    7*	    White
		--
		-- And finally we come to the colors for various syntax:
        -- See https://neovim.io/doc/user/syntax.html#group-name
		-- Constant
		-- String
		-- Character
		-- number
		-- Booleans
		-- Float
		-- You can get those colors too.
		local function setup_colors()
			return {
				bright_green = utils.get_highlight("string").fg,
				bright_blue = utils.get_highlight("function").fg,
				--directory = utils.get_highlight("Keyword").fg, -- utils.get_highlight("Directory").fg,
				directory = utils.get_highlight("Comment").fg, -- utils.get_highlight("Directory").fg,
				neutral = utils.get_highlight("comment").fg,
				orange = utils.get_highlight("number").fg,
				red = utils.get_highlight("error").fg,
				status_line = utils.get_highlight("StatusLine").bg,
				status_text = utils.get_highlight("DiffText").bg,
				mode_n = utils.get_highlight("Keyword").fg,
				mode_i = utils.get_highlight("Character").fg,
				mode_c = utils.get_highlight("Constant").fg,
				mode_t = utils.get_highlight("Error").fg,
				mode_v = utils.get_highlight("Function").fg,
			}
		end
		vim.api.nvim_create_augroup("Heirline", { clear = true })
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				utils.on_colorscheme(setup_colors)
				heirline.load_colors(lib.hl.get_colors())
			end,
			group = "Heirline",
		})

		local colors = setup_colors()
		heirline.load_colors(lib.hl.get_colors())
		--print(vim.inspect(colors))

		-- Probably a better way to provide spacing, but I don't know it. Yet.
		local singleSpace = {
			provider = " ",
		}

		local mode_names = { -- change the strings if you like it vvvvverbose!
			n = "N",
			no = "N?",
			nov = "N?",
			noV = "N?",
			["no\22"] = "N?",
			niI = "Ni",
			niR = "Nr",
			niV = "Nv",
			nt = "Nt",
			v = "V",
			vs = "Vs",
			V = "V_",
			Vs = "Vs",
			["\22"] = "^V",
			["\22s"] = "^V",
			s = "S",
			S = "S_",
			["\19"] = "^S",
			i = "I",
			ic = "Ic",
			ix = "Ix",
			R = "R",
			Rc = "Rc",
			Rx = "Rx",
			Rv = "Rv",
			Rvc = "Rv",
			Rvx = "Rv",
			c = "C",
			cv = "Ex",
			r = "...",
			rm = "M",
			["r?"] = "?",
			["!"] = "!",
			t = "T",
		}

		-- mode_colors = {
		--     --n = "red" ,
		--     --n = colors.directory,
		--     n = "teal",
		--     i = "green",
		--     v = "cyan",
		--     V =  "cyan",
		--     ["\22"] =  "cyan",
		--     c =  "orange",
		--     s =  "purple",
		--     S =  "purple",
		--     ["\19"] =  "purple",
		--     R =  "orange",
		--     r =  "orange",
		--     ["!"] =  "red",
		--     t =  "darkred",
		-- }

		mode_colors = {
			--n = "red" ,
			--n = colors.directory,
			n = colors.mode_n,
			i = colors.mode_i,
			v = colors.mode_v,
			V = colors.mode_v,
			["\22"] = "cyan",
			c = colors.mode_c,
			s = "purple",
			S = "purple",
			["\19"] = "purple",
			R = "orange",
			r = "orange",
			["!"] = "red",
			t = colors.mode_t,
		}

		-- A nicely color-coded indicator giving colorful mode information.
		local modeBlock1 = {
			-- get vim current mode, this information will be required by the provider
			-- and the highlight functions, so we compute it only once per component
			-- evaluation and store it as a component attribute
			init = function(self)
				self.mode = vim.fn.mode(1) -- :h mode()
			end,
			-- We can now access the value of mode() that, by now, would have been
			-- computed by `init()` and use it to index our strings dictionary.
			-- note how `static` fields become just regular attributes once the
			-- component is instantiated.
			-- To be extra meticulous, we can also add some vim statusline syntax to
			-- control the padding and make sure our string is always at least 2
			-- characters long. Plus a nice Icon.
			provider = function(self)
				-- Glyphs here: https://www.nerdfonts.com/cheat-sheet?q=nf-linux-
				--return " %2("..self.mode_names[self.mode].."%)"
				--return "  %2("..self.mode_names[self.mode].."%)"
				--local surround = { "█", "" }
				-- return " %-2("..self.mode_names[self.mode].."%) "
				return " %-2(" .. mode_names[self.mode] .. "%) "
			end,
			-- Same goes for the highlight. Now the foreground will change according to the current mode.
			hl = function(self)
				local mode = self.mode:sub(1, 1) -- get only the first mode character
				--return { fg = self.mode_colors[mode], bold = true, }
				-- Note the use of the neutral color that is *NOT* part of the
				-- usual scheme. I do this for continuity with the next sections.
				-- return { bg = self.mode_colors[mode], fg = colors.neutral, bold = true, }
				-- return { bg = self.mode_colors[mode], fg = colors.directory, bold = true, }
				return { bg = mode_colors[mode], fg = colors.status_text, bold = true }
			end,
			-- Re-evaluate the component only on ModeChanged event!
			-- Also allows the statusline to be re-evaluated when entering operator-pending mode
			update = {
				"ModeChanged",
				pattern = "*:*",
				callback = vim.schedule_wrap(function()
					vim.cmd("redrawstatus")
				end),
			},
		}

		local modeBlock2 = {
			-- get vim current mode, this information will be required by the provider
			-- and the highlight functions, so we compute it only once per component
			-- evaluation and store it as a component attribute
			init = function(self)
				self.mode = vim.fn.mode(1) -- :h mode()
			end,
			provider = "",
			hl = function(self)
				local mode = self.mode:sub(1, 1) -- get only the first mode character
                return { bg = mode_colors[mode], fg = colors.directory }
            end,
		}

		local fileNameBlock = {
			-- let's first set up some attributes needed by this component and its children
			init = function(self)
				self.filename = vim.api.nvim_buf_get_name(0)
			end,
		}
		-- We can now define some children separately and add them later

		local fileIcon = {
			init = function(self)
				local filename = self.filename
				local extension = vim.fn.fnamemodify(filename, ":e")
				self.icon, self.icon_color =
					require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
				-- Variant below to use the mini.icons library instead.
				--self.icon = require("mini.icons").get("extension", extension)
				--self.icon_color = require("mini.icons").get_icon_color(filename, extension, { default = true })
			end,
			provider = function(self)
				return self.icon
			end,
			hl = function(self)
				return { fg = self.icon_color }
			end,
		}

		local fileName = {
			provider = function(self)
				-- first, trim the pattern relative to the current directory. For other
				-- options, see :h filename-modifers
				local filename = vim.fn.fnamemodify(self.filename, ":.")
				if filename == "" then
					return "[No Name]"
				end
				-- now, if the filename would occupy more than 1/4th of the available
				-- space, we trim the file path to its initials
				-- See Flexible Components section below for dynamic truncation
				if not conditions.width_percent_below(#filename, 0.25) then
					filename = vim.fn.pathshorten(filename)
				end
				return filename
			end,
		}

		local fileFlags = {
			{
				condition = function()
					return vim.bo.modified
				end,
				provider = " [+]",
				hl = { fg = "green" },
			},
			{
				condition = function()
					return not vim.bo.modifiable or vim.bo.readonly
				end,
				provider = " ",
				hl = { fg = "orange" },
			},
		}

		-- Now, let's say that we want the filename color to change if the buffer is
		-- modified. Of course, we could do that directly using the FileName.hl field,
		-- but we'll see how easy it is to alter existing components using a "modifier"
		-- component

		local fileNameModifier = {
			hl = function()
				if vim.bo.modified then
					-- use `force` because we need to override the child's hl foreground
					return { fg = "white", bold = true, force = true }
				end
			end,
		}

		local fileSize = {
			hl = { fg = "fg" },
			provider = function()
				-- stackoverflow, compute human readable file size
				local suffix = { "b", "k", "M", "G", "T", "P", "E" }
				local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
				fsize = (fsize < 0 and 0) or fsize
				if fsize < 1 then
					return ""
				end
				if fsize < 1024 then
					return " " .. fsize .. suffix[1]
				end
				local i = math.floor((math.log(fsize) / math.log(1024)))
				return string.format(" (%.2f%s)", fsize / math.pow(1024, i), suffix[i + 1])
			end,
		}

		local fileLastModified = {
			hl = { fg = colors.directory },
			provider = function()
				local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
				return (ftime > 0) and os.date(" [%c]", ftime)
			end,
		}

		-- let's add the children to our FileNameBlock component
		fileNameBlock = utils.insert(
			fileNameBlock,
			fileIcon,
			singleSpace,
			utils.insert(fileNameModifier, fileName), -- a new table where FileName is a child of FileNameModifier
			fileFlags,
			fileSize,
			--fileLastModified,
			{ provider = "%<" } -- this means that the statusline is cut here when there's not enough space
		)

		local navicSymbolsBlock = {
			condition = function()
				return require("nvim-navic").is_available()
			end,
			provider = function()
				return require("nvim-navic").get_location()
			end,
			update = "CursorMoved",
			hl = "StatusLine",
		}

		-- local trouble = require("trouble")
		-- local trouble_symbols = trouble.statusline({
		--     mode = "symbols",
		--     groups = {},
		--     title = false,
		--     filter = { range = true },
		--     format = "{kind_icon}{symbol.name:Normal}",
		--     hl_group = "StatusLine", -- Tokyonight status line highlight group
		-- })

		-- local troubleSymbols = {
		--     --condition = vim.g.trouble_lualine,
		--     provider = trouble_symbols.get,
		-- }

		local gitBlock = {
			condition = conditions.is_git_repo,

			init = function(self)
				self.status_dict = vim.b.gitsigns_status_dict
				self.has_changes = self.status_dict.added ~= 0
					or self.status_dict.removed ~= 0
					or self.status_dict.changed ~= 0
			end,

			-- hl = { fg = "fg", bg = colors.neutral },
			-- hl = { fg = colors.status_text, bg = colors.directory },
			hl = { fg = "fg", bg = colors.directory },

			{ -- git branch name
				provider = function(self)
					return "  " .. self.status_dict.head
				end,
				hl = { bold = true },
			},
			-- You could handle delimiters, icons and counts similar to Diagnostics
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = "(",
			},
			{
				provider = function(self)
					local count = self.status_dict.added or 0
					return count > 0 and ("+" .. count)
				end,
				--hl = { fg = colors.git.add },
				hl = { fg = colors.bright_green },
			},
			{
				provider = function(self)
					local count = self.status_dict.removed or 0
					return count > 0 and ("-" .. count)
				end,
				--hl = { fg = colors.git.delete },
				hl = { fg = colors.red },
			},
			{
				provider = function(self)
					local count = self.status_dict.changed or 0
					return count > 0 and ("~" .. count)
				end,
				--hl = { fg = colors.git.change },
				hl = { fg = colors.bright_blue },
			},
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = ")",
				padding = { right = 1 },
			},
		}

		local cmdInfo = {
			macro_recording = {
				condition = function()
					return vim.fn.reg_recording() ~= "" --and vim.o.cmdheight == 0
				end,
				provider = " ",
				hl = { fg = "red", bold = true },
				utils.surround({ "[", "]" }, nil, {
					provider = function()
						return vim.fn.reg_recording()
					end,
					hl = { fg = "red", bold = true },
				}),
				update = {
					"RecordingEnter",
					"RecordingLeave",
				},
			},
			search_count = {
				icon = { kind = "Search", padding = { right = 1 } },
				padding = { left = 1 },
				condition = lib.condition.is_hlsearch,
			},
			showcmd = {
				padding = { left = 1 },
				condition = lib.condition.is_statusline_showcmd,
			},
			surround = {
				separator = "center",
				color = "cmd_info_bg",
				condition = function()
					return lib.condition.is_hlsearch()
						or lib.condition.is_macro_recording()
						or lib.condition.is_statusline_showcmd()
				end,
			},

			--condition = function() return vim.opt.cmdheight:get() == 0 end,
			--hl = colors.hl.get_attributes "cmd_info",
		}

		local macroRecorderBlock = {
			condition = function()
				return vim.fn.reg_recording() ~= "" --and vim.o.cmdheight == 0
			end,
			provider = " ",
			hl = { fg = "red", bold = true },
			utils.surround({ "[", "] " }, nil, {
				provider = function()
					return vim.fn.reg_recording()
				end,
				hl = { fg = "red", bold = true },
			}),
			update = {
				"RecordingEnter",
				"RecordingLeave",
			},
		}

		local fileInfoBlock = {
			provider = function()
				local fileFormatSymbols = {
					unix = "", -- e712
					dos = "", -- e70f
					mac = "", -- e711
				}
				return string.format(" %s %s", fileFormatSymbols[vim.bo.fileformat], string.upper(vim.bo.fileencoding))
			end,
			-- hl = { fg = colors.neutral, bg = colors.directory },
			-- hl = { fg = colors.status_text, bg = colors.directory },
			hl = { fg = "fg", bg = colors.directory },
		}

		local spellCheckBlock = {
			condition = function()
				return vim.wo.spell
			end,
			provider = "SPELL ",
			hl = { bold = true, fg = "orange" },
		}

		local diagnosticsBlock = {

			condition = conditions.has_diagnostics,
			static = { error_icon = "  ", warn_icon = "  ", info_icon = "  ", hint_icon = "  " },
			hl = { bg = colors.neutral },

			-- static = {
			--     error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
			--     warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
			--     info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
			--     hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
			-- },

			init = function(self)
				self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
			end,

			update = { "DiagnosticChanged", "BufEnter" },

			{
				condition = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) > 0,
				provider = function(self)
					-- 0 is just another output, we can decide to print it or not!
					return self.errors > 0 and (self.error_icon .. self.errors)
				end,
				hl = "DiagnosticError",
			},
			{
				condition = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) > 0,
				provider = function(self)
					return self.warnings > 0 and (self.warn_icon .. self.warnings)
				end,
				hl = "DiagnosticWarn",
			},
			{
				condition = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }) > 0,
				provider = function(self)
					return self.info > 0 and (self.info_icon .. self.info)
				end,
				hl = "DiagnosticInfo",
			},
			{
				condition = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }) > 0,
				provider = function(self)
					return self.hints > 0 and (self.hint_icon .. self.hints)
				end,
				hl = "DiagnosticHint",
			},
		}

		local leftSeparator = {
			-- hl = { fg = colors.neutral },
			hl = { fg = colors.directory },
			provider = "█",
		}

		-- Largely borrowed from: https://codecompanion.olimorris.dev/usage/events#example-heirline-nvim-integration
		local aiCodeCompanionBlock = {
			static = {
				processing = false,
			},
			update = {
				"User",
				pattern = "CodeCompanionRequest*",
				callback = function(self, args)
					if args.match == "CodeCompanionRequestStarted" then
						self.processing = true
					elseif args.match == "CodeCompanionRequestFinished" then
						self.processing = false
					end
					vim.cmd("redrawstatus")
				end,
			},
			{
				condition = function(self)
					return self.processing
				end,
				provider = "   ",
				hl = { fg = colors.bright_green },
			},
		}

		-- Cheat Sheet here: https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points
		-- Glyphs here: https://www.nerdfonts.com/cheat-sheet?q=nf-ple-
		--local component_delimiters = { "", "" }
		local component_delimiters = { "", "" } -- 0xe0b6, 0xe0b4
		--local rightmost = { "", "" }
		local leftmost = { "█", "" }
		local rightmost = { "", "█" }
		local secondrightmost = { "", "" }

		local cursorPosBlock = {
			{
				provider = " %7(%l/%3L%):%2c %P ",
				-- hl = { fg = colors.neutral, bg = colors.directory, bold = true },
				-- hl = { fg = colors.status_text, bg = colors.directory, bold = true },
				hl = { fg = "fg", bg = colors.directory, bold = true },
			},
			{
				static = {
					sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
				},
				provider = function(self)
					local curr_line = vim.api.nvim_win_get_cursor(0)[1]
					local lines = vim.api.nvim_buf_line_count(0)
					local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
					return string.rep(self.sbar[i], 1) .. " "
				end,
				-- hl = { fg = colors.neutral, bg = colors.directory, bold = true },
				hl = { fg = colors.status_text, bg = colors.directory, bold = true },
			},
		}

		local finalStatusLine = {
			hl = { fg = "fg", bg = "bg" },
			modeBlock1,
			modeBlock2,
			diagnosticsBlock,
			gitBlock,
			leftSeparator,
			singleSpace,
			fileNameBlock,
			singleSpace,
			--troubleSymbols,
			navicSymbolsBlock,
			lib.component.fill(),
			aiCodeCompanionBlock,
			macroRecorderBlock,
			spellCheckBlock,
			--lib.component.cmd_info(cmdInfo),
			{
				provider = "",
				hl = { fg = colors.status_line, bg = colors.directory },
			},
			fileInfoBlock,
			{
				provider = " │",
				hl = { fg = colors.status_line, bg = colors.directory },
			},
			cursorPosBlock,
		}

		-- Here are the components for the tab line.

		local tablineBufnr = {
			provider = function(self)
				return tostring(self.bufnr) .. "."
			end,
			hl = function(self)
				return { bold = self.is_active or self.is_visible, italic = false }
			end,
		}

		-- we redefine the filename component, as we probably only want the tail and not the relative path
		local TablineFileName = {
			provider = function(self)
				local filename = self.filename
				filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
				return filename
			end,
			hl = function(self)
				return { bold = self.is_active or self.is_visible, italic = false }
			end,
		}

		-- this looks exactly like the FileFlags component that we saw in
		-- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
		-- also, we are adding a nice icon for terminal buffers.
		local TablineFileFlags = {
			{
				condition = function(self)
					return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
				end,
				provider = "[+]",
				hl = { fg = "green" },
			},
			{
				condition = function(self)
					return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
						or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
				end,
				provider = function(self)
					if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
						return "  "
					else
						return " "
					end
				end,
				hl = { fg = "orange" },
			},
		}

		-- Here the filename block finally comes together
		local TablineFileNameBlock = {
			init = function(self)
				self.filename = vim.api.nvim_buf_get_name(self.bufnr)
			end,
			hl = function(self)
				if self.is_active then
					return "TabLineSel"
					-- why not?
					-- elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
					--     return { fg = "gray" }
				else
					return "TabLine"
				end
			end,
			on_click = {
				callback = function(_, minwid, _, button)
					if button == "m" then -- close on mouse middle click
						vim.schedule(function()
							vim.api.nvim_buf_delete(minwid, { force = false })
						end)
					else
						vim.api.nvim_win_set_buf(0, minwid)
					end
				end,
				minwid = function(self)
					return self.bufnr
				end,
				name = "heirline_tabline_buffer_callback",
			},
			tablineBufnr,
			singleSpace,
			fileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
			singleSpace,
			TablineFileName,
			singleSpace,
			TablineFileFlags,
		}

		-- a nice "x" button to close the buffer
		local TablineCloseButton = {
			condition = function(self)
				return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
					and not vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal"
			end,
			{ provider = " " },
			{
				provider = "❌",
				hl = { fg = "gray" },
				on_click = {
					callback = function(_, minwid)
						vim.schedule(function()
							vim.api.nvim_buf_delete(minwid, { force = false })
							vim.cmd.redrawtabline()
						end)
					end,
					minwid = function(self)
						return self.bufnr
					end,
					name = "heirline_tabline_close_buffer_callback",
				},
			},
		}

		local TablinePicker = {
			condition = function(self)
				return self._show_picker
			end,
			init = function(self)
				local bufname = vim.api.nvim_buf_get_name(self.bufnr)
				bufname = vim.fn.fnamemodify(bufname, ":t")
				local label = bufname:sub(1, 1)
				local i = 2
				while self._picker_labels[label] do
					if i > #bufname then
						break
					end
					label = bufname:sub(i, i)
					i = i + 1
				end
				self._picker_labels[label] = self.bufnr
				self.label = label
			end,
			provider = function(self)
				return self.label
			end,
			hl = { fg = colors.yellow, bold = true },
		}

		-- The final touch!
		local TablineBufferBlock = utils.surround({ "", "" }, function(self)
			if self.is_active then
				return utils.get_highlight("TabLineSel").bg
			else
				return utils.get_highlight("TabLine").bg
			end
		end, { TablinePicker, TablineFileNameBlock, TablineCloseButton })

		-- this is the default function used to retrieve buffers
		local get_bufs = function()
			return vim.tbl_filter(function(bufnr)
				return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
			end, vim.api.nvim_list_bufs())
		end

		-- initialize the buflist cache
		local buflist_cache = {}

		-- setup an autocmd that updates the buflist_cache every time that buffers are added/removed
		vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
			callback = function()
				vim.schedule(function()
					local buffers = get_bufs()
					for i, v in ipairs(buffers) do
						buflist_cache[i] = v
					end
					for i = #buffers + 1, #buflist_cache do
						buflist_cache[i] = nil
					end

					-- check how many buffers we have and set showtabline accordingly
					if #buflist_cache > 1 then
						vim.o.showtabline = 2 -- always
					elseif vim.o.showtabline ~= 1 then -- don't reset the option if it's already at default value
						vim.o.showtabline = 1 -- only when #tabpages > 1
					end
				end)
			end,
		})

		local BufferLine = utils.make_buflist(
			TablineBufferBlock,
			{ provider = " ", hl = { fg = "gray" } },
			{ provider = " ", hl = { fg = "gray" } },
			-- out buf_func simply returns the buflist_cache
			function()
				return buflist_cache
			end,
			-- no cache, as we're handling everything ourselves
			false
		)

		local Tabpage = {
			provider = function(self)
				return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
			end,
			hl = function(self)
				if not self.is_active then
					return "TabLine"
				else
					return "TabLineSel"
				end
			end,
		}

		local TabpageClose = {
			provider = "%999X  %X",
			hl = "TabLine",
		}

		local TabPages = {
			-- only show this component if there's 2 or more tabpages
			condition = function()
				-- NB: Changed to one to allow tabbed terminals to display.
				-- return #vim.api.nvim_list_tabpages() >= 2
				return #vim.api.nvim_list_tabpages() >= 1
			end,
			{ provider = "%=" },
			utils.make_tablist(Tabpage),
			TabpageClose,
		}

		local TabLineOffset = {
			condition = function(self)
				local win = vim.api.nvim_tabpage_list_wins(0)[1]
				local bufnr = vim.api.nvim_win_get_buf(win)
				self.winid = win

				if vim.bo[bufnr].filetype == "NvimTree" then
					self.title = "NvimTree"
					return true
					-- elseif vim.bo[bufnr].filetype == "TagBar" then
					--     ...
				end
			end,

			provider = function(self)
				local title = self.title
				local width = vim.api.nvim_win_get_width(self.winid)
				local pad = math.ceil((width - #title) / 2)
				return string.rep(" ", pad) .. title .. string.rep(" ", pad)
			end,

			hl = function(self)
				if vim.api.nvim_get_current_win() == self.winid then
					return "TablineSel"
				else
					return "Tabline"
				end
			end,
		}

		-- Finally, the winbar stuff.

		local FileType = {
			provider = function()
				return vim.bo.filetype
			end,
			hl = { fg = utils.get_highlight("Type").fg },
		}

		local TerminalName = {
			-- we could add a condition to check that buftype == 'terminal'
			-- or we could do that later (see #conditional-statuslines below)
			provider = function()
				local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
				return " " .. tname
			end,
			hl = utils.get_highlight("Type").fg,
		}

		local WinBars = {
			fallthrough = false,
			{ -- A special winbar for terminals
				condition = function()
					return conditions.buffer_matches({ buftype = { "terminal" } })
				end,
				utils.surround({ "", "" }, colors.neutral, {
					FileType,
					singleSpace,
					TerminalName,
				}),
			},
			{ -- An inactive winbar for regular files
				condition = function()
					return not conditions.is_active()
				end,
				utils.surround({ "", "" }, colors.neutral, { hl = { fg = "gray", force = true }, FileNameBlock }),
			},
			-- A winbar for regular files
			utils.surround({ "", "" }, colors.neutral, fileNameBlock),
		}

		-- If tabby is handling the tab line, then we don't need to do so.
		if vim.g.tabby then
			heirline.setup({
				statusline = finalStatusLine,
			})
		else
			finalTabline = { TabLineOffset, BufferLine, TabPages }
			heirline.setup({
				statusline = finalStatusLine,
				tabline = finalTabline,
				winbar = WinBars,

				opts = {
					-- if the callback returns true, the winbar will be disabled for that window
					-- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
					disable_winbar_cb = function(args)
						return conditions.buffer_matches({
							buftype = { "nofile", "prompt", "help", "quickfix" },
							filetype = { "^git.*", "fugitive", "Trouble", "dashboard", "snacks_dashboard", "[No Name]" },
						}, args.buf)
					end,
				},
			})

			vim.keymap.set("n", "<leader>bp", function()
				local tabline = require("heirline").tabline
				local buflist = tabline._buflist[1]
				buflist._picker_labels = {}
				buflist._show_picker = true
				vim.cmd.redrawtabline()
				local char = vim.fn.getcharstr()
				local bufnr = buflist._picker_labels[char]
				if bufnr then
					vim.api.nvim_win_set_buf(0, bufnr)
				end
				buflist._show_picker = false
				vim.cmd.redrawtabline()
			end, { desc = "Tabline buffer picker" })
		end

		-- Yep, with heirline we're driving manual!
		vim.o.showtabline = 2
		vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
	end,
}
