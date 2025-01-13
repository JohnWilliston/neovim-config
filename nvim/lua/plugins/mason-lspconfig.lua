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
        -- Change diagnostic symbols in the gutter if we have a nerd font.
        if vim.g.have_nerd_font then
            local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
            local diagnostic_signs = {}
            for type, icon in pairs(signs) do
                diagnostic_signs[vim.diagnostic.severity[type]] = icon
            end
            vim.diagnostic.config({ signs = { text = diagnostic_signs } })
        end

        -- This local is used in the auto-configuration below to broadcast
        -- the capabilities of the cmp_nvim_lsp plugin to the LSP servers.
        local capabilities = require("cmp_nvim_lsp").default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
        )

        -- This is the auto-setup for all the languages Mason installs. Any
        -- LSP you install using Mason will get configured by default here.
        local mason = require("mason")
        local masonlspconfig = require("mason-lspconfig")
        local navic = require("nvim-navic")

        mason.setup()
        masonlspconfig.setup(opts)
        masonlspconfig.setup_handlers({
            function(server_name)
                require("lspconfig")[server_name].setup({
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                        navic.attach(client, bufnr)
                    end,
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
