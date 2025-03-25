-- The good news: I figured out how to customize it to display exactly what
-- I wanted in its own UI and telescope.
-- The bad news: it updates your bloody mark positions when you move the cursor.
-- So it's really more a gateway to files you've used than marked positions in
-- those files. It also keeps losing my marks every time I close Neovim. I don't
-- think it's going to work for me until some things get fixed.

-- Helper function to dump harpoon marks to a new buffer.
local function dump_harpoon_marks()
    --local lines = { "The following are the current harpoon marks:" }
    local lines = {}
    local marks = require("harpoon"):list()
    -- What harpoon marks.items look like in memory:
    -- Windows files at: C:\Users\John\AppData\Local\nvim-data\harpoon
    -- {                                                                                                                                                                     
    --   context = {                                                                                                                                                         
    --     col = 0,                                                                                                                                                          
    --     row = 1                                                                                                                                                           
    --   },                                                                                                                                                                  
    --   value = "lua/plugins/harpoon.lua"                                                                                                                                   
    -- }                                                                                                                                                                     
    -- {                                                                                                                                                                     
    --   context = {                                                                                                                                                         
    --     col = 0,                                                                                                                                                          
    --     row = 1                                                                                                                                                           
    --   },                                                                                                                                                                  
    --   value = "lua/plugins/harpoon.lua"                                                                                                                                   
    -- }      
    for i, m in ipairs(marks.items) do
        table.insert(lines, string.format("%i: %s:%i:%i", i, m.value, m.context.row, m.context.col))
    end
    local bufnr = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

-- Helper function executed when we select a harpoon mark in telescope picker.
local actions_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local function telescope_select_helper(bufnr, _) -- second 'map' parameter unused
    actions.select_default:replace(function ()
        actions.close(bufnr)
        local selection = actions_state.get_selected_entry()
        vim.cmd(string.format("edit +%i %s", selection.harpoon.line, selection.harpoon.filename))
        vim.cmd.normal("zz")
    end)
    return true
