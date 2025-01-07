-- Debug Adapter Protocol configuration utilities.
-- This was my attempt to configure debugging manually. I found that it was 
-- easier, if still a bit tedious, to get Python debugging working by using
-- the nvim-dap-python plugin. I'm leaving this module solely for reference.

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

    dap.configurations.lua = {
        {
            -- The first three options are required by nvim-dap
            type = "local-lua", -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = "launch",
            name = "Launch file",
            cwd = "${workspaceFolder}",
            program = {
                lua = "lua",
                file = "${file}",
            },
            args = {},
        },
    }

end

-- Python details taken from: 
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
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

return M

