-- This file is for the plugins that don't require much configuration, that
-- being an admittedly vague notion yet hopefully tolerably clear.

return {
    "sindrets/diffview.nvim",
    "rafamadriz/friendly-snippets",
    "bennypowers/splitjoin.nvim",
    {
        "rhysd/vim-syntax-christmas-tree",
        cmd = "MerryChristmas",
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = true,
    },
    {
        "kosayoda/nvim-lightbulb",
        --dir = "E:/Src/nvim-lightbulb",
        --"JohnWilliston/nvim-lightbulb",
        opts = {
            autocmd = { enabled = true }
        }
    },
    {
        "NStefan002/screenkey.nvim",
        cmd = "Screenkey",
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = true,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = true,
    },
    -- {
    --     "romgrk/barbar.nvim",
    --     dependencies = {
    --         "lewis6991/gitsigns.nvim",      -- OPTIONAL: for git status
    --         "nvim-tree/nvim-web-devicons",  -- OPTIONAL: for file icons
    --     },
    --     init = function() vim.g.barbar_auto_setup = false end,
    --     opts = {
    --         auto_hide = 1,
    --     },
    -- },
    -- {
    --     "willothy/nvim-cokeline",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",        -- Required for v0.4.0+
    --         "nvim-tree/nvim-web-devicons", -- If you want devicons
    --         "stevearc/resession.nvim"       -- Optional, for persistent history
    --     },
    --     config = true
    -- },
    -- {
    --     "crispgm/nvim-tabline",
    --     dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional
    --     opts = {
    --         show_icon = true,
    --     },
    --     config = true,
    -- },
    {
        "rbong/vim-flog",
        lazy = true,
        cmd = { "Flog", "Flogsplit", "Floggit" },
        dependencies = {
            "tpope/vim-fugitive",
        },
    },
    {
        "bullets-vim/bullets.vim",
    },
    {
        "natecraddock/workspaces.nvim",
        opts = {
            hooks = {
                open = { "SessionRestore" },    -- Calls the auto-session plugin.
            }
        },
    },
    {
        -- This is an old-school Vim plugin that installs properly only via URL.
        url = "https://github.com/tpope/vim-fugitive.git",
    },
    {
        "gorbit99/codewindow.nvim",
        event = "VeryLazy",
        opts = {
            width_multiplier = 4,
        },
    },
    {
        "sindrets/winshift.nvim",
    },

    -- Note that yanky includes a completion plugin integration for nvim-cmp.
    {
        "gbprod/yanky.nvim",
        opts = {
            ring = {
                history_length = 20,    -- I can't imagine needing more entries
            },
        },
    },
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        event = "VeryLazy",
    },
    -- A few things worth noting:
    --  1. You use one of those two commands to create a new table or edit one.
    --  2. You have to save your changes with the `ExportTable` command.
    --  3. There are a number of other commands to insert rows and such.
    -- It's a nice plugin, but I wish it provided better/more keymaps.
    {
        "Myzel394/easytables.nvim",
        cmd = { "EasyTablesCreateNew", "EasyTablesImportThisTable" },
        ft = "markdown",
        lazy = true,
        config = true,
    },
    {
        "echasnovski/mini.nvim",
        config = function ()
            require("mini.cursorword").setup()
            -- I like the current word underlined.
            vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { underline = true })
            --vim.cmd([[hi MiniCursorwordCurrent gui=underline]])
            --require("mini.indentscope").setup()
            --require("mini.tabline").setup()
            require('mini.colors').setup()
        end,
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function ()
           require("colorizer").setup()
        end,
    },
}


