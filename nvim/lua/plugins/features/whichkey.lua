-- NB: The which-key plugin shows popups for marks, registers, and even
-- spelling suggestions which makes other plugins superfluous: ' or ` shows
-- marks, " shows registers (<C-r> in insert/command mode), and z= shows
-- spelling suggestions for errors when spelling is enabled.
--
-- It also shows help for operations, motions, text objects, windows, etc.
-- if you wait long enough (200 ms by default) for it to appear.

return {
    "folke/which-key.nvim",
    --dir = "E:/Src/3rdParty/which-key.nvim",
    --"JohnWilliston/which-key.nvim", -- Using my custom version until Folke accepts my PR. (assuming he does)
    event = "VeryLazy",
    opts = {
        preset = "helix",
        -- You can add key bindings in the following section.
        spec = {
            -- Mode specification will be inherited by subsequent bindings.
            -- Technically "n" is the default, but I don't want to forget
            -- this little tidbit.
            mode = { "n" },

            -- Proxies let you use one bind to invoke another, in this
            -- case arguably simplifying HJKL window navigation.
            --{ "<leader>w", proxy = "<c-w>", group = "Windows" }, -- proxy to window mappings

            -- These two extras helpfully provide immediate selection of
            -- other buffers/windows. By including them in the named group
            -- defined in keymaps.lua, I get the added benefit of them
            -- showing up right alongside the other keybinds. Very handy!
            {
                "<leader>b",
                group = "Buffers",
                expand = function()
                    return require("which-key.extras").expand.buf()
                end,
            },
            {
                "<leader>w",
                group = "Windows",
                expand = function()
                    return require("which-key.extras").expand.win()
                end,
            },

            -- My custom addition for tabs
            {
                "<leader>t",
                group = "Tools",
                expand = function()
                    return require("utils.config-utils").expand_tab()
                end,
            },

            -- { "<leader>t", group = "Tabs / Tools", expand = function()
            --     return require("which-key.extras").expand.tab()
            -- end,
            -- },

            -- { -- Binds may be nested for organizational purposes.
            --     mode = { "n", "v" },
            --     { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
            --     { "<leader>w", "<cmd>w<cr>", desc = "Write" },
            -- },
        },
    },
}
