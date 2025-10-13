-- Use via the :DB command. The format to execute a SQL query is:
-- :DB postgresql://[user]:[password]@host:port/database [sql-query]

return {
    -- Might as well hook up the dadbod UI and have a nice TUI for it.
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
        { "tpope/vim-dadbod",                     lazy = true },
        { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
    },
    cmd = {
        "DB",
        "DBUI",
        "DBUIToggle",
        "DBUIAddConnection",
        "DBUIFindBuffer",
    },
    keys = {

        { "<leader>td", "<cmd>DBUI<CR>", desc = "Database UI" },
    },
    init = function()
        -- Your DBUI configuration
        vim.g.db_ui_use_nerd_fonts = 1
    end,
}
