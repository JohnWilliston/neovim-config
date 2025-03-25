-- This spec will work despite giving spurious error messages at startup every
-- time. Maybe Lua rocks is required for this to work right? Repo here:
-- https://github.com/rest-nvim/rest.nvim
return {
    "rest-nvim/rest.nvim",
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter",
            opts = function(_, opts)
                opts.ensure_installed = opts.ensure_installed or {}
                table.insert(opts.ensure_installed, "http")
            end,
        },
        { "j-hui/fidget.nvim", },
        { "nvim-neotest/nvim-nio" },
        { "manoelcampos/xml2lua" },
    }
}
