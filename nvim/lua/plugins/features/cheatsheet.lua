-- function show_selected_item(prompt_bufnr)
--     local t_actions = require('telescope.actions')
--     local t_actions_state = require('telescope.actions.state')
--     local utils = require('cheatsheet.utils')
--     local selection = t_actions_state.get_selected_entry()
--     local section = selection.value.section
--     local description = selection.value.description
--     local cheat = selection.value.cheatcode
--     local execute = true

--     vim.print(description)

--     t_actions.close(prompt_bufnr)

--     if string.len(cheat) == 1 then
--         print("Cheatsheet: No command could be executed")
--         return
--     end

--     -- Extract command from cheat, eg:
--     -- ":%bdelete" -> No change
--     -- ":set hls!" -> No change
--     -- ":edit [file]" -> ":edit "
--     -- ":set shiftwidth={n}" -> ":set shiftwidth="
--     local command = cheat:match("^:[^%[%{]+")
--     if command ~= nil then
--         if execute then
--             vim.api.nvim_command(cheat)
--         else
--             vim.api.nvim_feedkeys(command, "n", true)
--         end
--     else
--         vim.api.nvim_echo(
--         { -- text, highlight group
--             { "Cheatsheet [", "" },
--             { section, "cheatMetadataSection" },
--             { "]: Press ", "" }, { cheat, "cheatCode" },
--             { " to ", "" },
--             { description:lower(), "cheatDescription" },
--         }, false, {}
--         )
--     end
-- end

-- The key bindings merit a note. The default configuration on the web page
-- binds the enter key to the `select_or_fill_commandline` function, but I'm
-- not even sure what that does. The one thing I know for sure is that it
-- does *NOT* execute the command. The `select_or_execute` function does, 
-- which is why I've bound it to the enter key.
--
-- It's also worth noting that the code above helped me debug this, and I 
-- rebound what was <A-CR> because the Windows Terminal application will
-- simply swallow that key altogether. <C-C> works more reliably. Though it
-- should also be noted that it copies the command text to register 0, not
-- the system clipboard for some reason.

return {
    -- "doctorfree/cheatsheet.nvim",
    -- dir = "E:/Src/3rdParty/cheatsheet.nvim",
    -- dir = "E:/Src/cheatsheet.nvim",
    "JohnWilliston/cheatsheet.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>??", "<cmd>Cheatsheet<cr>", desc = "Cheat sheet" }
    },
    opts = function ()
        require("telescope").load_extension("cheatsheet")
        local ctactions = require("cheatsheet.telescope.actions")
        
        return {
            bundled_cheatsheets = true,
            bundled_plugin_cheatsheets = true,
            include_only_installed_plugins = true,
            telescope_mappings = {
                ["<CR>"] = ctactions.select_or_execute,
                -- Sends text description of cheat to nvim_echo() method.
                -- If I use my altered version of the plugin, it shows up in
                -- the message history. Not sure of the author's intent.
                ["<C-k>"] = ctactions.select_or_fill_commandline,
                ["<C-y>"] = ctactions.copy_cheat_value,
                -- Not needed as it's the default, but let's be explicit.
                ["<C-e>"] = ctactions.edit_user_cheatsheet,
            },
        }
    end,
}
