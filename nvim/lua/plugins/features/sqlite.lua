-- This plugin is required as a dependent by some of the other plugins in my 
-- configuration. I'm putting the common configuration details here to fix
-- an issue with shared libraries.
return {
	"kkharji/sqlite.lua",
    init = function()
        -- I have to point this thing to the SQLite3 DLL manually on Windows.
        -- Downloads here: https://www.sqlite.org/download.html
        -- Choose the "Precompiled Binaries for Windows" option.
        if vim.loop.os_uname().sysname == "Windows_NT" then
            -- FIX: Find a more platform independent way to handle this.
            vim.g.sqlite_clib_path = vim.fs.normalize("~/sqlite3.dll")
        end
    end,
}
