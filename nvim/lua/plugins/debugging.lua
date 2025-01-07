local function dap_menu()
    local dap = require "dap"
    local dapui = require "dapui"
    local dap_widgets = require "dap.ui.widgets"

    local hint = [[
 _t_: Toggle Breakpoint             _R_: Run to Cursor
 _s_: Start                         _E_: Evaluate Input
 _c_: Continue                      _C_: Conditional Breakpoint
 _b_: Step Back                     _U_: Toggle UI
 _d_: Disconnect                    _S_: Scopes
 _e_: Evaluate                      _X_: Close
 _g_: Get Session                   _O_: Step Into
 _y_: Hover Variables               _o_: Step Over
 _r_: Toggle REPL                   _u_: Step Out
 _x_: Terminate                     _p_: Pause
 ^ ^               _q_: Quit
]]

    return {
        name = "Debug",
        hint = hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                border = "rounded",
                position = "middle-right",
            },
        },
        mode = "n",
        body = "<A-d>",
        -- stylua: ignore
        heads = {
            { "C", function() dap.set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
            { "E", function() dapui.eval(vim.fn.input "[Expression] > ") end,        desc = "Evaluate Input", },
            { "R", function() dap.run_to_cursor() end,                               desc = "Run to Cursor", },
            { "S", function() dap_widgets.scopes() end,                              desc = "Scopes", },
            { "U", function() dapui.toggle() end,                                    desc = "Toggle UI", },
            { "X", function() dap.close() end,                                       desc = "Quit", },
            { "b", function() dap.step_back() end,                                   desc = "Step Back", },
            { "c", function() dap.continue() end,                                    desc = "Continue", },
            { "d", function() dap.disconnect() end,                                  desc = "Disconnect", },
            {
                "e",
                function() dapui.eval() end,
                mode = { "n", "v" },
                desc =
                "Evaluate",
            },
            { "g", function() dap.session() end,           desc = "Get Session", },
            { "y", function() dap_widgets.hover() end,     desc = "Hover Variables", },
            { "O", function() dap.step_into() end,         desc = "Step Into", },
            { "o", function() dap.step_over() end,         desc = "Step Over", },
            { "p", function() dap.pause.toggle() end,      desc = "Pause", },
            { "r", function() dap.repl.toggle() end,       desc = "Toggle REPL", },
            { "s", function() dap.continue() end,          desc = "Start", },
            { "t", function() dap.toggle_breakpoint() end, desc = "Toggle Breakpoint", },
            { "u", function() dap.step_out() end,          desc = "Step Out", },
            { "x", function() dap.terminate() end,         desc = "Terminate", },
            { "q", nil, {
                exit = true,
                nowait = true,
                desc = "Exit"
            } },
        },
    }
end

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
        init = function ()
            -- TODO: Come up with other cool highlight and definition pairs for 
            -- how I want my debugging symbols to look.
            vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "red", linehl = "", numhl = "" })
            -- vim.fn.sign_define('DapBreakpointCondition', { text='ﳁ', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
            -- vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
            vim.fn.sign_define("DapLogPoint", { text="", texthl="DapLogPoint", linehl="DapLogPoint", numhl= "DapLogPoint" })

            vim.api.nvim_set_hl(0, "DapStopped", { ctermbg=0, fg="#ff9e64", bg="#0a0b16" })
            vim.fn.sign_define("DapStopped", { text="", texthl="DapStopped", linehl="DapStopped", numhl= "DapStopped" })
        end,
        opts = {
            setup = {
                netcoredbg = function(_, _)
                    local dap = require "dap"

                    local function get_dotnet_debugger()
                        local mason_registry = require "mason-registry"
                        local debugger = mason_registry.get_package "netcoredbg"
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
        config = function (plugin, opts)
            -- First, configuration Python for debugging.
            local pythonPath
            if (vim.loop.os_uname().sysname == "Darwin") then
                pythonPath =  "~/.venvs/debugpy/bin/python"
            else
                pythonPath =  "~/.venvs/debugpy/Scripts/python.exe"
            end
            local dap = require("dap")
            local dapui = require("dapui")

            --dap.setup(pythonPath)
            require("dap-python").setup(pythonPath)
            require("dapui").setup()

            -- Now configure Lua for debugging.
            local luaPath
            if (vim.loop.os_uname().sysname == "Darwin") then
                luaPath = "/Users/john/local-lua-debugger-vscode/"
            else
                luaPath = "C:/Users/John/local-lua-debugger-vscode/"
            end
            local debugutils = require("debug-utils")
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

            require("nvim-dap-virtual-text").setup {
                commented = true,
            }
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
    },
    {
        "mfussenegger/nvim-dap-python",
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

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

    -- TODO: See if this cocks up my other nvim-cmp setup!
    { -- optional cmp completion source for require statements and module annotations
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
    },
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

    {
        "anuvyklack/hydra.nvim",
        event = "VeryLazy",
        config = function(_, _)
            local Hydra = require "hydra"
            Hydra(dap_menu())
        end,
    },
}
