-- Many thanks to Alex G. for the following debugging helper.
local function hydra_dap_menu()
    local dap = require("dap")
    local dapui = require("dapui")
    local dap_widgets = require("dap.ui.widgets")

    local hint = [[
 _t_: Toggle Breakpoint             _R_: Run to Cursor
 _s_: Start                         _E_: Evaluate Input
 _c_: Continue                      _C_: Conditional Breakpoint
 _b_: Step Back                     _U_: Toggle UI
 _d_: Disconnect                    _S_: Scopes
 _e_: Evaluate                      _X_: Close
 _g_: Get Session                   _O_: Step Into
 _y_: Hover Variables               _o_: Step Over
 _r_: Toggle REPL                   _u_: Step Out
 _x_: Terminate                     _p_: Pause
 ^ ^               _q_: Quit
]]

    return {
        name = "Debug",
        hint = hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                position = "middle-right",
            },
        },
        mode = "n",
        body = "<A-d>",
        -- stylua: ignore
        heads = {
            { "C", function() dap.set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
            { "E", function() dapui.eval(vim.fn.input "[Expression] > ") end,        desc = "Evaluate Input", },
            { "R", function() dap.run_to_cursor() end,                               desc = "Run to Cursor", },
            { "S", function() dap_widgets.scopes() end,                              desc = "Scopes", },
            { "U", function() dapui.toggle() end,                                    desc = "Toggle UI", },
            { "X", function() dap.close() end,                                       desc = "Quit", },
            { "b", function() dap.step_back() end,                                   desc = "Step Back", },
            { "c", function() dap.continue() end,                                    desc = "Continue", },
            { "d", function() dap.disconnect() end,                                  desc = "Disconnect", },
            {
                "e",
                function() dapui.eval() end,
                mode = { "n", "v" },
                desc =
                "Evaluate",
            },
            { "g", function() dap.session() end,           desc = "Get Session", },
            { "y", function() dap_widgets.hover() end,     desc = "Hover Variables", },
            { "O", function() dap.step_into() end,         desc = "Step Into", },
            { "o", function() dap.step_over() end,         desc = "Step Over", },
            { "p", function() dap.pause.toggle() end,      desc = "Pause", },
            { "r", function() dap.repl.toggle() end,       desc = "Toggle REPL", },
            { "s", function() dap.continue() end,          desc = "Start", },
            { "t", function() dap.toggle_breakpoint() end, desc = "Toggle Breakpoint", },
            { "u", function() dap.step_out() end,          desc = "Step Out", },
            { "x", function() dap.terminate() end,         desc = "Terminate", },
            { "q", nil, {
                exit = true,
                nowait = true,
                desc = "Exit"
            } },
        },
    }
end

