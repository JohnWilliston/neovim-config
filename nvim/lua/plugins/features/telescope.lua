-- The following functions are from the awesome-neovim configuration. I was
-- amazed at the sheer number of Telescope options it seems to offer, so I
-- thought I'd crib their approach and leverage it. I also like how easy it
-- is to lazy load the plugin with all the different key combinations.
--
-- https://github.com/Ultra-Code/awesome-neovim/blob/master/lua/plugins/telescope.lua

--TODO: use immediately invoked function expression for vimgrep_arguments .ie
--(fn()statement end)()
--HACK: move mappings from previous configuration here
--https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/builtin/__files.lua
--HELP: telescope nvim

local configutils = require("utils.config-utils")

-- this will return a function that calls telescope.
-- cwd will default to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
local telescope_builtin = function(builtin, opts)
    local params = { builtin = builtin, opts = opts or {} }

    return function()
        builtin = params.builtin
        opts = params.opts
        if builtin == "files" then
            if configutils.is_git_repo() then
                opts.show_untracked = true
                builtin = "git_files"
            else
                builtin = "find_files"
            end
            -- live_grep_from_project_git_root
            -- TODO: test with and without the `get_git_root`
        elseif builtin == "live_grep" then
            if configutils.is_git_repo() then
                opts.cwd = configutils.get_git_root()
            end
            -- This is my own little addition to prevent throwing errors when running
            -- a Git command (any that starts with "git_") when not in a Git repo.
        elseif string.sub(builtin, 1, 4) == "git_" then
            if not configutils.is_git_repo() then
                print("Not inside a Git repo.")
                return
            end
        end
        require("telescope.builtin")[builtin](opts)
    end
end

