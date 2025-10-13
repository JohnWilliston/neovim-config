return {
    "yarospace/lua-console.nvim",
    keys = {
        -- This mapping will work to bring down the console. <C-`> will not.
        { "<A-`>", function() require("lua-console").toggle_console() end, desc = "Lua-console" },
    },
    opts = {
        -- These mappings won't work. But they do at least override defaults.
        mappings = {
            toggle = "<C-`>",
            attach = "<leader><C-`>",
        },
    },
}
