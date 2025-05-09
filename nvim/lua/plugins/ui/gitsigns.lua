local defaults = require("config.defaults")

return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            -- add          = { text = '+' },
            -- change       = { text = '┃' },
            -- delete       = { text = '_' },
            add = { text = defaults.icons.git.added },
            change = { text = defaults.icons.git.modified },
            delete = { text = defaults.icons.git.removed },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
            untracked = { text = "┆" },
        },
        signs_staged = {
            -- add          = { text = '+' },
            -- change       = { text = '┃' },
            -- delete       = { text = '_' },
            add = { text = defaults.icons.git.added },
            change = { text = defaults.icons.git.modified },
            delete = { text = defaults.icons.git.removed },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
            untracked = { text = "┆" },
        },
        signs_staged_enable = true,
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
            follow_files = true,
        },
        auto_attach = true,
        attach_to_untracked = false,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = false,
            virt_text_priority = 100,
            use_focus = true,
        },
        current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
            -- Options passed to nvim_open_win
            border = "single",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts and vim.tbl_extend("force", opts, { buffer = bufnr }) or {}
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]h", function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return "<Ignore>"
            end, { expr = true, desc = "next hunk" })

            map("n", "[h", function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return "<Ignore>"
            end, { expr = true, desc = "previous hunk" })

            -- Actions
            map("n", "<leader>hs", gs.stage_hunk, { desc = "stage hunks" })
            map("v", "<leader>hs", function()
                gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { desc = "stage hunks" })
            map("n", "<leader>hr", gs.reset_hunk, { desc = "reset hunks" })
            map("v", "<leader>hr", function()
                gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { desc = "reset hunks" })
            map("n", "<leader>hS", function()
                gs.stage_buffer()
            end, { desc = "stage buffer" })
            map("n", "<leader>hu", function()
                gs.undo_stage_hunk()
            end, { desc = "unstage hunk" })
            map("n", "<leader>hR", function()
                gs.reset_buffer()
            end, { desc = "reset buffer" })
            map("n", "<leader>hp", function()
                gs.preview_hunk()
            end, { desc = "preview hunk" })
            map("n", "<leader>hb", function()
                gs.blame_line({ full = true })
            end, { desc = "blame line" })
            map("n", "<leader>tb", function()
                gs.toggle_current_line_blame()
            end, { desc = "toggle line blame" })
            map("n", "<leader>hd", function()
                gs.diffthis()
            end, { desc = "diff this" })
            map("n", "<leader>hD", function()
                gs.diffthis("~")
            end, { desc = "diff entire buffer" })
            map("n", "<leader>td", function()
                gs.toggle_deleted()
            end, { desc = "toggle deleted" })

            -- Text object
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select hunks" })
        end,
    },
    config = function(_, opts)
        require("gitsigns").setup(opts)
        -- customize the add/change/delete colors based on Tokyonight. This
        -- way they match what I've done with the status line.
        local colors = require("tokyonight.colors").setup()
        vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = colors.terminal.green_bright })
        vim.api.nvim_set_hl(0, "GitSignsChange", { fg = colors.terminal.blue_bright })
        vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = colors.terminal.red })
    end,
}