local function hydra_frequent_options()
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

    return {
        name = "Options",
        hint = hint,
        config = {
            color = "amaranth",
            invoke_on_body = true,
            hint = {
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
    }

end

-- Some notes are in order about the following hydras. Some were largely taken
-- from the main hydra documentation while others are my own creation. I 
-- particularly like the way the technique aids in simple tasks like switching 
-- window panes without repeatedly hitting <C-w> as a prefix every time.
--
-- First, my use of the pink color means it ignores "foreign keys", which refers 
-- to keys not supported by the hydra itself. By default (a "red" hydra), those 
-- will stop the hydra and execute whatever is normally bound to that key, but 
-- I prefer the process to exit *only* with the escape key, which pink does.
--
-- Second, the use of the "invoke_on_body" is what lets the which-key plugin
-- show the description in its nice helpful popup window for key bind help.
--
-- Third, the different values for the hint type are sometimes different because
-- that helps keep the hint visible while the hydra is open.

local function hydra_window_resize()
    return {
        name = "Hydra Resize",
        mode = "n",
        body = "<leader>wr",
        -- The invoke on body is what lets which-key show the description.
        config = {
            color = "pink",
            invoke_on_body = true,
            -- This makes the hint appear properly when using noice.
            hint = {
                type = "statusline",
            },
        },
        heads = {
            { "h", "<C-w><" },
            { "l", "<C-w>>", { desc = "-/+" } },
            { "H", "5<C-w><" },
            { "L", "5<C-w>>", { desc = "5-/+" } },
            { "j", "<cmd>resize +1<cr>" },
            { "k", "<cmd>resize -1<cr>", { desc = "-/+" } },
            { "J", "<cmd>resize +3<cr>" },
            { "K", "<cmd>resize -3<cr>", { desc = "3-/+" } },
            { "=", "<C-w>=-", { desc = "equalize" } },
        }
    }
end

local function hydra_window_pan()
    return {
       name = "Hydra Pan",
       mode = "n",
       body = "<leader>wp",
        config = {
            color = "pink",
            invoke_on_body = true,
            -- This makes the hint appear properly when using noice.
            hint = {
                type = "statusline",
            },
        },
       heads = {
          { "h", "5zh" },
          { "l", "5zl", { desc = "←/→" } },
          { "H", "zH" },
          { "L", "zL", { desc = "half screen ←/→" } },
       }
    }
end

local function hydra_window_move()
    return {
       name = "Hydra Move",
       mode = "n",
       body = "<leader>wm",
        config = {
            color = "pink",
            invoke_on_body = true,
            -- This makes the hint appear properly when using noice.
            hint = {
                type = "statusline",
            },
        },
       heads = {
          { "h", "<cmd>WinShift left<cr>" },
          { "l", "<cmd>WinShift right<cr>", { desc = "←/→" } },
          { "j", "<cmd>WinShift down<cr>" },
          { "k", "<cmd>WinShift up<cr>", { desc = "↑/↓" } },
       }
    }
end

local function hydra_window_navigate()
    return {
       name = "Hydra Navigate",
       mode = "n",
       body = "<leader>wn",
        config = {
            color = "pink",
            invoke_on_body = true,
            -- This makes the hint appear properly when using noice. NB: the 
            -- status line won't work for navigation unless it's in every 
            -- window, so we use the window instead.
            hint = {
                type = "window",
            },
        },
       heads = {
          { "h", "<cmd>wincmd h<cr>" },
          { "l", "<cmd>wincmd l<cr>", { desc = "←/→" } },
          { "j", "<cmd>wincmd j<cr>" },
          { "k", "<cmd>wincmd k<cr>", { desc = "↑/↓" } },
       }
    }
end

local function hydra_treewalker()
    return {
        name = "Hydra Treewalker",
        mode = "n",
        body = "<leader>wt",
        config = {
            color = "pink",
            invoke_on_body = true,
            -- This makes the hint appear properly when using noice. NB: the 
            -- status line won't work for navigation unless it's in every 
            -- window, so we use the window instead.
            hint = {
                type = "window",
            },
        },
        heads = {
            { "h", "<cmd>Treewalker Left<cr>" },
            { "l", "<cmd>Treewalker Right<cr>", { desc = "←/→" } },
            { "j", "<cmd>Treewalker Down<cr>" },
            { "k", "<cmd>Treewalker Up<cr>", { desc = "↑/↓" } },
            { "H", "<cmd>Treewalker SwapLeft<cr>" },
            { "L", "<cmd>Treewalker SwapRight<cr>", { desc = "Swap ←/→" } },
            { "J", "<cmd>Treewalker SwapDown<cr>" },
            { "K", "<cmd>Treewalker SwapUp<cr>", { desc = "Swap ↑/↓" } },
        }
    }
end

return {
    -- "anuvyklack/hydra.nvim",     -- The original hydra plugin
    -- dir = "E:/Src/hydra.nvim",   -- My own source for debugging
    "nvimtools/hydra.nvim",         -- The updated and maintained version (yay!)
    event = "VeryLazy",
    config = function(_, _)
        local hydra = require("hydra")
        hydra(hydra_dap_menu())
        hydra(hydra_frequent_options())
        hydra(hydra_window_resize())
        hydra(hydra_window_pan())
        hydra(hydra_window_navigate())
        hydra(hydra_window_move())
        hydra(hydra_treewalker())
    end,
}

