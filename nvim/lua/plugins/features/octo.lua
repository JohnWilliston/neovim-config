-- This looks like an amazing plugin, but for some reason it kept telling me I
-- wasn't logged into GitHub, despite the GitHub CLI showing otherwise. I did 
-- not take the time to get it working, but I want to come back to it.
return {
    "pwntester/octo.nvim",
    requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        -- These are necessary because of the GitHub config twiddling I've done
        -- to use multiple accounts/keys on the same machine.
        ssh_aliases = {
            -- Note the unique syntax because the name has a hyphen.
            ["github-personal"] = "github.com",
            ["github-defcon"] = "github.com",
        },
    },
}
