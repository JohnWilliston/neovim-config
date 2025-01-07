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
        'kosayoda/nvim-lightbulb',
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
}


