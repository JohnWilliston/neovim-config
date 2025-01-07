return {
    "Zeioth/hot-reload.nvim",
    enabled = false,    -- I just don't feel like this thing does anything useful for me.
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    event = "BufEnter",
    opts = function()
        local config_dir = vim.fn.stdpath("config") .. "\\lua\\plugins\\"
        --vim.print(config_dir)
        return {
            reload_files = {
                config_dir .. "colorscheme.lua",
                config_dir .. "lualine.lua",
                config_dir .. "treesitter.lua",
                vim.fn.stdpath("config") .. "\\lua\\options.lua",
            },
            -- Things to do after hot-reload trigger.
            reload_callback = function()
                --vim.cmd(":silent! colorscheme " .. vim.g.colors_name) -- nvim     colorscheme reload command.
                --vim.cmd(":silent! doautocmd ColorScheme")                     -- heirline colorscheme reload event.
                vim.cmd(":luafile %")
            end
        }
    end,
}
