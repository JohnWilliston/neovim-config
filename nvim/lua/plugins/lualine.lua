
-- These functions are taken from the Ollama setup at:
-- https://github.com/nomnivore/ollama.nvim

-- Define a function to check that ollama is installed and working
local function get_condition()
    return package.loaded["ollama"] and require("ollama").status ~= nil
end


-- Define a function to check the status and return the corresponding icon
local function get_status_icon()
    local status = require("ollama").status()

    if status == "IDLE" then
        return "OLLAMA IDLE"
    elseif status == "WORKING" then
        return "OLLAMA BUSY"
    end
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    enabled = false,
    init = function()
        -- I'm adding a custom Vim global the idea for which I got from LazyVim.
        -- It shows the document symbols for the current cursor location from 
        -- the Trouble plugin. You can disable this for a buffer by setting 
        -- `vim.b.trouble_lualine = false`. By putting this in the init function
        -- it will be executed *before*j any of the usual processing.
        vim.g.trouble_lualine = true
    end,
    opts = function ()
        local opts = {
            options = {
                icons_enabled = true,
                theme = "wombat",
                --component_separators = { left = "", right = ""},
                --section_separators = { left = "", right = ""},

                component_separators = { left = "", right = ""},
                section_separators = { left = "", right = ""},

                --component_separators = "",
                --section_separators = "",
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {}
            },
            sections = {
                lualine_a = {"mode"},
                lualine_b = {"branch", "diff", "diagnostics"},
                lualine_c = {"filename"},
                lualine_x = {
                    "encoding", "fileformat", "filetype",
                },

                -- Enable the following to show the Ollama status.
                --lualine_x = { get_status_icon, get_condition },
                lualine_y = {"progress"},
                lualine_z = {"location"}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {"filename"},
                lualine_x = {"location"},
                lualine_y = {},
                lualine_z = {}
            },
        }

        -- The following adds an indicator to lualine to show when
        -- macro recording is active as it otherwise doesn't appear
        -- when using the noice plugin.
        if (vim.g.noice) then
            -- This was my attempt to do something fancy with Lua tables. I'm not there yet.
            -- local x = opts.sections.lualine_x
            -- opts.sections.lualine_x = table.insert({
                --             require("noice").api.statusline.mode.get,
                --             cond = require("noice").api.statusline.mode.has,
                --             color = { fg = "#ff9e64" } }, 0, x)
                opts.sections.lualine_x = {
                    {
                        require("noice").api.statusline.mode.get,
                        cond = require("noice").api.statusline.mode.has,
                        color = { fg = "#ff9e64" }
                    },
                    "encoding", "fileformat", "filetype",
                }
        end

        -- If the trouble plugin is enabled and reserved a spot in lualine,
        -- then we can add the current symbol to our status line.
        if vim.g.trouble_lualine then
            local trouble = require("trouble")
            local symbols = trouble.statusline({
                mode = "symbols",
                groups = {},
                title = false,
                filter = { range = true },
                format = "{kind_icon}{symbol.name:Normal}",
                -- The highlight group here matters for the color scheme
                -- customization. Lualine doesn't have a tokyonight theme,
                -- so I had to fiddle with it myself.
                hl_group = "lualine_c_normal",
            })
            table.insert(opts.sections.lualine_c, {
                symbols and symbols.get,
                cond = function()
                    return vim.b.trouble_lualine ~= false and symbols.has()
                end,
            })
        end

        return opts
    end,
}
