return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    opts = {
        bullet = {
            -- Would make all the bullets the same symbol.
            -- icons = { '', '' }
        },
        checkbox = {
            checked = {
                -- I don't think strikethrough works on some devices.
                scope_highlight = "@markup.strikethrough",
            },
            custom = {
                important = {
                    raw = "[~]",
                    rendered = "󰓎 ",
                    highlight = "DiagnosticWarn",
                },
            },
        },
        code = {
            position = "right",
            border = "thick",
        },
        heading = {
            border = true,
            border_virtual = true,
        },
        paragraph = {
            indent = 0,
        },
        pipe_table = {
            preset = "round",
        },
        quote = {
            repeat_linebreak = true,
        },
        win_options = {
            showbreak = {
                default = "",
                rendered = "  ",
            },
            breakindent = {
                default = false,
                rendered = true,
            },
            breakindentopt = {
                default = "",
                rendered = "",
            },
        },
    },
}
