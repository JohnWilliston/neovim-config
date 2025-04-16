-- A utility plugin to delete buffers (Bdelete) or wipe them out completely,
-- including from the jump list and such (Bwipeout) without messing up your
-- window layout at all. Nice!
return {
    url = "https://github.com/moll/vim-bbye.git",
    cmd = { "Bdelete", "Bwipeout" },
    keys = {
        { "<leader>bd", "<cmd>Bdelete<cr>", desc = "Buffer delete" },
        { "<leader>ba", "<cmd>bufdo Bdelete<cr>", desc = "Buffer delete all" },
        -- Details on this cool command here: https://www.reddit.com/r/neovim/comments/s7m0xg/how_to_close_all_other_buffers_except_the_current/
        { "<leader>bo", '<cmd>%bdelete|edit #|normal`"<cr>', desc = "Buffer delete others" },
    },
}
