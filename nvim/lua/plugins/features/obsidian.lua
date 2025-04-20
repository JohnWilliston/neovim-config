return {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    keys = {
        { "<leader>od", "<cmd>ObsidianToday<CR>",        desc = "Obsidian today's notes" },
        { "<leader>oi", "<cmd>ObsidianTaskID<CR>",       desc = "Obsidian add task ID" },
        { "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>",  desc = "Obsidian quickswitch" },
        { "<leader>or", "<cmd>ObsidianDailies -7 1<CR>", desc = "Obsidian recent notes" },
        { "<leader>ot", "<cmd>ObsidianCreateTask<CR>",   desc = "Obsidian create task" },
        {
            "<leader>oT",
            function()
                vim.cmd.ObsidianCreateTask()
                vim.cmd.ObsidianTaskID()
            end,
            desc = "Obsidian create task with Morgen ID",
        },
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

        -- Code "borrowed" shamelessly--thanks, Alex G.!-- from a colleague who
        -- got Morgen task integration working before demonstrating it to me.
        -- See the following very helpful URL for the details:
        -- https://www.morgen.so/guides/integrate-and-time-block-tasks-from-obsidian
        vim.api.nvim_create_user_command("ObsidianCreateTask", function()
            -- Get the current line
            local line = vim.api.nvim_get_current_line()

            -- Check if the line is already a task
            if line:match("^%s*%-%s*%[%s*[%s%+xX]%s*%]") then
                print("Line is already a task")
                return
            end

            -- Remove leading whitespace for processing
            local indentation = line:match("^(%s*)")
            local content = line:gsub("^%s*", "")

            -- Don't convert empty lines
            if content == "" then
                print("Cannot convert empty line to task")
                return
            end

            -- Create task format: "- [ ] task content"
            local task_line = indentation .. "- [ ] " .. content

            -- Replace the current line with the task line
            vim.api.nvim_set_current_line(task_line)
            print("Converted line to task")
        end, { desc = "make a line in an obsidian note a task" })

        vim.api.nvim_create_user_command("ObsidianTaskID", function()
            -- Get the current line
            local line = vim.api.nvim_get_current_line()

            -- Check if the line is a task
            if not line:match("^%s*%-%s*%[%s*[%s%+xX]%s*%]") then
                print("Current line is not a task")
                return
            end

            -- Generate a task ID in the format "🆔 9562kk" (emoji + space + 6 alphanumeric chars)
            -- This creates a shorter, more readable ID format as requested
            local function generate_task_id()
                local chars = "0123456789abcdefghijklmnopqrstuvwxyz"
                local id = ""

                -- Generate 6 random alphanumeric characters
                for _ = 1, 6 do
                    local rand_index = math.random(1, #chars)
                    id = id .. string.sub(chars, rand_index, rand_index)
                end

                -- Return the ID with the ID emoji prefix
                return "🆔 " .. id
            end

            local task_id = generate_task_id()

            -- Check if the task already has an ID
            if line:match("🆔%s+[%w]+") then
                -- Replace the existing ID
                line = line:gsub("(🆔%s+[%w]+)", task_id)
            else
                -- Append the ID at the end of the line
                line = line .. " " .. task_id
            end

            -- Update the current line
            vim.api.nvim_set_current_line(line)
            print("Added ID to task: " .. task_id)
        end, { desc = "make a line in an obsidian note a task" })

        vim.api.nvim_create_user_command("ObsidianTaskDue", function()
            -- Get the current line
            local line = vim.api.nvim_get_current_line()

            -- Check if the line is a task
            if not line:match("^%s*%-%s*%[%s*[%s%+xX]%s*%]") then
                print("Current line is not a task")
                return
            end

            -- Prompt the user for number of days from now
            vim.ui.input({
                prompt = "Due in how many days? (0 for today, 1 for tomorrow, etc.): ",
                default = "1", -- Default to tomorrow
            }, function(days_input)
                -- Early return if user cancels the prompt
                if not days_input then
                    print("Date addition cancelled")
                    return
                end

                -- Convert input to number and validate
                local days = tonumber(days_input)
                if not days then
                    print("Invalid input: Please enter a number")
                    return
                end

                -- Get the future date in YYYY-MM-DD format
                local function get_future_date(days_offset)
                    -- Get current time and add the specified days (86400 seconds per day)
                    local current_time = os.time()
                    local future_time = current_time + (days_offset * 86400)

                    -- Format the date as YYYY-MM-DD
                    return os.date("%Y-%m-%d", future_time)
                end

                local future_date = get_future_date(days)
                local date_tag = "📅 " .. future_date

                -- Check if the task already has a date tag
                if line:match("📅%s+%d%d%d%d%-%d%d%-%d%d") then
                    -- Replace the existing date
                    line = line:gsub("(📅%s+%d%d%d%d%-%d%d%-%d%d)", date_tag)
                else
                    -- Append the date at the end of the line
                    line = line .. " " .. date_tag
                end

                -- Update the current line
                vim.api.nvim_set_current_line(line)

                -- Provide meaningful feedback based on the input
                if days == 0 then
                    print("Added today's date to task: " .. future_date)
                elseif days == 1 then
                    print("Added tomorrow's date to task: " .. future_date)
                else
                    print("Added date " .. days .. " days from now to task: " .. future_date)
                end
            end)
        end, { desc = "Set a due date for an obsidian task" })

        vim.api.nvim_create_user_command("ObsidianTaskPriority", function()
            -- Get the current line
            local line = vim.api.nvim_get_current_line()

            -- Check if the line is a task
            if not line:match("^%s*%-%s*%[%s*[%s%+xX]%s*%]") then
                print("Current line is not a task")
                return
            end

            -- Define priority levels and their corresponding emojis
            local priorities = {
                ["1"] = "🔽", -- Low
                ["2"] = "🔼", -- Medium (default)
                ["3"] = "⏫", -- High
                ["4"] = "🔺", -- Highest
            }

            -- Create the prompt message
            local prompt_message = "Select priority level:\n"
                .. "1 - Low (🔽)\n"
                .. "2 - Medium (🔼)\n"
                .. "3 - High (⏫)\n"
                .. "4 - Highest (🔺)\n"
                .. "Priority (1-4): "

            -- Prompt the user for priority level
            vim.ui.input({
                prompt = prompt_message,
                default = "2", -- Default to Medium
            }, function(priority_input)
                -- Early return if user cancels the prompt
                if not priority_input then
                    print("Priority setting cancelled")
                    return
                end

                -- Validate input and get the corresponding emoji
                local priority_emoji = priorities[priority_input]
                if not priority_emoji then
                    print("Invalid input: Please enter a number between 1 and 4")
                    return
                end

                -- Check if the task already has a priority emoji
                if line:match("[🔽🔼⏫🔺]") then
                    -- Replace the existing priority
                    line = line:gsub("([🔽🔼⏫🔺])", priority_emoji)
                else
                    -- Add priority after the task marker but before the task text
                    local prefix, rest = line:match("^(%s*%-%s*%[%s*[%s%+xX]%s*%])(.*)$")
                    if prefix and rest then
                        line = prefix .. " " .. priority_emoji .. rest
                    end
                end

                -- Update the current line
                vim.api.nvim_set_current_line(line)

                -- Provide feedback
                local priority_names = {
                    ["🔽"] = "Low",
                    ["🔼"] = "Medium",
                    ["⏫"] = "High",
                    ["🔺"] = "Highest",
                }
                print("Set task priority to " .. priority_names[priority_emoji] .. " (" .. priority_emoji .. ")")
            end)
        end, { desc = "set the priority on an obsidian task" })
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
