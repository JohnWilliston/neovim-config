-- The first telescope extension I figured out how to customize heavily and
-- leave its initialization as conditional on being included.

-- Providing a function to simplify the calling process and allow evaluation of
-- a few "special" values for various bits of helpful functionality.
local function search_directories(root)
    -- A single dot means the current folder.
    if root == "." then
        root = vim.fn.getcwd()
    -- Two dots means the parent of the current folder.
    elseif root == ".." then
        root = vim.fn.getcwd()
        root = vim.fs.dirname(root)
    -- A back-tick means the folder of the current buffer (as elsehwere).
    elseif root == "`" then
        local configutils = require("utils.config-utils")
        root = configutils.get_current_file_path()
    elseif root == "~" then
        root = nil
    elseif root == "?" then
        -- The old school way that actually works.
        -- root = vim.fn.input("Path?", ".", "file")
        -- BUG: This new-fangled way doesn't work insofar as the initial
        -- text doesn't appear as the initial prompt value.
        vim.ui.input({ prompt = "CD search folder?", text = ".", completion = "file" }, function(input)
            if (input == nil or input == "") then
                return
            end
            search_directories(input)
        end)
        return
    else
        -- Handle conversion of relative paths we may have been provided.
        root = vim.fs.abspath(root)
    end

    -- We start with a default set of options specifying only the root folder.
    opts = {
        dir_command = {
            'fd',
            -- '--exclude=Library',
            -- '--exclude=Pictures',
            '--type=d',
            '.',
            root or vim.uv.os_homedir(),
        }
    }

    -- On Windows we then must change some options as it will 
    -- otherwise use ls, bash, and bat respectively.
    if vim.loop.os_uname().sysname == "Windows_NT" then
        opts.previewer_command = "dir"
        opts.command_executer = { "cmd", "/c" }
        opts.pager_command = "less -RS"
    end

    require("telescope").extensions.cder.cder(opts)
end

local function generate_keymap(opts)
    return {
        "<leader>s\\" .. opts.key,
        function ()
           search_directories(opts.path)
        end,
        desc = opts.alias,
    }
end

local function generate_folder_keys()
    local envutils = require("utils.env-utils")
    -- The most basic key maps included on all platforms/machines.
    local keys = {
        { "<leader>s\\`", function () search_directories("`") end,  desc = "CD to buffer folder" },
        { "<leader>s\\~", function () search_directories("~/") end, desc = "CD to home folder" },
        { "<leader>s\\.", function () search_directories(".") end,  desc = "CD to current folder" },
    }

    local root_dirs = envutils.get_env_data("whaler", "directories")
    local top_dirs = envutils.get_env_data("whaler", "oneoff_directories")

    if (root_dirs ~= nil) then
        for _, v in pairs(root_dirs) do
            local map = generate_keymap(v)
            table.insert(keys, map)
        end
    end

    if (top_dirs ~= nil) then
        for _, v in pairs(top_dirs) do
            local map = generate_keymap(v)
            table.insert(keys, map)
        end
    end

    return keys
end

return {
    "Zane-/cder.nvim",
    keys = generate_folder_keys(),
    init = function ()
        -- Add a helpful function to let the user start a search from a root.
        vim.api.nvim_create_user_command("Cder", function(ctx)
            search_directories(ctx.args)
        end, { nargs = "+", complete = "command" })
    end,
    config = function ()
        require("telescope").load_extension("cder")
    end,
}

