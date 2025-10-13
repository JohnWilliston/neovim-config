local configutils = require("utils.config-utils")
local envutils = require("utils.env-utils")
local telescope_utils = require("utils.telescope-utils")

-- Uses my own custom entry to improve buffer selection. Cribbed from:
-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#customize-buffers-display-to-look-like-leaderf
local search_buffers = function()
    local opts = {
        entry_maker = telescope_utils.buffer_entry_maker(), 
    }
    require("telescope.builtin")["buffers"](opts)
end

local search_sibling_files = function()
    path = configutils.get_current_file_path()
    require("telescope.builtin")["find_files"]({cwd = path})
end

local search_yaml_symbols = function()
    local opts = {
        layout_config = {
            preview_width = 0.5,
        },
    }
    telescope_utils.yaml_symbols_picker(opts)
end

local search_snippets = function()
    local theme = require("telescope.themes").get_dropdown({
        layout_strategy = "horizontal", 
        layout_config = {
            horizontal = { height = 0.6, width = 0.85 },
            preview_width = 0.4,
            prompt_position = "top", 
        },
    })
    require("telescope").extensions.luasnip.luasnip(theme)
end

-- The following are originally from the awesome-neovim configuration. I was
-- amazed at the sheer number of Telescope options it offered, so I
-- thought I'd crib their approach and expand it. See:
--
-- https://github.com/Ultra-Code/awesome-neovim/blob/master/lua/plugins/telescope.lua

-- this will return a function that calls telescope or pathogen.
-- cwd will default to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
local telescope_builtin = function(builtin, opts)
    local params = { builtin = builtin, opts = opts or {} }

    return function()
        local pathogen = false
        builtin = params.builtin
        opts = params.opts
        if builtin == "files" then
            if configutils.is_git_repo() then
                opts.show_untracked = true
                builtin = "git_files"
            else
                builtin = "find_files"
                pathogen = true
            end
            -- live_grep_from_project_git_root
        elseif builtin == "live_grep" then
            pathogen = true
            if configutils.is_git_repo() then
                opts.cwd = configutils.get_git_root()
            end
            -- This is my own little addition to prevent throwing errors when running
            -- a Git command (any that starts with "git_") when not in a Git repo.
        elseif builtin == "grep_string" then
            pathogen = true
        elseif string.sub(builtin, 1, 4) == "git_" then
            if not configutils.is_git_repo() then
                print("Not inside a Git repo.")
                return
            end
        end
        -- if pathogen then
        --     -- vim.print(string.format(" Pathogen builtin -> %s", builtin))
        --     -- vim.print(opts)
        --     require("telescope").extensions["pathogen"][builtin](opts)
        -- else
            -- vim.print(string.format("Telescope builtin -> %s", builtin))
            -- vim.print(opts)
            require("telescope.builtin")[builtin](opts)
        -- end
    end
end

