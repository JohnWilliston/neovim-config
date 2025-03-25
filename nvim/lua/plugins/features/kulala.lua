return {
    "mistweaverco/kulala.nvim",
    -- Hanging Kulala key bindings off the "Tools" menu.
    keys = {
        { "<leader>tkp", function () require("kulala").jump_prev() end, desc = "Kulala jump previous" },
        { "<leader>tkn", function () require("kulala").jump_next() end, desc = "Kulala jump next" },
        { "<leader>tkr", function () require("kulala").run() end, desc = "Kulala run" },
        { "<leader>tkR", function () require("kulala").run_all() end, desc = "Kulala run all" },
        { "<leader>tk.", function () require("kulala").replay() end, desc = "Kulala replay" },
        { "<leader>tko", function () require("kulala").open() end, desc = "Kulala open" },
        -- Not sure what this searches for as it's always empty.
        -- { "<leader>ks", function () require("kulala").search() end, desc = "Kulala search" },

        { "<leader>tkt", function () require("kulala").toggle_view() end, desc = "Kulala toggle view" },
        { "<leader>tkb", function () require("kulala.ui").show_body() end, desc = "Kulala view body" },
        { "<leader>tkh", function () require("kulala.ui").show_headers() end, desc = "Kulala view headers" },
        { "<leader>tkm", function () require("kulala.ui").show_stats() end, desc = "Kulala view stats" },
        { "<leader>tkv", function () require("kulala.ui").show_verbose() end, desc = "Kulala view verbose" },
    },
    opts = {
        default_view = "verbose",
        winbar = true,
    },
}

