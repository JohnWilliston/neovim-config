
return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        -- "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
        -- auto_install = true,
        -- Commented to rely instead on the auto-install.
        ensure_installed = {
        	"awk_ls", -- This always fails for no clear reason. The command works fine in the terminal.
        	"bashls",
        	"clangd",
        	"cmake",
        	"csharp_ls",
        	"css_variables",
        	"cssls",
        	"cssmodules_ls",
        	"docker_compose_language_service",
        	"dockerls",
        	"helm_ls",
        	"html",
        	"jqls",
        	"jsonls",
        	"lua_ls",
        	"pylsp",
        	"pyright",
        	"sqlls",
        	"terraformls",
        	"tflint",
        	"vimls",
        	"yamlls",
        	"zls",
        },
    },
    config = function (_, opts)
        -- Some basic diagnostics configuration first. Referfence here:
        -- https://neovim.io/doc/user/diagnostic.html
        local diagnostic_options = {
            -- virtual_text = false, -- disables explanation on the lines
            -- Configure floating options and such as well if desired.
        }

        -- Change diagnostic symbols in the gutter if we have a nerd font by
        -- adding that to the options we're building.
        if vim.g.have_nerd_font then
            local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
            local diagnostic_signs = {}
            for type, icon in pairs(signs) do
                diagnostic_signs[vim.diagnostic.severity[type]] = icon
            end
            diagnostic_options.signs = { text = diagnostic_signs }
        end

        -- Now we can set the basic diagnostic options.
        vim.diagnostic.config(diagnostic_options)

        -- This local is used in the auto-configuration below to broadcast
        -- the capabilities of the cmp_nvim_lsp plugin to the LSP servers.
        local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
        -- We define this core LSP setup function here, so we can reuse it
        -- below in the multiple places it's needed.
        local core_lsp_setup = function(client, bufnr)
            -- Disables diagnostics display by default.
            vim.diagnostic.disable(bufnr)
            -- Attach the navic handler to provide symbols in the status bar.
            require("nvim-navic").attach(client, bufnr)
        end

        -- This is the auto-setup for all the languages Mason installs. Any
        -- LSP you install using Mason will get configured by default here.
        local mason = require("mason")
        local masonlspconfig = require("mason-lspconfig")

        mason.setup()
        masonlspconfig.setup(opts)
        masonlspconfig.setup_handlers({
            function(server_name)
                require("lspconfig")[server_name].setup({
                    capabilities = capabilities,
                    on_attach = core_lsp_setup,
                })
            end,
            -- Next, you can provide a dedicated handler for specific servers.
            -- For example, a handler override for the `rust_analyzer`:
            -- ["rust_analyzer"] = function ()
            --     require("rust-tools").setup {}
            -- end

            -- Configures the Lua largely for LSP work in Neovim. For details:
            -- https://github.com/neovim/nvim-lspconfig/blob/9266dc26862d8f3556c2ca77602e811472b4c5b8/doc/server_configurations.md?plain=1#L6399
            ["lua_ls"] = function()
                require("lspconfig").lua_ls.setup({
                    capabilities = capabilities,
                    on_attach = core_lsp_setup,
                    on_init = function(client)
                        local path = client.workspace_folders[1].name
                        if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
                            return
                        end

                        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                            runtime = {
                                -- Tell the language server which version of Lua you're using
                                -- (most likely LuaJIT in the case of Neovim)
                                version = "LuaJIT",
                            },
                            -- Make the server aware of Neovim runtime files
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    vim.env.VIMRUNTIME,
                                    -- Depending on the usage, you might want to add additional paths here.
                                    "${3rd}/luv/library",
                                    "${3rd}/busted/library",
                                },
                                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                                -- library = vim.api.nvim_get_runtime_file("", true)
                            },
                        })
                    end,
                    settings = {
                        Lua = {},
                    },
                })
            end,
        })

        -- The down side of the auto-configuration is that it only works when
        -- Mason does. For example, I have to set up AWK manually because I
        -- can't get Mason to install it properly for unknown reasons. But I
        -- only have to do it on Windows because the AWK language server
        -- installs just fine on real operating systems.
        if vim.loop.os_uname().sysname == "Windows_NT" then
            require("lspconfig").awk_ls.setup({
                capabilities = capabilities,
                on_attach = core_lsp_setup,
            })
        end
    end,

}

