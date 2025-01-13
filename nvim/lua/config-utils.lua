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

-- Tries to pull the stats for the given filename. Using this for Oil debugging.
function M.fstat_test_1()
    local uv = vim.uv or vim.loop
    --local fileName = "C:\\Users\\John\\AppData\\Local\\ElevatedDiagnostics"
    local fileName = "C:\\DumpStack.log"
      uv.fs_stat(fileName, function(err, stat)
        if err then
          print("ERROR! " .. err)
      else
          print("Yay! " .. stat)
      end
      end)
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
    local cmd = string.format("%iToggleTerm direction=tab dir=%s name=Terminal%i", terminalNumber, filePath, terminalNumber)
    print(cmd)
    terminalNumber = terminalNumber + 1
    vim.api.nvim_exec2(cmd, {})
end

function M.hydra_frequent_options()
    local hydra = require("hydra")

local hint = [[
  ^ ^        Options
  ^
  _v_ %{ve} virtual edit
  _i_ %{list} invisible characters  
  _s_ %{spell} spell
  _w_ %{wrap} wrap
  _c_ %{cul} cursor line
  _n_ %{nu} number
  _r_ %{rnu} relative number
  ^
       ^^^^                _<Esc>_
]]

hydra({
   name = "Options",
   hint = hint,
   config = {
      color = "amaranth",
      invoke_on_body = true,
      hint = {
         border = "rounded",
         position = "middle"
      }
   },
   mode = {"n","x"},
   body = "<leader>eo",
   heads = {
      { "n", function()
         if vim.o.number == true then
            vim.o.number = false
         else
            vim.o.number = true
         end
      end, { desc = "number" } },
      { "r", function()
         if vim.o.relativenumber == true then
            vim.o.relativenumber = false
         else
            vim.o.number = true
            vim.o.relativenumber = true
         end
      end, { desc = "relativenumber" } },
      { "v", function()
         if vim.o.virtualedit == "all" then
            vim.o.virtualedit = "block"
         else
            vim.o.virtualedit = "all"
         end
      end, { desc = "virtualedit" } },
      { "i", function()
         if vim.o.list == true then
            vim.o.list = false
         else
            vim.o.list = true
         end
      end, { desc = "show invisible" } },
      { "s", function()
         if vim.o.spell == true then
            vim.o.spell = false
         else
            vim.o.spell = true
         end
      end, { exit = true, desc = "spell" } },
      { "w", function()
         if vim.o.wrap ~= true then
            vim.o.wrap = true
            -- Dealing with word wrap:
            -- If cursor is inside very long line in the file than wraps
            -- around several rows on the screen, then "j" key moves you to
            -- the next line in the file, but not to the next row on the
            -- screen under your previous position as in other editors. These
            -- bindings fixes this.
            -- vim.keymap.set("n", "k", function() return vim.v.count > 0 and "k" or "gk" end,
            --                          { expr = true, desc = "k or gk" })
            -- vim.keymap.set("n", "j", function() return vim.v.count > 0 and "j" or "gj" end,
            --                          { expr = true, desc = "j or gj" })
         else
            vim.o.wrap = false
            -- vim.keymap.del("n", "k")
            -- vim.keymap.del("n", "j")
         end
      end, { desc = "wrap" } },
      { "c", function()
         if vim.o.cursorline == true then
            vim.o.cursorline = false
         else
            vim.o.cursorline = true
         end
      end, { desc = "cursor line" } },
      { "<Esc>", nil, { exit = true } }
   }
})

-- I can't seem to get this working. It's supposed to be the very simplest
-- example, but it doesn't seem to work.
-- hydra({
--    name = "Side scroll",
--    mode = "n",
--    body = "<leader>z",
--    heads = {
--       { "h", "5zh" },
--       { "l", "5zl", { desc = "←/→" } },
--       { "H", "zH" },
--       { "L", "zL", { desc = "half screen ←/→" } },
--    }
-- })

end
return M
