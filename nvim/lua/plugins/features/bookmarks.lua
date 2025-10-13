-- This plugin works great on Linux or macOS but requires a bit of custom setup
-- on Windows, the most shite OS ever. In particular, you need to install the
-- SQLite3 precompiled DLL separately and then point a Vim global variable to
-- said DLL for it to work. See the code in the `init` method for details.
--
-- The following are the default keys defined when using the tree view, which
-- are here: https://github.com/LintaoAmons/bookmarks.nvim?tab=readme-ov-file#treeview
--
-- default keybindings in the treeview buffer
-- keymap = {
--   quit = { "q", "<ESC>" },      -- Close the tree view window and return to previous window
--   refresh = "R",                -- Reload and redraw the tree view
--   create_list = "a",            -- Create a new list under the current node
--   level_up = "u",               -- Navigate up one level in the tree hierarchy
--   set_root = ".",               -- Set current list as root of the tree view, also set as active list
--   set_active = "m",             -- Set current list as the active list for bookmarks
--   toggle = "o",                 -- Toggle list expansion or go to bookmark location
--   move_up = "<localleader>k",   -- Move current node up in the list
--   move_down = "<localleader>j", -- Move current node down in the list
--   delete = "D",                 -- Delete current node
--   rename = "r",                 -- Rename current node
--   goto = "g",                   -- Go to bookmark location in previous window
--   cut = "x",                    -- Cut node
--   copy = "c",                   -- Copy node
--   paste = "p",                  -- Paste node
--   show_info = "i",              -- Show node info
--   reverse = "t",                -- Reverse the order of nodes in the tree view
-- }

return {
    "LintaoAmons/bookmarks.nvim",
    -- If you let it lazy-load, any bookmarks won't be visible until you invoke
    -- one of the commands manually, which isn't what I want.
    lazy = false,
    dependencies = {
        { "kkharji/sqlite.lua" },
        { "nvim-telescope/telescope.nvim" },
        { "stevearc/dressing.nvim" }, -- optional: better UI
    },
    cmd = {
        "BookmarksInfo",
        "BookmarksGoto",
        "BookmarksGotoPrevInList",
        "BookmarksGotoNextInList",
        "BookmarksMark",
        "BookmarksTree",
    },
    keys = {
        { "<leader>ma", "<cmd>BookmarksMark<cr>",           desc = "Bookmark toggle" },
        { "<leader>mt", "<cmd>BookmarksTree<cr>",           desc = "Bookmarks tree" },
        { "<leader>mm", "<cmd>BookmarksGoto<cr>",           desc = "Bookmarks open" },
        { "<leader>mp", "<cmd>BookmarksGotoNextInList<cr>", desc = "Bookmarks go to previous" },
        { "<leader>mn", "<cmd>BookmarksGotoPrevInList<cr>", desc = "Bookmarks go to next" },
        { "<leader>sm", "<cmd>BookmarksGoto<cr>",           desc = "Search bookmarks" },
    },
    -- init = function()
    --     -- I have to point this thing to the SQLite3 DLL manually on Windows.
    --     -- Downloads here: https://www.sqlite.org/download.html
    --     -- Choose the "Precompiled Binaries for Windows" option.
    --     if vim.loop.os_uname().sysname == "Windows_NT" then
    --         -- FIX: Find a more platform independent way to handle this.
    --         vim.g.sqlite_clib_path = vim.fs.normalize("~/sqlite3.dll")
    --     end
    -- end,
    opts = {
        signs = {
            -- Sign mark icon and color in the gutter
            mark = {
                icon = "󰃁",
                color = "Magenta",
                -- Use the default normal background color, whatever that is.
                line_bg = vim.api.nvim_get_hl_by_name("Normal", true).bg,
            },
            desc_format = function(bookmark)
                ---@cast bookmark Bookmarks.Node
                return bookmark.order .. ": " .. bookmark.name
            end,
        },
    },
}
