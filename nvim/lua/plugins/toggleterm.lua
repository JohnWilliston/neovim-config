return {
    "akinsho/toggleterm.nvim",
    cmd = {
        "ToggleTerm",
        "ToggleTermSendCurrentLine",
        "ToggleTermSendVisualLines",
        "ToggleTermSendVisualSelection",
        "ToggleTermToggleAll",
    },
    opts = {
        start_in_insert = false,
        direction = "float",
        close_on_exit = false,
        float_opts = {
            border = "curved",
            title_pos = "center",
        },
        size = function(term)
            if term.direction == "horizontal" then
                vim.print("lines = " .. vim.o.lines)
                return vim.o.lines * 0.5
            elseif term.direction == "vertical" then
                return vim.o.columns * 0.5
            end
        end,
        -- I thought this was a fairly clever way to use the ternary operator.
        shell = vim.loop.os_uname().sysname == "Windows_NT" and "tcc.exe" or vim.o.shell,
    },
    -- config = function(_, opts)
    --     -- vim.print(vim.loop.os_uname().sysname)
    --     if (vim.loop.os_uname().sysname == "Windows_NT") then
    --         opts.shell = "tcc.exe"
    --     end
    --     require("toggleterm").setup(opts)
    -- end,
}