-- Found this in a GitHub issue and am happy to say it works:
-- https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-1991532321
local function select_one_or_multiple(prompt_bufnr)
    local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
    local multi = picker:get_multi_selection()
    if not vim.tbl_isempty(multi) then
        require("telescope.actions").close(prompt_bufnr)
        for _, j in pairs(multi) do
            if j.path ~= nil then
                vim.cmd(string.format("%s %s", "edit", j.path))
            end
        end
    else
        require("telescope.actions").select_default(prompt_bufnr)
    end
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        -- Normal telescope dependencies.
        { "nvim-lua/plenary.nvim" },
        { "nvim-tree/nvim-web-devicons" },
        -- All the various add-ins I've enabled. See all the load-extension
        -- calls down below in the config method.
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "nvim-telescope/telescope-file-browser.nvim" },
        { 
            "nvim-telescope/telescope-fzf-native.nvim",
            -- FIX: Find a more platform independent way to handle this.
            build = "make" -- Works on Linux/macOS, fails on Windows
        },
        { "nvim-telescope/telescope-live-grep-args.nvim" },
        -- { "TC72/telescope-tele-tabby.nvim" },
        { "LukasPietzschmann/telescope-tabs" },
        { "xiyaowong/telescope-emoji.nvim" },
        { "ghassan0/telescope-glyph.nvim" },
        { "ANGkeith/telescope-terraform-doc.nvim" },
        { "debugloop/telescope-undo.nvim" },
        { "benfowler/telescope-luasnip.nvim" },
        { "tsakirist/telescope-lazy.nvim" },
        { "polirritmico/telescope-lazy-plugins.nvim" },
        {
            "prochri/telescope-all-recent.nvim",
            dependencies = {
                "nvim-telescope/telescope.nvim",
                "kkharji/sqlite.lua",
                -- optional, if using telescope for vim.ui.select
                "stevearc/dressing.nvim"
            },
            opts =
                {
                    -- your config goes here
                }
        },
        -- A helpful picker plugin to use for opening in a chosen window.
        { 
            "s1n7ax/nvim-window-picker",
            opts = {

                selection_chars = "123456789ABCDEF",
                show_prompt = false,
                -- FIX: Come up with a color-scheme related way to do this.
                highlights = {
                    enabled = true,
                    statusline = {
                        focused = {
                            fg = '#ededed',
                            bg = '#e35e4f',
                            bold = true,
                        },
                        unfocused = {
                            fg = '#ededed',
                            bg = '#0077cc',
                            bold = true,
                        },
                    },
                    winbar = {
                        focused = {
                            fg = '#ededed',
                            bg = '#e35e4f',
                            bold = true,
                        },
                        unfocused = {
                            fg = '#ededed',
                            bg = '#0077cc',
                            bold = true,
                        },
                    },
                },
            },
        },
        -- { "telescope-pathogen.nvim" },
        { "brookhong/telescope-pathogen.nvim" },
        { "SalOrak/whaler" },
    },
    cmd = "Telescope",
    -- List of builtins here: https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers
    keys = {
        -- { "<leader><leader>", telescope_builtin("buffers", { show_all_buffers = true }),   desc = "Switch buffer", },
        { "<leader><leader>", search_buffers,                                              desc = "Switch buffer", },
        -- File browser extension mapping.
        { "<leader>fb", "<cmd>Telescope file_browser<cr>", desc = "Telescope file browser" },
        -- Git integrations, which used to throw an error if not in a Git directory (I fixed that).
        { "<leader>vb",       telescope_builtin("git_branches"),                           desc = "Git branches", },
        { "<leader>vc",       telescope_builtin("git_commits"),                            desc = "Git commits", },
        -- I already have this built into my file search, so I don't need it.
        -- { "<leader>vf",       telescope_builtin("git_files"),                              desc = "Git files (.gitignore)", },
        { "<leader>vf",       telescope_builtin("git_bcommits"),                           desc = "Git file history", },
        { "<leader>vl",       telescope_builtin("git_bcommits_range"),                     desc = "Git file line history", },
        { "<leader>vs",       telescope_builtin("git_status"),                             desc = "Git status", },
        { "<leader>vt",       telescope_builtin("git_stash"),                              desc = "Git stash list", },
        -- LSP navigation.
        { "<leader>li",       telescope_builtin("lsp_implementations"),                    desc = "Search LSP implementations", },
        { "<leader>l<",       telescope_builtin("lsp_incoming_calls"),                     desc = "Search LSP incoming calls", },
        { "<leader>l>",       telescope_builtin("lsp_outgoing_calls"),                     desc = "Search LSP outgoing calls", },
        { "<leader>ls",       telescope_builtin("lsp_document_symbols"),                   desc = "Search LSP document symbols", },
        { "<leader>lS",       telescope_builtin("lsp_workspace_symbols"),                  desc = "Search LSP workspace symbols", },
        { "<leader>lr",       telescope_builtin("lsp_references"),                         desc = "Search LSP references", },
        { "<leader>lw",       telescope_builtin("lsp_dynamic_workspace_symbols"),          desc = "Search LSP dynamic workspace symbols", },
        { "<leader>s`",       search_sibling_files,                                        desc = "Search sibling files", },
        { "<leader>s.",       telescope_builtin("resume"),                                 desc = "Search . repeat", },
        { "<leader>s:",       telescope_builtin("command_history"),                        desc = "Search : command History", },
        { "<leader>s&",       "<cmd>Telescope glyph<CR>",                                  desc = "Search font glyphs" },
        { "<leader>s0",       "<cmd>Telescope yank_history<CR>",                           desc = "Search yank history" },
        { "<leader>sa",       telescope_builtin("autocommands"),                           desc = "Search autocommands", },
        { "<leader>sb",       telescope_builtin("current_buffer_fuzzy_find"),              desc = "Search buffer", },
        { "<leader>sc",       "<cmd>TodoTelescope<CR>",                                    desc = "Todo Comments (Telescope)" },
        { "<leader>sC",       telescope_builtin("colorscheme", { enable_preview = true }), desc = "Search colorscheme with preview", },
        { "<leader>sd",       telescope_builtin("diagnostics", { bufnr = 0 }),             desc = "Search diagnostics", },
        { "<leader>sD",       telescope_builtin("diagnostics"),                            desc = "Search all diagnostics", },
        { "<leader>se",       "<cmd>Telescope emoji<CR>",                                  desc = "Search emoji" },
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
        { "<leader>sR",       telescope_builtin("reloader"),                               desc = "Search and reload Lua modules", },
        { "<leader>ss",       telescope_builtin("spell_suggest"),                          desc = "Search spelling suggestions", },
        -- { "<leader>sS",       "<cmd>Telescope luasnip<CR>",                                desc = "Search Luasnip snippets", },
        { "<leader>sS",       search_snippets,                                             desc = "Search Luasnip snippets" },
        { "<leader>s/",       telescope_builtin("search_history"),                         desc = "Search search history", },
        -- NOTE: I just don't use tags enough for this to be helpful. As such I'm reserving to search tabs. 
        -- { "<leader>st",       telescope_builtin("tags"),                                   desc = "Search tags" },
        { "<leader>st",       "<cmd>Telescope telescope-tabs list_tabs<CR>",               desc = "Search tabs" },
        { "<leader>sT",       telescope_builtin("treesitter"),                             desc = "Search treesitter" },
        { "<leader>su",       "<cmd>Telescope undo<CR>",                                   desc = "Search undo" },
        { "<leader>sw",       telescope_builtin("grep_string"),                            desc = "Search word via grep", },
        { "<leader>sW",       function () require("telescope").extensions.whaler.whaler() end, desc = "Cwd with Whaler" },
        { "<leader>sxt",      "<cmd>Telescope terraform_doc<CR>",                          desc = "Search extras - Terraform providers docs", },
        { "<leader>sxl",      "<cmd>Telescope lazy<CR>",                                   desc = "Search extras - Lazy plugin information", },
        { "<leader>sxL",      "<cmd>Telescope lazy_plugins<CR>",                           desc = "Search extras - Lazy plugin configuration", },
        { "<leader>sy",       telescope_builtin("symbols"),                                desc = "Search symbols", },
        { "<leader>sY",       search_yaml_symbols,                                         desc = "Search YAML symbols", },
    },
    opts = function()
        local actions = require("telescope.actions")
        local actions_layout = require("telescope.actions.layout")
        local lga_actions = require("telescope-live-grep-args.actions")
        local open_with_trouble = require("trouble.sources.telescope").open
        local add_to_trouble = require("trouble.sources.telescope").add
        return {
            extensions = {
                -- Note the unique syntax because the name has a hyphen.
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
                file_browser = {
                    theme = "ivy",
                },
                fzf = {
                    fuzzy = true,                    -- false will only do exact matching
                    override_generic_sorter = true,  -- override the generic sorter
                    override_file_sorter = true,     -- override the file sorter
                    case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                },
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
                },
                -- tele_tabby = {
                --     use_highlighter = true,
                -- },
                ["telescope-tabs"] = {
                    close_tab_shortcut_i = '<A-d>',  -- if you're in insert mode
                    close_tab_shortcut_n = 'dd',     -- if you're in normal mode
                    -- A minor change here to include tab number in search.
                    entry_ordinal = function(tab_id, buffer_ids, file_names, file_paths, is_current)
                        return string.format("%d %s", tab_id, table.concat(file_names, ' '))
                    end,
                },
                -- Type information can be loaded via 'https://github.com/folke/lazydev.nvim'
                -- by adding the below two annotations:
                ---@module "telescope._extensions.lazy"
                ---@type TelescopeLazy.Config
                lazy = {
                    -- Optional theme (the extension doesn't set a default theme)
                    theme = "ivy",
                    -- The below configuration options are the defaults
                    show_icon = true,
                    mappings = {
                        open_in_browser = "<C-o>",
                        open_in_file_browser = "<M-b>",
                        open_in_find_files = "<C-f>",
                        open_in_live_grep = "<C-g>",
                        open_in_terminal = "<C-t>",
                        open_plugins_picker = "<C-b>",
                        open_lazy_root_find_files = "<C-r>f",
                        open_lazy_root_live_grep = "<C-r>g",
                        change_cwd_to_plugin = "<C-c>d",
                    },
                    actions_opts = {
                        open_in_browser = {
                            auto_close = false,
                        },
                        change_cwd_to_plugin = {
                            auto_close = false,
                        },
                    },
                    terminal_opts = {
                        relative = "editor",
                        style = "minimal",
                        border = "rounded",
                        title = "Telescope lazy",
                        title_pos = "center",
                        width = 0.5,
                        height = 0.5,
                    },
                    -- Other telescope configuration options
                },
                -- It seems like the lazy plugins is a bit out of date with 
                -- respect to telescope layout options. It uses the "flex"
                -- layout by default and apparently support for some of these
                -- settings has changed. So I'm overriding it to set things to 
                -- use the horizontal layout instead.
                lazy_plugins = {
                    picker_opts = {
                        sorting_strategy = "ascending",
                        layout_strategy = "horizontal",
                    },
                },
                cder = opts,
                -- pathogen = {
                --     attach_mappings = function(map, actions)
                --         map("i", "<C-o>", actions.proceed_with_parent_dir)
                --         map("i", "<C-l>", actions.revert_back_last_dir)
                --         map("i", "<C-b>", actions.change_working_directory)
                --         map("i", "<C-g>g", actions.grep_in_result)
                --         map("i", "<C-g>i", actions.invert_grep_in_result)
                --     end,
                --     -- remove below if you want to enable it
                --     use_last_search_for_live_grep = false,
                --     -- quick_buffer_characters = "asdfgqwertzxcvb",
                --     prompt_prefix_length = 100
                -- },
                whaler = {
                    auto_file_explorer = false,
                    directories = envutils.get_env_data("whaler", "directories"),
                    oneoff_directories = envutils.get_env_data("whaler", "oneoff_directories"),
                },
            },
            defaults = {
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = { height = 0.9, width = 0.9, preview_width = 0.7 },
                    vertical = { height = 0.9, width = 0.9 },
                    prompt_position = "bottom", 
                },
                preview = {
                    filesize_limit = 0.5, -- MB
                },
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
                        -- ["<C-d>"] = actions.delete_buffer,
                        ["<C-h>"] = actions.preview_scrolling_left,
                        ["<C-l>"] = actions.preview_scrolling_right,
                        ["<C-q>"] = open_with_trouble,
                        ["<A-q>"] = add_to_trouble,

                        ["<M-p>"] = actions_layout.toggle_preview,
                        ["<CR>"] = select_one_or_multiple,
                        -- Clear the search field rather than scroll.
                        -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#mapping-c-u-to-clear-prompt
                        -- ["<C-u>"] = false,
                        ["<C-s>"] = actions.cycle_previewers_next,
                        ["<C-a>"] = actions.cycle_previewers_prev,

                        -- Helpful tool to choose a window for opening.
                        -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#using-nvim-window-picker-to-choose-a-target-window-when-opening-a-file-from-any-picker
                        ["<C-w>"] = function(prompt_bufnr)
                            -- Use nvim-window-picker to choose the window by dynamically attaching a function
                            local action_set = require("telescope.actions.set")
                            local action_state = require("telescope.actions.state")

                            local picker = action_state.get_current_picker(prompt_bufnr)
                            picker.get_selection_window = function(picker, entry)
                                local picked_window_id = require("window-picker").pick_window() or vim.api.nvim_get_current_win()
                                -- Unbind after using so next instance of the picker acts normally
                                picker.get_selection_window = nil
                                return picked_window_id
                            end

                            return action_set.edit(prompt_bufnr, "edit")
                        end,
                    },
                    n = {
                        -- ["dd"] = actions.delete_buffer,
                        -- ["<C-d>"] = actions.delete_buffer,
                        ["q"] = actions.close,
                        ["<C-[>"] = actions.close,
                        ["<C-q>"] = open_with_trouble,
                        ["<A-q>"] = add_to_trouble,
                        ["<M-p>"] = actions_layout.toggle_preview,
                    },
                },
            },
            pickers = {
                buffers = {
                    layout_strategy = "vertical",
                    layout_config = {
                        vertical = { height = 0.9, width = 0.9 },
                        preview_height = 0.4,
                        prompt_position = "bottom", 
                    },
                    mappings = {
                        n = {
                            -- Allow deleting in-memory buffers in the picker.
                            ["dd"] = actions.delete_buffer + actions.move_to_top,
                        },
                    },
                },
            },
        }
    end,
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("file_browser")
        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")
        telescope.load_extension("refactoring")
        telescope.load_extension("live_grep_args")
        telescope.load_extension("telescope-tabs")
        telescope.load_extension("emoji")
        telescope.load_extension('glyph')
        telescope.load_extension("yank_history")
        telescope.load_extension("terraform_doc")
        telescope.load_extension("undo")
        telescope.load_extension("luasnip")
        telescope.load_extension("lazy")
        telescope.load_extension("lazy_plugins")
        -- telescope.load_extension("pathogen")
        telescope.load_extension("whaler")
    end,
}