-- Found this in a GitHub issue and am happy to say it works:
-- https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-1991532321
local function select_one_or_multiple(prompt_bufnr)
    local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
    local multi = picker:get_multi_selection()
    if not vim.tbl_isempty(multi) then
        require('telescope.actions').close(prompt_bufnr)
        for _, j in pairs(multi) do
            if j.path ~= nil then
                vim.cmd(string.format('%s %s', 'edit', j.path))
            end
        end
    else
        require('telescope.actions').select_default(prompt_bufnr)
    end
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope-fzf-native.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
    },
    cmd = "Telescope",
    -- List of builtins here: https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers
    keys = {
        { "<leader><leader>", telescope_builtin("buffers", { show_all_buffers = true }),   desc = "Switch buffer", },

        -- Git integrations, which used to throw an error if not in a Git directory (I fixed that).
        { "<leader>vb",       telescope_builtin("git_branches"),                           desc = "Git branches", },
        { "<leader>vc",       telescope_builtin("git_commits"),                            desc = "Git commits", },
        { "<leader>vf",       telescope_builtin("git_files"),                              desc = "Git files (.gitignore)", },
        { "<leader>vs",       telescope_builtin("git_status"),                             desc = "Git status", },
        { "<leader>vS",       telescope_builtin("git_stash"),                              desc = "Git stash", },
        { "<leader>vu",       telescope_builtin("git_bcommits"),                           desc = "Git buffer commits", },
        { "<leader>vU",       telescope_builtin("git_bcommits_range"),                     desc = "Git buffer commits range", },
        -- LSP navigation.
        { "<leader>li",       telescope_builtin("lsp_implenentations"),                    desc = "Search LSP implementations", },
        { "<leader>l<",       telescope_builtin("lsp_incoming_calls"),                     desc = "Search LSP incoming calls", },
        { "<leader>l>",       telescope_builtin("lsp_outgoing_calls"),                     desc = "Search LSP outgoing calls", },
        { "<leader>ls",       telescope_builtin("lsp_document_symbols"),                   desc = "Search LSP document symbols", },
        { "<leader>lS",       telescope_builtin("lsp_workspace_symbols"),                  desc = "Search LSP workspace symbols", },
        { "<leader>lr",       telescope_builtin("lsp_references"),                         desc = "Search LSP references", },
        { "<leader>lw",       telescope_builtin("lsp_dynamic_workspace_symbols"),          desc = "Search LSP dynamic workspace symbols", },
        -- Other [S]earch related bindings.
        { "<leader>s.",       telescope_builtin("resume"),                                 desc = "Search . repeat", },
        { "<leader>s:",       telescope_builtin("command_history"),                        desc = "Search : command History", },
        { "<leader>sa",       telescope_builtin("autocommands"),                           desc = "Search autocommands", },
        { "<leader>sb",       telescope_builtin("current_buffer_fuzzy_find"),              desc = "Search buffer", },
        { "<leader>sc",       "<cmd>TodoTelescope<CR>",                                    desc = "Todo Comments (Telescope)" },
        { "<leader>sC",       telescope_builtin("colorscheme", { enable_preview = true }), desc = "Search colorscheme with preview", },
        { "<leader>sd",       telescope_builtin("diagnostics", { bufnr = 0 }),             desc = "Search diagnostics", },
        { "<leader>sD",       telescope_builtin("diagnostics"),                            desc = "Search all diagnostics", },
        { "<leader>sf",       telescope_builtin("files"),                                  desc = "Search files", },
        { "<leader>sF",       telescope_builtin("filetypes"),                              desc = "Search file types", },
        { "<leader>sg",       telescope_builtin("live_grep"),                              desc = "Search by grep", },
        { "<leader>sG",       function () require("telescope").extensions.live_grep_args.live_grep_args() end, desc = "Search by grep with live args", },
        { "<leader>s?",       telescope_builtin("help_tags"),                              desc = "Search help", },
        { "<leader>sj",       telescope_builtin("jumplist"),                               desc = "Search jumplist", },
        { "<leader>sk",       telescope_builtin("keymaps"),                                desc = "Search keymaps", },
        { "<leader>sl",       telescope_builtin("loclist"),                                desc = "Search location list", },
        { "<leader>sL",       telescope_builtin("highlights"),                             desc = "Search highlights", },
        -- NOTE: I'm reserving "leader<sm>" for searching whatever marks tool (harpoon, grapple, etc.) I like best.
        { "<leader>sM",       telescope_builtin("marks"),                                  desc = "Search marks", },
        -- { "<leader>sM",       telescope_builtin("man_pages"),                              desc = "Search man pages", },
        -- NOTE: I'm reserving "leader<sn>" for search & replace
        { "<leader>so",       telescope_builtin("oldfiles"),                               desc = "Search old files", },
        { "<leader>sO",       telescope_builtin("vim_options"),                            desc = "Search Vim options", },
        { "<leader>sp",       telescope_builtin("builtin"),                                desc = "Search telescope pickers", },
        { "<leader>sP",       telescope_builtin("planets"),                                desc = "Search planets (fun!)", },
        { "<leader>sq",       telescope_builtin("quickfix"),                               desc = "Search quick fix", },
        { "<leader>sr",       telescope_builtin("registers"),                              desc = "Search registers", },
        { "<leader>sR",       telescope_builtin("reloader"),                               desc = "Search reload modules", },
        { "<leader>ss",       telescope_builtin("spell_suggest"),                          desc = "Search spelling suggestions", },
        { "<leader>s/",       telescope_builtin("search_history"),                         desc = "Search search history", },
        { "<leader>st",       telescope_builtin("tags"),                                   desc = "Search tags" },
        { "<leader>sT",       telescope_builtin("treesitter"),                             desc = "Search treesitter" },
        { "<leader>sw",       telescope_builtin("grep_string"),                            desc = "Search word via grep", },
        { "<leader>sy",       telescope_builtin("symbols"),                                desc = "Search symbols", },
        { "<leader>sz",       telescope_builtin("current_buffer_fuzzy_find"),              desc = "Search current buffer fuzzy", },
    },
    opts = function()
        local actions = require("telescope.actions")
        local actions_layout = require("telescope.actions.layout")
        local lga_actions = require("telescope-live-grep-args.actions")
        local open_with_trouble = require("trouble.sources.telescope").open
        local add_to_trouble = require("trouble.sources.telescope").add
        return {
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
                -- fzf = {
                --     fuzzy = true,                    -- false will only do exact matching
                --     override_generic_sorter = true,  -- override the generic sorter
                --     override_file_sorter = true,     -- override the file sorter
                --     case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                --     -- the default case_mode is "smart_case"
                -- }
                live_grep_args = {

                    auto_quoting = true, -- enable/disable auto-quoting
                    -- define mappings, e.g.
                    mappings = { -- extend mappings
                        i = {
                            ["<C-k>"] = lga_actions.quote_prompt(),
                            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                            -- freeze the current list and start a fuzzy search in the frozen list
                            ["<C-space>"] = lga_actions.to_fuzzy_refine,
                        },
                    },
                    -- ... also accepts theme settings, for example:
                    -- theme = "dropdown", -- use dropdown theme
                    -- theme = { }, -- use own theme spec
                    -- layout_config = { mirror=true }, -- mirror preview pane
                }
            },
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                mappings = {
                    i = {
                        --["<C-[>"] = actions.close, -- This binds escape to close with a single press.
                        -- ["<M-i>"] = function()
                        --     telescope_builtin(
                        --         "find_files",
                        --         { no_ignore = true }
                        --     )()
                        -- end,
                        -- ["<M-h>"] = function()
                        --     telescope_builtin(
                        --         "find_files",
                        --         { hidden = true }
                        --     )()
                        -- end,
                        ["<C-Down>"] = actions.cycle_history_next,
                        ["<C-Up>"] = actions.cycle_history_prev,
                        ["<M-Down>"] = actions.cycle_history_next,
                        ["<M-Up>"] = actions.cycle_history_prev,
                        ["<C-d>"] = actions.delete_buffer,
                        ["<C-h>"] = actions.preview_scrolling_left,
                        ["<C-l>"] = actions.preview_scrolling_right,
                        ["<C-q>"] = open_with_trouble,
                        ["<A-q>"] = add_to_trouble,
                        ["<M-p>"] = actions_layout.toggle_preview,
                        ["<CR>"] = select_one_or_multiple,
                    },
                    n = {
                        ["dd"] = actions.delete_buffer,
                        ["<C-d>"] = actions.delete_buffer,
                        ["q"] = actions.close,
                        ["<C-[>"] = actions.close,
                        ["<C-q>"] = open_with_trouble,
                        ["<A-q>"] = add_to_trouble,
                    },
                },
            },
        }
    end,
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("ui-select")
        telescope.load_extension("refactoring")
        telescope.load_extension("live_grep_args")
    end,
}