end

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup({
            -- Customize default display to show file line and column.
            default = {
                display = function (list_item)
                   return string.format("%s:%i:%i", list_item.value, list_item.context.row, list_item.context.col)
                end
            },
            settings = {
                key = function ()
                    return vim.loop.cwd()
                end,
                save_on_toggle = true,
                sync_on_ui_close = true,
            },
        })

        -- Add custom key-bindings to open the file in new split/tab.
        harpoon:extend({
            UI_CREATE = function(cx)
                vim.keymap.set("n", "<C-v>", function()
                    harpoon.ui:select_menu_item({ vsplit = true })
                end, { buffer = cx.bufnr })

                vim.keymap.set("n", "<C-x>", function()
                    harpoon.ui:select_menu_item({ split = true })
                end, { buffer = cx.bufnr })

                vim.keymap.set("n", "<C-t", function()
                    harpoon.ui:select_menu_item({ tabedit = true })
                end, { buffer = cx.bufnr })
            end,
        })

        -- Support for a telescope picker.
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for i, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, { index = i, filename = item.value, line = item.context.row, col = item.context.col })
            end

            -- TODO: There's still some kind of issue with paths outside the current folder.
            -- I don't know if that's a Harpoon thing or with what I'm doing. I also don't
            -- know why it doesn't properly move to the line/column of the mark. I added a 
            -- bunch of customizations to work around these issues for now.
            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                attach_mappings = telescope_select_helper,
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                    -- I add the line/column values to the file and put its ordinal in front of it.
                    entry_maker = function(entry)
                        local display = string.format("%i: %s:%i:%i", entry.index, entry.filename, entry.line, entry.col)
                        return {
                            value = entry.filename, -- doesn't really matter in light of custom handling
                            display = display,      -- the key bit: string shown in the list
                            ordinal = display,      -- used for sorting the items
                            harpoon = entry,        -- used by helper above
                        }
                    end,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end

        vim.keymap.set("n", "<leader>md", dump_harpoon_marks, { desc = "Dump harpoon marks" } )
        vim.keymap.set("n", "<leader>ml", function() harpoon.logger:show() end, { desc = "Dump harpoon log" } )
        vim.keymap.set("n", "<leader>ma", function() harpoon:list():add() end, { desc = "Add harpoon mark" })

        -- NB: Using the replace methods can screw up the list if you don't 
        -- use them correclty; i.e., target a mark that actually exists.
        vim.keymap.set("n", "<leader>m1", function() harpoon:list():replace_at(1) end, { desc = "Set harpoon mark 1" })
        vim.keymap.set("n", "<leader>m2", function() harpoon:list():replace_at(2) end, { desc = "Set harpoon mark 2" })
        vim.keymap.set("n", "<leader>m3", function() harpoon:list():replace_at(3) end, { desc = "Set harpoon mark 3" })
        vim.keymap.set("n", "<leader>m4", function() harpoon:list():replace_at(4) end, { desc = "Set harpoon mark 4" })
        vim.keymap.set("n", "<leader>m5", function() harpoon:list():replace_at(5) end, { desc = "Set harpoon mark 5" })
        vim.keymap.set("n", "<leader>m6", function() harpoon:list():replace_at(6) end, { desc = "Set harpoon mark 6" })
        vim.keymap.set("n", "<leader>m7", function() harpoon:list():replace_at(7) end, { desc = "Set harpoon mark 7" })
        vim.keymap.set("n", "<leader>m8", function() harpoon:list():replace_at(8) end, { desc = "Set harpoon mark 8" })
        vim.keymap.set("n", "<leader>m9", function() harpoon:list():replace_at(9) end, { desc = "Set harpoon mark 9" })

        vim.keymap.set("n", "<leader>g1", function() harpoon:list():select(1) end, { desc = "Goto harpoon mark 1" })
        vim.keymap.set("n", "<leader>g2", function() harpoon:list():select(2) end, { desc = "Goto harpoon mark 2" })
        vim.keymap.set("n", "<leader>g3", function() harpoon:list():select(3) end, { desc = "Goto harpoon mark 3" })
        vim.keymap.set("n", "<leader>g4", function() harpoon:list():select(4) end, { desc = "Goto harpoon mark 4" })
        vim.keymap.set("n", "<leader>g5", function() harpoon:list():select(5) end, { desc = "Goto harpoon mark 5" })
        vim.keymap.set("n", "<leader>g6", function() harpoon:list():select(6) end, { desc = "Goto harpoon mark 6" })
        vim.keymap.set("n", "<leader>g7", function() harpoon:list():select(7) end, { desc = "Goto harpoon mark 7" })
        vim.keymap.set("n", "<leader>g8", function() harpoon:list():select(8) end, { desc = "Goto harpoon mark 8" })
        vim.keymap.set("n", "<leader>g9", function() harpoon:list():select(9) end, { desc = "Goto harpoon mark 9" })

        vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Goto harpoon mark 1" })
        vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Goto harpoon mark 2" })
        vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Goto harpoon mark 3" })
        vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Goto harpoon mark 4" })
        vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end, { desc = "Goto harpoon mark 5" })
        vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end, { desc = "Goto harpoon mark 6" })
        vim.keymap.set("n", "<leader>7", function() harpoon:list():select(7) end, { desc = "Goto harpoon mark 7" })
        vim.keymap.set("n", "<leader>8", function() harpoon:list():select(8) end, { desc = "Goto harpoon mark 8" })
        vim.keymap.set("n", "<leader>9", function() harpoon:list():select(9) end, { desc = "Goto harpoon mark 9" })

        vim.keymap.set("n", "<leader>mp", function() harpoon:list():prev() end, { desc = "Go to previous mark" } )
        vim.keymap.set("n",  "<leader>mn", function() harpoon:list():next() end, { desc = "Go to next mark" } )

        vim.keymap.set("n", "<leader>mm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open harpoon window" })
        vim.keymap.set("n", "<leader>sh", function() toggle_telescope(harpoon:list()) end, { desc = "Search harpoon marks" })

    end,
}
