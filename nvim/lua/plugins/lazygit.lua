return {
    "kdheepak/lazygit.nvim",
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    config = function()
        if SystemOS == "Windows" then -- SystemOS is a dynamic var set in init.lua
            vim.schedule(function()
                vim.api.nvim_create_user_command(
                    "LazyGit",
                    function()
                        local current = vim.opt.shell
                        vim.opt.shell = 'cmd'
                        require 'lazygit'.lazygit()
                        vim.opt.shell = current
                    end,
                    { force = true })
            end)
        end
    end,
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
}
