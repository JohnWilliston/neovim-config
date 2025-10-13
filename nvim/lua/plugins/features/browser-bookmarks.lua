-- On Unix, Linux, macOS, etc. the 'open' command will open a URL. On Windows,
-- you have to use the 'start' command, and what's more you have to provide it
-- an empty title string to avoid it messing up the launch.
local open_cmd = "open"
if vim.loop.os_uname().sysname == "Windows_NT" then
    open_cmd = 'start ""'
end

return {
    "dhruvmanila/browser-bookmarks.nvim",
    version = "*",
    -- FIX: Find a better way to handle across platforms/devices/accounts.
    -- Only required to override the default options
    opts = {
        profile_name = "DEFCON",
        selected_browser = "vivaldi",
    },
    keys = {
        {
            "<leader>sBp",
            function()
                local bb = require("browser_bookmarks")
                bb.setup({ profile_name = "Personal", selected_browser = "vivaldi", url_open_command = open_cmd })
                bb.select()
            end,
            desc = "Search personal Vivaldi bookmarks",
        },
        {
            "<leader>sBw",
            function()
                local bb = require("browser_bookmarks")
                bb.setup({ profile_name = "DEFCON", selected_browser = "vivaldi", url_open_command = open_cmd })
                bb.select()
            end,
            desc = "Search work Vivaldi bookmarks",
        },
    },
    -- dependencies = {
    --   -- Only if your selected browser is Firefox, Waterfox or buku
    --   'kkharji/sqlite.lua',
    --
    --   -- Only if you're using the Telescope extension
    --   'nvim-telescope/telescope.nvim',
    -- }
}
