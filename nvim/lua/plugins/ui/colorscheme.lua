return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "night",
            styles = {
                functions = {}
            },
            on_colors = function (colors)
                -- I prefer a less bright background color.
                colors.bg = "#0a0b16"
                -- The following is necessary to make the code symbols in the
                -- status line (provided by the trouble plugin configuration)
                -- look right with tokyonight.
                colors.bg_statusline = "#444444"
                -- Change the markdown heading colors a bit.
                --colors.RenderMarkdownH1.bg = "#7fbb07"
            end,
            on_highlights = function (highlights, colors)
                -- The following is necessary to provide colors in the TabLine
                -- (when it shows) that aren't invisible. Changing the status
                -- line color above caused the issue in the first place.
                --vim.print(highlights)
                --highlights.TabLine["bg"] = "#606060"
                --highlights.TabLine["bg"] = "#1d202d"
                highlights.TabLine["fg"] = "#666666"
                highlights.TabLine["bg"] = "#333333"

                -- More dramatic difference colors for when I use that function.
                highlights.DiffAdd["fg"] = "#00cc00"
                highlights.DiffChange["fg"] = "#0077cc"
                highlights.DiffDelete["fg"] = "#cc0000"
            end,
        },
        config = function (_, opts)
            local tokyonight = require("tokyonight")
            tokyonight.setup(opts)
            vim.cmd([[colorscheme tokyonight]])
            -- vim.cmd([[colorscheme kanagawa]])
        end
    },

    { "rebelot/kanagawa.nvim", enabled = true, lazy = false, priority = 50, opts = {} },
    { "Mofiqul/vscode.nvim",   enabled = true, lazy = false, priority = 50, opts = {} },
    { "navarasu/onedark.nvim", enabled = true, lazy = false, priority = 50, opts = {} },
}
