
-- I have Ollama installed locally on the MacBook Pro, so I switch the url.
local ollamaUrl = "http://ancalagon:11434"
local ollamaModel = "granite3.1-dense"

if (vim.loop.os_uname().sysname == "Darwin") then
    ollamaUrl = "http://localhost:11434"
end

return {
    "nomnivore/ollama.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    -- All the user commands added by the plugin
    cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

    keys = {
        -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
        {
            "<leader>oo",
            ":<c-u>lua require('ollama').prompt()<cr>",
            desc = "Ollama Prompt",
            mode = { "n", "v" },
        },

        -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
        {
            "<leader>oG",
            ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
            desc = "Ollama Generate Code",
            mode = { "n", "v" },
        },
    },

    opts = {
        model = ollamaModel,
        url = ollamaUrl,
        serve = {
            on_start = false,
            command = "ollama",
            args = { "serve" },
            stop_command = "pkill",
            stop_args = { "-SIGTERM", "ollama" },
        },
        -- View the actual default prompts in ./lua/ollama/prompts.lua
        prompts = {
            Sample_Prompt = {
                prompt = "This is a sample prompt that receives $input and $sel(ection), among others.",
                input_label = "> ",
                model = "llama3.2",
                action = "display",
            }
        }
    }
}
