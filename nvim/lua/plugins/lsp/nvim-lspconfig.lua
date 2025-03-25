local float = require("config.defaults").diagnostics_options.float
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
        { "<leader>ca", vim.lsp.buf.code_action, desc = "LSP Code Actions", mode = "n" },
        { "<leader>cF", vim.lsp.buf.format, desc = "Code format", mode = "n" },
        { "<leader>ch", vim.lsp.buf.signature_help, desc = "Show Signature Help", mode = "n" },
        { "<leader>cr", vim.lsp.buf.rename, desc = "Code rename", mode = "n" },
        { "<leader>cw", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc = "Workspace folders", mode = "n" },

        { "<leader>ld", vim.lsp.buf.definition, desc = "Goto definition", mode = "n" },
        { "<leader>lD", vim.lsp.buf.declaration, desc = "Goto declaration", mode = "n" },
        { "<leader>lt", vim.lsp.buf.type_definition, desc = "Goto type declaration", mode = "n" },
        { "<leader>lT", "<cmd>InspectTree<cr>", desc = "LSP inspect tree", mode = "n" },

        -- quick fix list shortcuts.
        { "<leader>qr", vim.lsp.buf.references, desc = "References to quick fix", mode = "n" },
        { "<leader>qi", vim.lsp.buf.implementation, desc = "Implementation to quick fix", mode = "n" },
    },
    dependencies = {
        {
            "ray-x/lsp_signature.nvim",
            opts = {
                bind = true,
                --floating_window_above_cur_line = true,
                hint_prefix = {
                    above = "↙ ",  -- when the hint is on the line above the current line
                    current = "← ",  -- when the hint is on the same line
                    below = "↖ "  -- when the hint is on the line below the current line
                },
                max_height = float.max_height,
                max_width = float.max_width,
                hint_inline = function()
                    return vim.version.gt(vim.version(), { 0, 9, 0 })
                end,
                handler_opts = {
                    border = float.border,
                },
                toggle_key = "<C-s>",
            },
        },
        "SmiteshP/nvim-navic",
    },
}
