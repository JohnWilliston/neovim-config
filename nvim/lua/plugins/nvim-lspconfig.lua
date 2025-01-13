local float = require("config.defaults").diagnostics_options.float
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
            "ray-x/lsp_signature.nvim",
            opts = {
                bind = true,
                max_height = float.max_height,
                max_width = float.max_width,
                hint_inline = function()
                    return vim.version.gt(vim.version(), { 0, 9, 0 })
                end,
                handler_opts = {
                    border = float.border,
                },
            },
        },
        "SmiteshP/nvim-navic",
    },
}
