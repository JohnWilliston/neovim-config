return {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    keys = {
        { "<leader>ot", ":ObsidianToday<CR>",        desc = "Obsidian Today" },
        { "<leader>oq", ":ObsidianQuickSwitch<CR>",  desc = "Obsidian Quickswitch" },
        { "<leader>or", ":ObsidianDailies -7 1<CR>", desc = "Obsidian Recent Notes" },
    },
    cmd = {
        "ObsidianOpen",
        "ObsidianNew",
        "ObsidianFollowLink",
        "ObsidianBacklinks",
        "ObsidianTags",
        "ObsidianToday",
        "ObsidianYesterday",
        "ObsidianTomorrow",
        "ObsidianDailies",
        "ObsidianTemplate",
        "ObsidianSearch",
        "ObsidianLink",
        "ObsidianLinkNew",
        "ObsidianLinks",
        "ObsidianExtractNote",
        "ObsidianWorkspace",
        "ObsidianPasteImg",
        "ObsidianRename",
        "ObsidianToggleCheckbox",
        "ObsidianNewFromTemplate",
        "ObsidianTOC",
    },
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",

        -- see below for full list of optional dependencies 👇
    },
    init = function()
        -- The conceal feature lets you conceal bits of text by displaying other
        -- bits of text in their place. The Obsidian plugin leverages this to
        -- provide cool symbols in place of the more verbose markdown stuff. For
        -- that to work, however, the conceal level must be set to 1 or 2.
        vim.opt.conceallevel = 1
    end,
    opts = {
        -- Disabling this plugin's UI to avoid conflicts with render-markdown.
        ui = {
            enable = false,
            checkboxes = {
                -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
                [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                ["x"] = { char = "", hl_group = "ObsidianDone" },
                [">"] = { char = "", hl_group = "ObsidianRightArrow" },
                ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
                ["!"] = { char = "", hl_group = "ObsidianImportant" },
                -- Replace the above with this if you don't have a patched font:
                -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
                -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

                -- You can also add more custom ones...
            },
        },
        -- Workspaces are a way of telling the plugin that it's in a vault.
        -- And technically, you can slice and dice vaults up into multiple
        -- workspaces or work with multiple vaults. The plugin seems quite
        -- flexible in that regard.
        workspaces = {
            {
                name = "DEFCON",
                path = "~/Documents/Obsidian/DEFCON",
            },
        },

        -- see below for full list of options 👇
        daily_notes = {
            -- Optional, if you keep daily notes in a separate directory.
            folder = "Captain's Log",
            -- Optional, if you want to change the date format for the ID of daily notes.
            date_format = "%Y/%m/%Y-%m-%d",
            -- Optional, if you want to change the date format of the default alias of daily notes.
            --alias_format = "%B %-d, %Y",
            -- Optional, default tags to add to each new daily note created.
            default_tags = { "Log" },
            -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
            template = "Captain's Log.md",
        },

        -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
        completion = {
            -- Set to false to disable completion.
            nvim_cmp = true,
            -- Trigger completion at 2 chars.
            min_chars = 2,
        },

        -- Where to put new notes. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "current_dir",

        -- Optional, for templates (see below).
        templates = {
            folder = "Templates",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
            -- A map for custom variables, the key should be the variable and the value a function
            substitutions = {},
        },

        -- Either 'wiki' or 'markdown'.
        preferred_link_style = "wiki",

        -- Optional, boolean or a function that takes a filename and returns a boolean.
        -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
        disable_frontmatter = true,

        picker = {
            -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
            name = "telescope.nvim",
            -- Optional, configure key mappings for the picker. These are the defaults.
            -- Not all pickers support all mappings.
            note_mappings = {
                -- Create a new note from your query.
                new = "<C-x>",
                -- Insert a link to the selected note.
                insert_link = "<C-l>",
            },

            tag_mappings = {
                -- Add tag(s) to current note.
                tag_note = "<C-x>",
                -- Insert a tag at the current location.
                insert_tag = "<C-l>",
            },
        },
    },
}
