-- This looks like an amazing plugin, but for some reason it kept telling me I
-- wasn't logged into GitHub, despite the GitHub CLI showing otherwise. I did 
-- not take the time to get it working, but I want to come back to it.
return {
    "pwntester/octo.nvim",
    requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        -- OR 'ibhagwan/fzf-lua',
        -- OR 'folke/snacks.nvim',
        "nvim-tree/nvim-web-devicons",
    },
    config = true,
}
