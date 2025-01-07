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
local function is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    ---@diagnostic disable-next-line: undefined-field
    return vim.v.shell_error == 0
end

-- this will return a function that calls telescope.
-- cwd will default to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
local telescope_builtin = function(builtin, opts)
    local params = { builtin = builtin, opts = opts or {} }

    return function()
        builtin = params.builtin
        opts = params.opts
        if builtin == "files" then
            if is_git_repo() then
                opts.show_untracked = true
                builtin = "git_files"
            else
                builtin = "find_files"
            end
            -- live_grep_from_project_git_root
            -- TODO: test with and without the `get_git_root`
        elseif builtin == "live_grep" then
            local function get_git_root()
                local dot_git_path = vim.fn.finddir(".git", ".;")
                return vim.fn.fnamemodify(dot_git_path, ":h")
            end
            if is_git_repo() then
                opts.cwd = get_git_root()
            end
            -- This is my own little addition to prevent throwing errors when running
            -- a Git command (any that starts with "git_") when not in a Git repo.
        elseif string.sub(builtin, 1, 4) == "git_" then
            if not is_git_repo() then
                print("Not inside a Git repo.")
                return
            end
        end
        require("telescope.builtin")[builtin](opts)
    end
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    cmd = "Telescope",
    -- While I normally tend to prefer consolidating keymaps, the unique
    -- telescope handling functions above mean I keep it here for now.
    keys = {
        { "<leader><leader>", telescope_builtin("buffers", { show_all_buffers = true }),   desc = "Switch buffer", },

        -- Git integrations, which used to throw an error if not in a Git directory (I fixed that).
        { "<leader>gc",       telescope_builtin("git_commits"),                            desc = "Git commits", },
        { "<leader>gs",       telescope_builtin("git_status"),                             desc = "Git status", },

        { "<leader>ls",       telescope_builtin("lsp_document_symbols"),                   desc = "Search lsp document symbols", },
        { "<leader>lS",       telescope_builtin("lsp_workspace_symbols"),                  desc = "Search lsp workspace Symbols", },
        { "<leader>lr",       telescope_builtin("lsp_references"),                         desc = "Search lsp references", },

        { "<leader>s.",       telescope_builtin("resume"),                                 desc = "Search . repeat", },
        { "<leader>s:",       telescope_builtin("command_history"),                        desc = "Search : command History", },
        { "<leader>sa",       telescope_builtin("autocommands"),                           desc = "Search autocommands", },
        { "<leader>sb",       telescope_builtin("current_buffer_fuzzy_find"),              desc = "Search buffer", },
        { "<leader>sc",       telescope_builtin("colorscheme", { enable_preview = true }), desc = "Search colorscheme with preview", },
        { "<leader>sd",       telescope_builtin("diagnostics", { bufnr = 0 }),             desc = "Search diagnostics", },
        { "<leader>sD",       telescope_builtin("diagnostics"),                            desc = "Search all diagnostics", },
        { "<leader>sf",       telescope_builtin("files"),                                  desc = "Search files", },
        { "<leader>sg",       telescope_builtin("live_grep"),                              desc = "Search by grep", },
        { "<leader>sh",       telescope_builtin("help_tags"),                              desc = "Search help", },
        { "<leader>sj",       telescope_builtin("jumplist"),                               desc = "Search jumplist", },
        { "<leader>sk",       telescope_builtin("keymaps"),                                desc = "Search keymaps", },
        { "<leader>sl",       telescope_builtin("highlights"),                             desc = "Search highlights", },
        { "<leader>sm",       telescope_builtin("marks"),                                  desc = "Search marks", },
        { "<leader>sM",       telescope_builtin("man_pages"),                              desc = "Search man pages", },
        { "<leader>so",       telescope_builtin("oldfiles"),                               desc = "Search old files", },
        { "<leader>sp",       telescope_builtin("builtin"),                                desc = "Search telescope pickers", },
        { "<leader>ss",       telescope_builtin("spell_suggest"),                          desc = "Search spelling suggestions", },
        -- <leader>st is taken by searching for to-do comments, defined in ../keymaps.lua
        { "<leader>sv",       telescope_builtin("vim_options"),                            desc = "Search vim options", },
        { "<leader>sw",       telescope_builtin("grep_string"),                            desc = "Search current word", },
    },
    opts = function()
        local actions = require("telescope.actions")
        local actions_layout = require("telescope.actions.layout")
        local open_with_trouble = require("trouble.sources.telescope").open
        local add_to_trouble = require("trouble.sources.telescope").add

        return {
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
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
                        ["<C-h>"] = actions.preview_scrolling_left,
                        ["<C-l>"] = actions.preview_scrolling_right,
                        ["<C-t>"] = open_with_trouble,
                        ["<A-t>"] = add_to_trouble,
                        ["<M-p>"] = actions_layout.toggle_preview,
                    },
                    n = {
                        ["q"] = actions.close,
                        ["<C-[>"] = actions.close,
                        ["<C-t>"] = open_with_trouble,
                        ["<A-t>"] = add_to_trouble,
                    },
                },
            },
        }
    end,
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("ui-select")
    end,
}
