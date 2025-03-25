-- A utility plugin to delete buffers (Bdelete) or wipe them out completely,
-- including from the jump list and such (Bwipeout) without messing up your
-- window layout at all. Nice!
return {
    url = "https://github.com/moll/vim-bbye.git",
    cmd = { "Bdelete", "Bwipeout" },
    keys = {
        { "<leader>bd", "<cmd>Bdelete<cr>", desc = "Buffer delete" },
        { "<leader>ba", "<cmd>bufdo Bdelete<cr>", desc = "Buffer delete all" },
        -- TODO: Slightly less than ideal as you lose your line number. Hmph.
        { "<leader>bo", '<cmd>bufdo Bdelete<cr><cmd>e#<cr>', desc = "Buffer delete others" },
    },
}
