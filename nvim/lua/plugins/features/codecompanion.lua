-- I have Ollama installed locally on my MacBook Pro, so I switch the url.
local ollamaUrl = "http://ancalagon:11434"
local ollamaModel = "granite3.1-dense"
--local ollamaModel = "deepseek-coder-v2-fixed"

if vim.loop.os_uname().sysname == "Darwin" then
    ollamaUrl = "http://localhost:11434"
    --ollamaModel = "deepseek-coder-v2"
end

return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    keys = {
        --{ "<C-a>", "<cmd>CodeCompanionActions<CR>", desc = "AI actions", mode = { "n", "v" } },
        { "<leader>aia", "<cmd>CodeCompanionActions<CR>", desc = "AI actions", mode = { "n", "v" } },
        { "<leader>aic", "<cmd>CodeCompanionChat<CR>",    desc = "AI actions", mode = { "n", "v" } },
    },
    cmd = {
        "CodeCompanion",
        "CodeCompanionChat",
        "CodeCompanionActions",
    },
    init = function()
        -- Define 'cc' as a command-line abbreviation for 'CodeCompanion'.
        vim.cmd([[cab cc CodeCompanion]])
    end,
    opts = {
        -- This option is unfortunately global, but it's the only way I could
        -- get the boilerplate example prompt to generate without switching
        -- Neovim into diff mode.
        display = {
            diff = {
                enabled = false,
            },
        },
        adapters = {
            ollama = function()
                return require("codecompanion.adapters").extend("ollama", {
                    env = {
                        url = ollamaUrl,
                        --api_key = "OLLAMA_API_KEY",
                    },
                    headers = {
                        ["Content-Type"] = "application/json",
                        --["Authorization"] = "Bearer ${api_key}",
                    },
                    parameters = {
                        sync = true,
                    },
                    schema = {
                        model = {
                            default = ollamaModel,
                        },
                    },
                })
            end,
        },
        strategies = {
            chat = {
                adapter = "ollama",
            },
            inline = {
                adapter = "ollama",
            },
        },
        -- TODO: Add some more (and better) examples of use.
        prompt_library = {
            ["Boilerplate HTML"] = {
                strategy = "inline",
                description = "Generate some boilerplate HTML",
                opts = {
                    pre_hook = function()
                        local bufnr = vim.api.nvim_create_buf(true, false)
                        vim.print(bufnr)
                        -- Deprecated
                        --vim.api.nvim_buf_set_option(bufnr, "filetype", "html")
                        vim.api.nvim_set_current_buf(bufnr)
                        -- I think you can technically just pass  an empty table, but not sure.
                        local buf = vim.api.nvim_get_current_buf()
                        vim.api.nvim_set_option_value("filetype", "html", { buf = buf })
                        return bufnr
                    end,
                    placement = "add", -- Without this, it always creates a new buffer.
                },
                prompts = {
                    {
                        role = "system",
                        content =
                        "You are an expert HTML programmer. Output only plain text format. Do not include any markdown. Do not include any explanation. Just produce raw HTML 5 code.",
                    },
                    {
                        role = "user",
                        content = "Please generate some HTML boilerplate for me. Output only plain text format.",
                    },
                },
            },
            -- Not sure why this always duplicates the selected code in the resulting chat buffer.
            ["Question Selection"] = {
                strategy = "chat",
                description = "Ask a question about the current selection",
                opts = {
                    --mapping = "<LocalLeader>ce",
                    mapping = "<leader>bx",
                    modes = { "v" },
                    short_name = "expert",
                    auto_submit = true,
                    stop_context_insertion = true,
                    user_prompt = true,
                },
                prompts = {
                    {
                        role = "system",
                        content = function(context)
                            return "I want you to act as a senior "
                                .. context.filetype
                                .. " developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples."
                        end,
                    },
                    {
                        role = "user",
                        content = function(context)
                            local text =
                                require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                            local query = "I have the following code:\n\n```"
                                .. context.filetype
                                .. "\n"
                                .. text
                                .. "\n```\n\n"
                            --vim.print(query)
                            return query
                        end,
                        opts = {
                            contains_code = true,
                        },
                    },
                },
            },
        },
    },
}
