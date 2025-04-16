-- I added this auto command to override file detection because Neovim was
-- sometimes detecting a *.cpp file as filetype 'conf', which I believe is
-- a sort of default "configuration file" type. I want all my *.cpp files to
-- be detected as type 'cpp'.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.cpp", "*.cxx", "*.h" },
    command = "set filetype=cpp",
})

-- This autocommand ensures each buffer will have my custom completion toggle,
-- and note well the default is for auto-completion to be enabled.
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    -- Old school Vim script.
    -- command = "if !exists('b:cmp') | let b:cmp = v:true | endif",
    callback = function (args)
        if (vim.b[vim.g.completion_buffer_variable] == nil) then
            -- vim.print(string.format("Adding b:%s to buffer %d", vim.g.completion_buffer_variable, args.buf))
            vim.b[vim.g.completion_buffer_variable] = true
        end
    end,
})

