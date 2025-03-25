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
            keymaps = {
                init_selection = "<leader>i",
                node_incremental = "<C-n>",
                node_decremental = "<C-p>",
                scope_incremental = "<C-s>",
            },
        },
    },
    config = function (_, opts)
        local configs = require("nvim-treesitter.configs")
        configs.setup(opts)
    end,
}
