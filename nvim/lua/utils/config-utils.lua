-- I was having trouble with neo-tree closing nvim entirely whenever I used a
-- simple `:bd` command. I found I could "fix" that by changing one of its
-- settings ('close_if_last_window') to false, but then it was an annoying
-- plugin that would hang around after the last buffer was closed. Hmph. The
-- following utility function was obtained from a discussion thread:
--
--   https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1504
--
-- It's my first real custom Lua module for Neovim configuration, so I was glad
-- I could figure out how to get it working.

local M = {}

-- I added this little function to my telescope configuration a long time ago
-- and am moving it into my configuration utils for more general use.
function M.is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    ---@diagnostic disable-next-line: undefined-field
    return vim.v.shell_error == 0
end

-- Another function from my telescope configuration from long ago.
function M.get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
end

--- This function is taken directly from [LazyVim's UI utils](https://github.com/LazyVim/LazyVim/blob/a1c3ec4cd43fe61e3b614237a46ac92771191c81/lua/lazyvim/util/ui.lua#L228).
--- Besides some other nice features, this primarily prevents neo-tree from
--- taking up the whole screen after deleting a buffer.
--- (Thank you folke)
---@param buf number?
function M.bufremove(buf)
    buf = buf or 0
    buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

    if vim.bo.modified then
        local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
        if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
            return
        end
        if choice == 1 then -- Yes
            vim.cmd.write()
        end
    end

    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.api.nvim_win_call(win, function()
            if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
                return
            end
            -- Try using alternate buffer
            local alt = vim.fn.bufnr("#")
            if alt ~= buf and vim.fn.buflisted(alt) == 1 then
                vim.api.nvim_win_set_buf(win, alt)
                return
            end

            -- Try using previous buffer
            local has_previous = pcall(vim.cmd, "bprevious")
            if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
                return
            end

            -- Create new listed buffer
            local new_buf = vim.api.nvim_create_buf(true, false)
            vim.api.nvim_win_set_buf(win, new_buf)
        end)
    end
    if vim.api.nvim_buf_is_valid(buf) then
        pcall(vim.cmd, "bdelete! " .. buf)
    end
end

-- This function closes all open trouble views. I found the code in the GitHub
-- issue: https://github.com/folke/trouble.nvim/issues/456
function M.troubleclose()
    local trouble = require("trouble")
    local Preview = require("trouble.view.preview")
    if Preview.is_open() then
        Preview.close()
    end
    local view = trouble.close()
    while view do
        view = trouble.close()
    end
end

-- A simple little utility function to extract the path component from a filename.
local function getPath(str)
    return str:match("(.*[/\\])")
end

-- Gets the file path from the filename of the current buffer.
function M.get_current_file_path()
    local currentFilename = vim.api.nvim_buf_get_name(0)
    return getPath(currentFilename)
end

-- Sets the current working directory from the filename of the current buffer.
function M.set_cwd_from_current_file()
    local currentFilename = vim.api.nvim_buf_get_name(0)
    local newPath = getPath(currentFilename)
    print("Changing cwd to " .. newPath)
    vim.api.nvim_set_current_dir(newPath)
end

-- I start the terminal number at five because commands go to 1 by default,
-- and I'm reserving that for a popup terminal. I then have defined in my
-- keymaps a horizontal, vertical, and tabbed popup terminals as well. By
-- starting terminals spawned by this function at five, we avoid those.
local terminalNumber = 5

function M.open_new_terminal_tab()
    local cmd = string.format("%iToggleTerm direction=tab name=Terminal%i", terminalNumber, terminalNumber)
    print(cmd)
    terminalNumber = terminalNumber + 1
    vim.api.nvim_exec2(cmd, {})
end

function M.open_new_terminal_tab_current_file()
    local currentFilename = vim.api.nvim_buf_get_name(0)
    local filePath = getPath(currentFilename)
    local cmd =
        string.format("%iToggleTerm direction=tab dir=%s name=Terminal%i", terminalNumber, filePath, terminalNumber)
    print(cmd)
    terminalNumber = terminalNumber + 1
    vim.api.nvim_exec2(cmd, {})
end

-- This function gets the values of the four environment variables I rely
-- upon the direnv utility to set for me to configure the AWS CLI on a
-- per-directory basis. It allows me to pass them to plugins that will
-- open "clean" shells for sake of the AWS CLI working with them.
function M.get_aws_env_vars()
    local result = {}
    local awsVars = { "AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_DEFAULT_REGION", "AWS_DEFAULT_OUTPUT" }
    for _, v in ipairs(awsVars) do
        local value = os.getenv(v)
        if value ~= nil and value ~= "" then
            result[v] = os.getenv(v)
        end
    end
    return result
end

-- I found I needed this to extend neo-tree to recycle files conveniently.
function M.delete_to_trash(filename)
    local cmd = "trash" -- the default *nix way of doing things.
    if vim.loop.os_uname().sysname == "Windows_NT" then
        -- not a built in utility, something I DL'ed.
        -- https://web.archive.org/web/20071026113307/http://gearbox.maem.umr.edu/batch/f_w_util/
        cmd = "recycle"
    end
    vim.fn.system({ cmd, filename })
end

-- The following two functions are largely cribbed from the extras module of
-- Folke's which-key (see https://github.com/folke/which-key.nvim/blob/main/lua/which-key/extras.lua)
-- and expand on his built-in support for switching windows and buffers to add
-- switching tabs as well. I think I'm going to submit a PR for this.

local function add_keys(spec)
    table.sort(spec, function(a, b)
        return a.desc < b.desc
    end)
    spec = vim.list_slice(spec, 1, 10)
    for i, v in ipairs(spec) do
        v[1] = tostring(i - 1)
    end
    return spec
end

function M.expand_tab()
    local ret = {}
    local current = vim.api.nvim_get_current_tabpage()
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        if tab ~= current then
            local num = vim.api.nvim_tabpage_get_number(tab)
            ret[#ret + 1] = {
                "",
                function()
                    vim.api.nvim_set_current_tabpage(tab)
                end,
                desc = "Goto tab " .. tostring(num),
                icon = { cat = "file", name = tostring(num) },
            }
        end
    end
    return add_keys(ret)
end

-- The following functions encapsulate adding a buffer-specific variable used to
-- toggle completion by my config. I have an autocmd that ensures it gets added
-- when creating or reading a file into a buffer.

-- local buffer_completion_variable = "cmp"
vim.g.completion_buffer_variable = "cmp"
local buffer_completion_default = true

function M.is_buffer_completion_enabled(bufnr)
    if (vim.b[vim.g.completion_buffer_variable] ~= nil) then
        return vim.api.nvim_buf_get_var(bufnr, vim.g.completion_buffer_variable)
    else
        return buffer_completion_default
    end
end

function M.enable_buffer_completion(bufnr, value)
    vim.api.nvim_buf_set_var(bufnr, vim.g.completion_buffer_variable, value)
end

-- The following functions encapsulate managing font size for me. They're not
-- normally needed but are when using Neovide for example.

local function parse_font(guifont)
    local index = string.find(guifont, "[^:]:h")
    if (index == nil) then return index end

    -- Normal guifont format is [name]:h[size], so we just break off the name
    -- and grab the current size a few characters later.
    local name = string.sub(guifont, 1, index)
    local size = tonumber(string.sub(guifont, index + 3))

    return { name = name, size = size }
end

function M.adjust_font_size(amount)
    local f = parse_font(vim.o.guifont)
    if (f == nil) then
        vim.notify("Error: could not parse current font!", vim.log.levels.ERROR)
        return
    end
    local newSize = f.size + amount
    local guards = { min = 8, max = 20 }
    if (newSize < guards.min) then newSize = guards.min end
    if (newSize > guards.max) then newSize = guards.max end
    local newFont = string.format("%s:h%d", f.name, newSize)
    vim.o.guifont = newFont
end

return M

