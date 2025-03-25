
-- The purpose of this module is to learn how to do custom telescope pickers.

local M = {}
local simpleData = { "One", "Two", "Three" }
local fileNames = { "init.lua", "cheatsheet.txt" }
local conf = require("telescope.config").values

function M.basic_picker()
    local file_paths = {}
    for _, item in ipairs(simpleData) do
        table.insert(file_paths, item)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Basic Picker",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

function M.file_picker()
    local file_paths = {}
    for _, item in ipairs(fileNames) do
        table.insert(file_paths, item)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "File Picker",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

-- The lesson here is that the *value* of the entry is what telescope ends up
-- actually using when you confirm selection, whereas the display and ordinal
-- settings are what shows in the picker and is used for sorting respectively.
function M.ordinal_file_picker()
    local data = {
        { display = "1", filename = "init.lua", },
        { display = "2", filename =  "cheatsheet.txt", },
    }

    require("telescope.pickers").new({}, {
        prompt_title = "Ordinal Picker",
        finder = require("telescope.finders").new_table({
            results = data,
            entry_maker = function(entry)
                local text = entry.display ..": " .. entry.filename
                return {
                    value = entry.filename,
                    display = text,
                    ordinal = text,
                }
            end,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

return M
