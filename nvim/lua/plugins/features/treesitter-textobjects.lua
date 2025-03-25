return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    keys = {
        { "<leader>;", function () require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move() end, desc = "Repeat last move", mode = { "n", "x", "o" } },
        { "<leader>,", function () require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move_opposite() end, desc = "Repeat last move opposite", mode = { "n", "x", "o" } },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    lazy = true,
    opts = {
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim

                -- See https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#built-in-textobjects
                -- for the matrix of available text objects supported in various languages.
                -- Watch video https://www.youtube.com/watch?v=CEMPq_r8UYQ
                -- for a good tutorial on how to configure these methods.
                keymaps = {
                    ["a="] = { query = "@assignment.outer", desc = "An assignment" },
                    ["i="] = { query = "@assignment.inner", desc = "Inner assignment" },
                    ["l="] = { query = "@assignment.lhs", desc = "LHS assignment" },
                    ["r="] = { query = "@assignment.rhs", desc = "RHS assignment" },

                    ["af"] = { query = "@function.outer", desc = "A function" },
                    ["if"] = { query = "@function.inner", desc = "Inner function" },

                    ["ac"] = { query = "@class.outer", desc = "A class" },
                    ["ic"] = { query = "@class.inner", desc = "Inner class" },

                    ["ap"] = { query = "@parameter.outer", desc = "A parameter" },
                    ["ip"] = { query = "@parameter.inner", desc = "Inner parameter" },

                    ["ai"] = { query = "@conditional.outer", desc = "A conditional" },
                    ["ii"] = { query = "@conditional.inner", desc = "Inner conditional" },

                    ["al"] = { query = "@loop.outer", desc = "A loop" },
                    ["il"] = { query = "@loop.inner", desc = "Inner loop" },

                    ["aj"] = { query = "@call.outer", desc = "A jump" },
                    ["ij"] = { query = "@call.inner", desc = "Inner jump" },

                    ["a/"] = { query = "@comment.outer", desc = "A comment" },
                    ["i/"] = { query = "@comment.inner", desc = "Inner comment" },

                    ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                },
                -- You can choose the select mode (default is charwise 'v')
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * method: eg 'v' or 'o'
                -- and should return the mode ('v', 'V', or '<c-v>') or a table
                -- mapping query_strings to modes.
                selection_modes = {
                    ['@parameter.outer'] = 'v', -- charwise
                    ['@function.outer'] = 'V', -- linewise
                    ['@class.outer'] = '<c-v>', -- blockwise
                },
                -- If you set this to `true` (default is `false`) then any textobject is
                -- extended to include preceding or succeeding whitespace. Succeeding
                -- whitespace has priority in order to act similarly to eg the built-in
                -- `ap`.
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * selection_mode: eg 'v'
                -- and should return true or false
                include_surrounding_whitespace = true,
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>xcn"] = "@class.outer",
                    ["<leader>xfn"] = "@function.outer",
                    ["<leader>xpn"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>xcp"] = "@class.outer",
                    ["<leader>xfp"] = "@function.outer",
                    ["<leader>xpp"] = "@parameter.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]c"] = { query = "@class.outer", desc = "Next class" },
                    ["]f"] = { query = "@function.outer", desc = "Next function" },
                    ["]p"] = { query = "@parameter.inner", desc = "Next parameter" },
                    --
                    -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
                    ["]l"] = "@loop.*",
                    -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
                    --
                    -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                    -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                    ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                    ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                },
                goto_next_end = {
                    ["]F"] = "@function.outer",
                    ["]C"] = "@class.outer",
                },
                goto_previous_start = {
                    ["[f"] = "@function.outer",
                    ["[c"] = "@class.outer",
                },
                goto_previous_end = {
                    ["[F"] = "@function.outer",
                    ["[C"] = "@class.outer",
                },
                -- Below will go to either the start or the end, whichever is closer.
                -- Use if you want more granular movements
                -- Make it even more gradual by adding multiple queries and regex.
                goto_next = {
                    ["]d"] = "@conditional.outer",
                },
                goto_previous = {
                    ["[d"] = "@conditional.outer",
                }
            },
        },
    },
    -- I don't understand why this function must be called here, but you'll
    -- get an error message about how the treesitter config wasn't called
    -- if you don't keep this line here.
    -- TODO: Figure out some better way to configure this.
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}

