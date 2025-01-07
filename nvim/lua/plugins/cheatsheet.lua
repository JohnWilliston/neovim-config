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
    "doctorfree/cheatsheet.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("telescope").load_extension("cheatsheet")
        local ctactions = require("cheatsheet.telescope.actions")
        require("cheatsheet").setup({
            bundled_cheatsheets = true,
            bundled_plugin_cheatsheets = true,
            include_only_installed_plugins = true,
            telescope_mappings = {
                --["<CR>"] = show_selected_item,
                --["<CR>"] = ctactions.select_or_fill_commandline,
                --["<A-CR>"] = ctactions.select_or_execute,
                ["<CR>"] = ctactions.select_or_execute,
                ["<C-C>"] = ctactions.select_or_fill_commandline,
                ["<C-Y>"] = ctactions.copy_cheat_value,
                ["<C-E>"] = ctactions.edit_user_cheatsheet,
            },
        })
    end,
}
