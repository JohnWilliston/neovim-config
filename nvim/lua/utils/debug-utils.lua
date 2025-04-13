-- Debug Adapter Protocol configuration utilities.
-- This was my attempt to configure debugging manually. I found that it was 
-- easier, if still a bit tedious, to get Python debugging working by using
-- the nvim-dap-python plugin. The Lua setup here is still useful and has been
-- expanded to include support for debugging Lua code in Neovim itself.

local M = {}

function M.dap_configure_lua(luaDebuggerPath)
    local dap = require("dap")
    dap.adapters["local-lua"] = {
        type = "executable",
        command = "node",
        args = {
            luaDebuggerPath .. "extension/debugAdapter.js",
        },
        enrich_config = function(config, on_config)
            if not config["extensionPath"] then
                local c = vim.deepcopy(config)
                -- � If this is missing or wrong you'll see 
                -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
                c.extensionPath = luaDebuggerPath
                on_config(c)
            else
                on_config(config)
            end
        end,
    }

    dap.adapters.nlua = function(callback, conf)
        local adapter = {
            type = "server",
            host = conf.host or "127.0.0.1",
            port = conf.port or 8086,
        }
        if conf.start_neovim then
            local dap_run = dap.run
            dap.run = function(c)
                adapter.port = c.port
                adapter.host = c.host
            end
            require("osv").run_this()
            dap.run = dap_run
        end
        callback(adapter)
    end
    
    dap.configurations.lua = {
        {
            -- The first three options are required by nvim-dap
            type = "local-lua", -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = "launch",
            name = "Local debugger",
            cwd = "${workspaceFolder}",
            program = {
                lua = "lua",
                file = "${file}",
            },
            args = {},
        },
        {
            type = "nlua",
            request = "attach",
            name = "Run this file",
            start_neovim = {},
        },
        {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance (port = 8086)",
            port = 8086,
        },
    }

end

-- Python details taken from: 
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
-- I never got this working but would like to try again someday.
function M.dap_configure_python()
    local dap = require("dap")
    local pythonPath =  "C:/Users/John/.venvs/debugpy/Scripts/python.exe"
    --local pythonPath =  "~/.venvs/debugpy/Scripts/python.exe"
    dap.adapters.python = function(cb, config)
        if config.request == "attach" then
            ---@diagnostic disable-next-line: undefined-field
            local port = (config.connect or config).port
            ---@diagnostic disable-next-line: undefined-field
            local host = (config.connect or config).host or '127.0.0.1'
            cb({
                type = "server",
                port = assert(port, "`connect.port` is required for a python `attach` configuration"),
                host = host,
                options = {
                    source_filetype = "python",
                },
            })
        else
            cb({
                type = "executable",
                command = pythonPath,
                args = { "-m", "debugpy.adapter" },
                options = {
                    source_filetype = "python",
                },
            })
        end
    end

    dap.configurations.python = {
        {
            -- The first three options are required by nvim-dap
            type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = "launch",
            name = "Launch file",

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            program = "${file}", -- This configuration will launch the current file if used.
            pythonPath = function()
                -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                -- local cwd = vim.fn.getcwd()
                -- if vim.fn.executable(cwd .. python) == 1 then
                --     return cwd .. python
                -- elseif vim.fn.executable(cwd .. python) == 1 then
                --     return cwd .. python
                -- else
                --     return "python"
                -- end
                return pythonPath
            end,
        },
    }
end

-- This is a function written to test Lua script debugging from within Neovim.
local testCount = 0
function M.nvim_debug_test()
    testCount = testCount + 1
    print("Neovim debug test result: " .. testCount)
end

-- I wrote this as a tool for debugging an issue with "pink" hydras giving error
-- messages when run under Neovim 0.11. I'm leaving it for now to illustrate how
-- to evoke a hydra without a body binding and for debugging practice.
function M.debug_navigation_hydra()
    local opts = {
       name = "Hydra Navigate",
       mode = "n",
       -- body = "<leader>wn",
        -- The invoke on body is what lets which-key show the description.
        config = {
            -- The pink color means it ignores "foreign keys", which refers to
            -- keys not supported by the hydra itself. By default, those will
            -- stop the hydra and execute the process, but I prefer the process
            -- to exit *only* with the escape key.
            color = "pink",
            invoke_on_body = true,
            -- This makes the hint appear properly when using noice. NB: the 
            -- status line won't work for navigation unless it's in every 
            -- window, so we use the window instead.
            hint = {
                type = "window",
            },
        },
       heads = {
          { "h", "<cmd>wincmd h<cr>" },
          { "l", "<cmd>wincmd l<cr>", { desc = "←/→" } },
          { "j", "<cmd>wincmd j<cr>" },
          { "k", "<cmd>wincmd k<cr>", { desc = "↑/↓" } },
       }
    } 
    
    local hydra = require("hydra")
    local debug_hydra = hydra(opts)
    -- If I can fix the bug, I should be able to test the hydra with this.
    debug_hydra:activate()
end

return M

