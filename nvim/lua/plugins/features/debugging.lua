-- This module is a bit of a mess as I was both learning how to get debugging
-- working in Neovim while trying to leverage the hydra plugin to make tasks
-- such as setting breakpoints easier. Note also that this is one of my rare
-- plugin spec files that includes multiple plugins simply because they all
-- stand or fall together to provide debugging services.
return {
    -- Debugging support, lazydev.nvim being loaded separately
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "rcarriga/nvim-dap-ui" },
            { "theHamsta/nvim-dap-virtual-text" },
            { "nvim-neotest/nvim-nio" },
            { "nvim-telescope/telescope-dap.nvim" },
            { "jay-babu/mason-nvim-dap.nvim" },
            { "LiadOz/nvim-dap-repl-highlights",  opts = {} },
        },
        keys = {
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Debug toggle breakpoint",
            },
            {
                "<leader>dg",
                function()
                    require("dap").continue()
                end,
                desc = "Debug continue",
            },
            {
                "<leader>di",
                function()
                    require("dap").step_into()
                end,
                desc = "Debug step into",
            },
            {
                "<leader>dv",
                function()
                    require("dap").step_over()
                end,
                desc = "Debug step over",
            },
            {
                "<leader>du",
                function()
                    require("dap").step_out()
                end,
                desc = "Debug step out",
            },
            -- Add key bindings to emulate Visual Studio 2022 as well for my sanity.
            {
                "<F9>",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Debug toggle breakpoint",
            },
            {
                "<F5>",
                function()
                    require("dap").continue()
                end,
                desc = "Debug continue",
            },
            {
                "<F11>",
                function()
                    require("dap").step_into()
                end,
                desc = "Debug step into",
            },
            {
                "<F10>",
                function()
                    require("dap").step_over()
                end,
                desc = "Debug step over",
            },
            {
                "<S-F11>",
                function()
                    require("dap").step_out()
                end,
                desc = "Debug step out",
            },
        },
        init = function()
            -- I ditched all the stuff I had previously written in favor of the
            -- following from the LazyVim disto is so much better.
            local defaults = require("config.defaults")
            for name, sign in pairs(defaults.icons.dap) do
                sign = type(sign) == "table" and sign or { sign }
                vim.fn.sign_define(
                    "Dap" .. name,
                    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
                )
            end
        end,
        opts = {
            setup = {
                netcoredbg = function(_, _)
                    local dap = require("dap")

                    local function get_dotnet_debugger()
                        local mason_registry = require("mason-registry")
                        local debugger = mason_registry.get_package("netcoredbg")
                        return debugger:get_install_path() .. "/netcoredbg"
                    end

                    dap.configurations.cs = {
                        {
                            type = "coreclr",
                            name = "launch - netcoredbg",
                            request = "launch",
                            program = function()
                                return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
                            end,
                        },
                    }
                    dap.adapters.coreclr = {
                        type = "executable",
                        command = get_dotnet_debugger(),
                        args = { "--interpreter=vscode" },
                    }
                    dap.adapters.netcoredbg = {
                        type = "executable",
                        command = get_dotnet_debugger(),
                        args = { "--interpreter=vscode" },
                    }
                end,
            },
        },
        config = function(plugin, opts)
            -- First, configuration Python for debugging.
            local pythonPath
            if vim.loop.os_uname().sysname == "Darwin" then
                pythonPath = "~/.venvs/debugpy/bin/python"
            else
                pythonPath = "~/.venvs/debugpy/Scripts/python.exe"
            end
            local dap = require("dap")
            local dapui = require("dapui")

            --dap.setup(pythonPath)
            require("dap-python").setup(pythonPath)
            require("dapui").setup()

            -- Now configure Lua for debugging.
            local luaPath
            -- FIX: Find a better way to handle across platforms/devices.
            if vim.loop.os_uname().sysname == "Darwin" then
                luaPath = "/Users/john/local-lua-debugger-vscode/"
            else
                luaPath = "C:/Users/John/local-lua-debugger-vscode/"
            end
            local debugutils = require("utils.debug-utils")
            debugutils.dap_configure_lua(luaPath)

            -- Now configure the UI to show up whenever debugging is started.
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            -- require("nvim-dap-virtual-text").setup ({
            --     commented = true,
            -- })
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        keys = {
            {
                "<leader>do",
                function()
                    require("dapui").open()
                end,
                desc = "Debug open UI",
            },
            {
                "<leader>dc",
                function()
                    require("dapui").close()
                end,
                desc = "Debug close UI",
            },
            {
                "<leader>dt",
                function()
                    require("dapui").toggle()
                end,
                desc = "Debug toggle UI",
            },
        },
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
    },
    {
        "mfussenegger/nvim-dap-python",
    },
    -- Essential enough I broke it out into its own spec file.
    -- {
    --     "folke/lazydev.nvim",
    --     ft = "lua", -- only load on lua files
    --     opts = {
    --         library = {
    --             -- See the configuration section for more details
    --             -- Load luvit types when the `vim.uv` word is found
    --             { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    --         },
    --     },
    -- },

    --TODO: to configure
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
            automatic_setup = true,
            handlers = {},
            ensure_installed = {},
        },
    },

    {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
            commented = true,
            highlight_changed_variables = true,
            virt_text_pos = "inline",
        },
    },
    {
        "jbyuki/one-small-step-for-vimkind",
        keys = {
            {
                "<leader>dl",
                function()
                    require("osv").launch({ port = 8086 })
                end,
                desc = "Debug Lua in Neovim",
            },
        },
        -- config = function()
        --     local dap = require("dap")
        --     dap.adapters.nlua = function(callback, conf)
        --         local adapter = {
        --             type = "server",
        --             host = conf.host or "127.0.0.1",
        --             port = conf.port or 8086,
        --         }
        --         if conf.start_neovim then
        --             local dap_run = dap.run
        --             dap.run = function(c)
        --                 adapter.port = c.port
        --                 adapter.host = c.host
        --             end
        --             require("osv").run_this()
        --             dap.run = dap_run
        --         end
        --         callback(adapter)
        --     end
        --     dap.configurations.lua = {
        --         {
        --             type = "nlua",
        --             request = "attach",
        --             name = "Run this file",
        --             start_neovim = {},
        --         },
        --         {
        --             type = "nlua",
        --             request = "attach",
        --             name = "Attach to running Neovim instance (port = 8086)",
        --             port = 8086,
        --         },
        --     }
        -- end,
    },

    -- TODO: See if this cocks up my other nvim-cmp setup!
    -- optional cmp completion source for require statements and module annotations
    -- {
    --     "hrsh7th/nvim-cmp",
    --     opts = function(_, opts)
    --         opts.sources = opts.sources or {}
    --         table.insert(opts.sources, {
    --             name = "lazydev",
    --             group_index = 0, -- set group index to 0 to skip loading LuaLS completions
    --         })
    --     end,
    -- },

    -- { -- optional blink completion source for require statements and module annotations
    --     "saghen/blink.cmp",
    --     opts = {
    --         sources = {
    --             -- add lazydev to your completion providers
    --             default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    --             providers = {
    --                 lazydev = {
    --                     name = "LazyDev",
    --                     module = "lazydev.integrations.blink",
    --                     -- make lazydev completions top priority (see `:h blink.cmp`)
    --                     score_offset = 100,
    --                 },
    --             },
    --         },
    --     },
    -- }
    -- { "folke/neodev.nvim", enabled = false }, -- make sure to uninstall or disable neodev.nvim
}
