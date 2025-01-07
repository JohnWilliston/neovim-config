return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
        auto_install = true,
        ensure_installed = {
            -- "awk_ls", -- This always fails for no clear reason. The command works fine in the terminal.
            "clangd",
            "csharp_ls",
            "cssls",
            "html",
            "lua_ls",
            "pyright",
            "terraformls"
        },
    },
    config = function(_, opts)
        -- This local is used in the auto-configuration below to broadcast
        -- the capabilities of the cmp_nvim_lsp plugin to the LSP servers.
        --local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local capabilities = require("cmp_nvim_lsp").default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
        )

        -- The following is taken from the NvChad configuration when I was trying
        -- to understand how it seemed (from videos at least) to be giving me more
        -- options. But this doesn't seem to change anything in the end.
        -- capabilities.textDocument.completion.completionItem = {
        --     documentationFormat = { "markdown", "plaintext" },
        --     snippetSupport = true,
        --     preselectSupport = true,
        --     insertReplaceSupport = true,
        --     labelDetailsSupport = true,
        --     deprecatedSupport = true,
        --     commitCharactersSupport = true,
        --     tagSupport = { valueSet = { 1 } },
        --     resolveSupport = {
        --         properties = {
        --             "documentation",
        --             "detail",
        --             "additionalTextEdits",
        --         },
        --     },
        -- }

        -- This is the auto-setup for all the languages Mason installs. Any
        -- LSP you install using Mason will get configured by default here.
        local mason = require("mason")
        local masonlspconfig = require("mason-lspconfig")

        mason.setup()
        masonlspconfig.setup(opts)
        masonlspconfig.setup_handlers({
            function(server_name)
                require("lspconfig")[server_name].setup({
                    capabilities = capabilities
                })
            end,
            -- Next, you can provide a dedicated handler for specific servers.
            -- For example, a handler override for the `rust_analyzer`:
            -- ["rust_analyzer"] = function ()
            --     require("rust-tools").setup {}
            -- end
        })

        -- The down side of the auto-configuration is that it only works when
        -- Mason does. For example, I have to set up AWK manually because I
        -- can't get Mason to install it properly for unknown reasons. But I
        -- only have to do it on Windows because the AWK language server
        -- installs just fine on real operating systems.
        if (vim.loop.os_uname().sysname == "Windows_NT") then
            require("lspconfig").awk_ls.setup({
                capabilities = capabilities
            })
        end
    end,
}
