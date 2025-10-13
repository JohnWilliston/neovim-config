-- The original version of this plugin hasn't been updated in quite a while. So
-- this spec pulls from what may turn out to be the official replacement. One
-- should also note that the entire UI for handling Git worktrees is effectively
-- provided via telescope. You use the lone key map below to bring up the UI,
-- then <A-c> to create a new tree, <A-d> to delete a tree, <A-f> to force the
-- delete of a tree, or just hit the enter key to switch. It's quite a handy
-- tool for managing different Git units of work.
return {
    -- "ThePrimeagen/git-worktree.nvim",    -- Seems this is abandoned?
    "polarmutex/git-worktree.nvim", -- New guy carrying torch
    keys = {
        {
            "<leader>vw",
            function()
                require("telescope").extensions.git_worktree.git_worktree()
            end,
            desc = "Git worktrees",
        },
    },
    config = function ()
        local telescope = require("telescope")
        telescope.load_extension("git_worktree")
    end
}
