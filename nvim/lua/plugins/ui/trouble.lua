-- This was a really tricky plugin for me to figure out for some reason. For
-- starters, I was confused thinking it was used only for errors, warnings, and
-- other stuff like that, when in reality it's just a tool to show you popup
-- and other windows with lists of things. And then I didn't at all grasp from
-- reading the main page (or docs) that while the plugin has a fairly small and
-- well defined number of built-in "modes", from which you can "inherit" to
-- define as many of your own customizations as you want.
--
-- For example, the built-in sources include diagnostics, fzf, a whole bunch of
-- lsp stuff defined programmatically (from an initial 'lsp_base' mode that isn't
-- actually available), qflist, loclist, telescope, and telescope_files. See
-- the mode definitions in the sources folder for more details on their default
-- configurations. Some of these differ only by groups of things to show, how
-- they're filtered, etc., and you can create your own based on these. I'll make
-- some other notes below to explain a bit more.

return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {

        { "<leader>cd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" },
        { "<leader>cD", "<cmd>Trouble diagnostics toggle<CR>",              desc = "Diagnostics (Trouble)" },
        { "<leader>cf", "<cmd>Trouble qflist toggle<CR>",                   desc = "Quickfix List (Trouble)" },
        { "<leader>cg", "<cmd>Trouble loclist toggle<CR>",                  desc = "Location List (Trouble)" },
        {
            "<leader>cl",
            "<cmd>Trouble lsp toggle focus=false<CR>",
            desc = "LSP Definitions / references / ... (Trouble)",
        },
        { "<leader>cs",  "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Symbols (Trouble)" },
        { "<leader>ctl", "<cmd>Trouble telescope toggle<CR>",           desc = "Telescope list sent to trouble" },
        { "<leader>ctf", "<cmd>Trouble telescope_files toggle<CR>",     desc = "Telescope files sent to trouble" },
        -- My custom function to close all the open trouble views.
        { "<leader>cq",  require("utils.config-utils").troubleclose,    desc = "Close all Trouble views" },
    },
    opts = {
        modes = {
            -- Notice how I don't set a mode property in the following.
            -- All I'm really doing is customizing how the existing mode
            -- is configured, more specifically preview, size, etc.
            diagnostics = {
                preview = {
                    type = "split",
                    relative = "win",
                    position = "right",
                    size = 0.3,
                },
                win = { size = 0.25 },
            },
            lsp = {
                preview = {
                    type = "float",
                    relative = "editor",
                    border = "rounded",
                    title = "Preview",
                    title_pos = "center",
                    position = { 0, 0 },
                    size = { width = 0.3, height = 0.3 },
                    zindex = 200,
                },
                win = { position = "right", size = 0.33 },
            },
            symbols = {
                preview = {
                    type = "float",
                    relative = "editor",
                    border = "rounded",
                    title = "Preview",
                    title_pos = "center",
                    position = { 0, 0 },
                    size = { width = 0.3, height = 0.3 },
                    zindex = 200,
                },
                win = { position = "right", size = 0.33 },
            },
            -- I altered the title a bit with this customization for fun.
            -- And to make it clear it's hosted by the trouble plugin.
            telescope = {
                title = "{hl:Title}Telescope (Trouble){hl} {count}",
                preview = {
                    type = "split",
                    relative = "win",
                    position = "right",
                    size = 0.3,
                },
                win = { size = 0.25 },
            },
            -- This on the other hand is a completely new mode I'm adding
            -- purely for sake of testing. The fact that it has a mode
            -- property tells the plugin from what other mode to inherit
            -- settings. So whereas the diagnostics mode's normal preview
            -- is split on the right, this mode will have a centered
            -- floating popup preview window. I will leave this here solely
            -- for future example.
            test = {
                mode = "diagnostics",
                preview = {
                    type = "float",
                    relative = "editor",
                    border = "rounded",
                    title = "TESTING",
                    title_pos = "center",
                    position = { 0.5, 0.5 },
                    size = { width = 0.4, height = 0.4 },
                    zindex = 200,
                },
                win = { size = 0.50 },
            },
        },
    },
}
