return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    lazy = true,
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
        -- A list of parser names, or "all" (the listed parsers MUST always be installed)
        ensure_installed = {
            "asm",
            "awk",
            "bash",
            "c",
            "c_sharp",
            "cpp",
            "css",
            "csv",
            "diff",
            "disassembly",
            "dockerfile",
            "doxygen",
            "gdscript",
            "go",
            "html",
            "http",
            "javascript",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "rust",
            "sql",
            "terraform",
            "vim",
            "vimdoc",
            "xml",
            "yaml",
            "zig",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            disable = {}, -- List of languages that will be disabled.
            use_languagetree = true,
        },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            -- I've commented these out because I can't get them to work.
            -- TODO: Figure out where you want these. I got them working by
            -- adding the config function below. Figures.
            -- keymaps = {
            --     init_selection = "gnn",
            --     node_incremental = "grn",
            --     scope_incremental = "grc",
            --     node_decremental = "grm",
            -- },
            -- keymaps = {
            --     init_selection = "<C-i>",
            --     node_incremental = "<C-n>",
            --     scope_incremental = "<C-s>",
            --     node_decremental = "<Backspace>",
            -- },
        },
    },
    config = function (_, opts)
        local configs = require("nvim-treesitter.configs")
        configs.setup(opts)
    end,
}
