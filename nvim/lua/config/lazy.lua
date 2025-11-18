-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    -- This gets rid of the annoying popup about how configuration has changed.
    change_detection = {
        notify = false,
    },

    -- This departs from the recommended copy/paste code on the web site so
    -- I can structure my plugins the way I want. The import key will take only
    -- a single string, but you can define multiple commands by providing more
    -- sub-tables in the spec table. The following page is helpful:
    -- https://lazy.folke.io/usage/structuring#%EF%B8%8F-importing-specs-config--opts
    spec = {
        -- Add this back if you someday have plugin specs in just the plugins
        -- folder again.
        -- { import = "plugins", },
        { import = "plugins.features", },
        { import = "plugins.completion", },
        { import = "plugins.ui", },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "tokyonight" } },
    -- automatically check for plugin updates
    checker = { enabled = false },
    rocks = {
        enabled = false,    -- Haven't found a need, and it doesn't work anyway.
    },
})
