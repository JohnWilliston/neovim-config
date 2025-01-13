return {
    "rebelot/heirline.nvim",
    dependencies = {
        "Zeioth/heirline-components.nvim",
        --"SmiteshP/nvim-navic",
    },
    enabled = true,
    config = function ()

        local heirline = require("heirline")
        local colors = require("tokyonight.colors").setup()
        --print(vim.inspect(colors))
        local utils = require("heirline.utils")
        local conditions = require("heirline.conditions")
        local lib = require("heirline-components.all")

        heirline.load_colors(lib.hl.get_colors())

        -- Probably a better way to provide spacing, but I don't know it. Yet.
        local singleSpace = {
            provider = " "
        }
        -- Probably a better way to provide spacing, but I don't know it. Yet.
        local rightChevron = {
            provider = ""
        }

        -- A nicely color-coded indicator giving colorful mode information.
        local modeBlock = {
            -- get vim current mode, this information will be required by the provider
            -- and the highlight functions, so we compute it only once per component
            -- evaluation and store it as a component attribute
            init = function(self)
                self.mode = vim.fn.mode(1) -- :h mode()
            end,
            -- Now we define some dictionaries to map the output of mode() to the
            -- corresponding string and color. We can put these into `static` to compute
            -- them at initialisation time.
            static = {
                mode_names = { -- change the strings if you like it vvvvverbose!
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
                },

                mode_colors = {
                    --n = "red" ,
                    n = utils.get_highlight("Directory").fg,
                    -- Customized for a brighter green.
                    i = colors.terminal.green_bright,
                    --i = "green",
                    v = "cyan",
                    V =  "cyan",
                    ["\22"] =  "cyan",
                    c =  "orange",
                    s =  "purple",
                    S =  "purple",
                    ["\19"] =  "purple",
                    R =  "orange",
                    r =  "orange",
                    ["!"] =  "red",
                    t =  "red",
                }
            },
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
                local surround = { "█", "" }
                return " %-2("..self.mode_names[self.mode].."%) "
            end,
            -- Same goes for the highlight. Now the foreground will change according to the current mode.
            hl = function(self)
                local mode = self.mode:sub(1, 1) -- get only the first mode character
                --return { fg = self.mode_colors[mode], bold = true, }
                return { bg = self.mode_colors[mode], fg = utils.get_highlight("StatusLine").bg, bold = true, }
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
                self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
            end,
            provider = function(self)
                return self.icon and (self.icon .. " ")
            end,
            hl = function(self)
                return { fg = self.icon_color }
            end
        }

        local fileName = {
            --hl = { fg = utils.get_highlight("Directory").fg },
            provider = function(self)
                -- first, trim the pattern relative to the current directory. For other
                -- options, see :h filename-modifers
                local filename = vim.fn.fnamemodify(self.filename, ":.")
                if filename == "" then return "[No Name]" end
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
                provider = "[+]",
                hl = { fg = "green" },
            },
            {
                condition = function()
                    return not vim.bo.modifiable or vim.bo.readonly
                end,
                provider = "",
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
                    return { fg = "white", bold = true, force=true }
                end
            end,
        }

        local fileSize = {
            hl = { fg = utils.get_highlight("Directory").fg },
            provider = function()
                -- stackoverflow, compute human readable file size
                local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
                local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
                fsize = (fsize < 0 and 0) or fsize
                if fsize < 1024 then
                    return fsize..suffix[1]
                end
                local i = math.floor((math.log(fsize) / math.log(1024)))
                return string.format(" (%.2f%s)", fsize / math.pow(1024, i), suffix[i + 1])
            end
        }

        local fileLastModified = {
            hl = { fg = utils.get_highlight("Directory").fg },
            provider = function()
                local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
                return (ftime > 0) and os.date(" [%c]", ftime)
            end
        }

        -- let's add the children to our FileNameBlock component
        fileNameBlock = utils.insert(fileNameBlock,
            fileIcon,
            singleSpace,
            utils.insert(fileNameModifier, fileName), -- a new table where FileName is a child of FileNameModifier
            singleSpace,
            fileFlags,
            fileSize,
            fileLastModified,
            { provider = '%<'} -- this means that the statusline is cut here when there's not enough space
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
                self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
            end,

            --hl = { fg = "orange" },
            hl = { fg = "fg" },

            {   -- git branch name
                provider = function(self)
                    return " " .. self.status_dict.head
                end,
                hl = { bold = true }
            },
            -- You could handle delimiters, icons and counts similar to Diagnostics
            {
                condition = function(self)
                    return self.has_changes
                end,
                provider = "("
            },
            {
                provider = function(self)
                    local count = self.status_dict.added or 0
                    return count > 0 and ("+" .. count)
                end,
                --hl = { fg = colors.git.add },
                hl = { fg = colors.terminal.green_bright },
            },
            {
                provider = function(self)
                    local count = self.status_dict.removed or 0
                    return count > 0 and ("-" .. count)
                end,
                --hl = { fg = colors.git.delete },
                hl = { fg = colors.terminal.red },
            },
            {
                provider = function(self)
                    local count = self.status_dict.changed or 0
                    return count > 0 and ("~" .. count)
                end,
                --hl = { fg = colors.git.change },
                hl = { fg = colors.terminal.blue_bright },
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
                }
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
            utils.surround({ "[", "]" }, nil, {
                provider = function()
                    return vim.fn.reg_recording()
                end,
                hl = { fg = "red", bold = true },
            }),
            update = {
                "RecordingEnter",
                "RecordingLeave",
            }
        }

        local fileInfoBlock = {
            provider = function()
                local fileFormatSymbols = {
                    unix = '', -- e712
                    dos = '',  -- e70f
                    mac = '',  -- e711
                }
                return string.format("%s %s", fileFormatSymbols[vim.bo.fileformat], string.upper(vim.bo.fileencoding))
            end
        }

        local spellCheckBlock = {
            condition = function()
                return vim.wo.spell
            end,
            provider = " SPELL ",
            hl = { bold = true, fg = "orange"}
        }

        local diagnosticsBlock = {

            condition = conditions.has_diagnostics,
            static = { error_icon = "", warn_icon = "", info_icon = "", hint_icon = "" },

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
                provider = " ",
            },
            {
                condition = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) > 0,
                provider = function(self)
                    -- 0 is just another output, we can decide to print it or not!
                    return self.errors > 0 and (self.error_icon .. self.errors .. " ")
                end,
                hl = "DiagnosticError",
            },
            {
                condition = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) > 0,
                provider = function(self)
                    return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
                end,
                hl = "DiagnosticWarn",
            },
            {
                condition = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }) > 0,
                provider = function(self)
                    return self.info > 0 and (self.info_icon .. self.info .. " ")
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
            {
                provider = " ",
            },
        }

        -- Cheat Sheet here: https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points
        -- Glyphs here: https://www.nerdfonts.com/cheat-sheet?q=nf-ple-
        --local component_delimiters = { "", "" }
        local component_delimiters = { "", "" } -- 0xe0b6, 0xe0b4
        --local rightmost = { "", "" }
        local leftmost = { "█", "" }
        local rightmost = { "", "█" }

        local cursorPosBlock = {
            hl = { fg = "black", bg = utils.get_highlight("Directory").fg },
            provider = "%7(%l/%3L%):%2c %P",
        }

        local jbwStatus = {
            hl = { fg = "fg", bg = "bg" },
            modeBlock,
            diagnosticsBlock,
            gitBlock,
            singleSpace,
            fileNameBlock,
            singleSpace,
            --troubleSymbols,
            navicSymbolsBlock,
            lib.component.fill(),
            macroRecorderBlock,
            spellCheckBlock,
            --lib.component.cmd_info(cmdInfo),
            fileInfoBlock,
            singleSpace,
            utils.surround(rightmost, colors.blue, cursorPosBlock),
        }

        heirline.setup({
            statusline = jbwStatus,
            -- tabline = tabLine,
        })
    end
    --vim.o.showtabline = 1
}
