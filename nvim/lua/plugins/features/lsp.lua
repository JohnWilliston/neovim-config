local float = require("config.defaults").diagnostics_options.float

local lsp_servers = {
    -- Commented out because its installation always fails on Windows.
	-- "awk_ls",
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
	"vimls",
	"yamlls",
	"zls",
}

return {
	{
        "williamboman/mason.nvim",
        opts = {
            ui = {
                check_outdated_packages_on_open = true,
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = lsp_servers,
        },
        config = function(_, opts)
            -- Some basic diagnostics configuration first. Referfence here:
            -- https://neovim.io/doc/user/diagnostic.html
            local diagnostic_options = {
                -- Enables the new feaure in 0.11 to show virtual lines.
                -- See https://gpanders.com/blog/whats-new-in-neovim-0-11/
                virtual_lines = true
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

            -- The newly simplified setup for most of my LSP servers, courtesy
            -- of the new features in Neovim 0.11.
            local mason = require("mason")
            local masonlspconfig = require("mason-lspconfig")
            mason.setup()
            masonlspconfig.setup(opts)
            for _, l in pairs(lsp_servers) do
                vim.lsp.enable(l)
            end

            -- This one is done manually because I'm forced to omit the AWK
            -- LSP above as its installer always fails on Windows. Sigh. I can
            -- easily install it manually, but it never works with Mason.
            vim.lsp.enable("awk_ls")
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        keys = {
            { "<leader>ca", vim.lsp.buf.code_action,    desc = "LSP Code Actions",    mode = "n" },
            { "<leader>cF", vim.lsp.buf.format,         desc = "Code format",         mode = "n" },
            { "<leader>ch", vim.lsp.buf.signature_help, desc = "Show Signature Help", mode = "n" },
            { "<leader>cr", vim.lsp.buf.rename,         desc = "Code rename",         mode = "n" },
            {
                "<leader>cw",
                function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end,
                desc = "Workspace folders",
                mode = "n",
            },

            { "<leader>ld", vim.lsp.buf.definition,      desc = "Goto definition",             mode = "n" },
            { "<leader>lD", vim.lsp.buf.declaration,     desc = "Goto declaration",            mode = "n" },
            { "<leader>lt", vim.lsp.buf.type_definition, desc = "Goto type declaration",       mode = "n" },
            { "<leader>lT", "<cmd>InspectTree<cr>",      desc = "LSP inspect tree",            mode = "n" },

            -- quick fix list shortcuts.
            { "<leader>qr", vim.lsp.buf.references,      desc = "References to quick fix",     mode = "n" },
            { "<leader>qi", vim.lsp.buf.implementation,  desc = "Implementation to quick fix", mode = "n" },
        },
        dependencies = {
            {
                "ray-x/lsp_signature.nvim",
                opts = {
                    bind = true,
                    --floating_window_above_cur_line = true,
                    hint_prefix = {
                        above = "↙ ", -- when the hint is on the line above the current line
                        current = "← ", -- when the hint is on the same line
                        below = "↖ ", -- when the hint is on the line below the current line
                    },
                    max_height = float.max_height,
                    max_width = float.max_width,
                    hint_inline = function()
                        return vim.version.gt(vim.version(), { 0, 9, 0 })
                    end,
                    handler_opts = {
                        border = "rounded",
                    },
                    toggle_key = "<C-s>",
                },
            },
            "SmiteshP/nvim-navic",
        },
    },
}
