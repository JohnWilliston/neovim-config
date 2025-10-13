-- This lets me scope buffers to tabs, though it's a bit of a manual process.
-- In particular, you have to have a tab already and then execute a function
-- (ScopeMoveBuf tabnr) to move the current buffer to the given tab number.
-- But once it's there, the usual buffer selection in telescope is limited
-- only to buffers in that tab, which is really nice. And if you need to pick
-- from the whole list, then you can use: :Telescope scope buffers
return {
    "tiagovla/scope.nvim",
    -- NB: lazy needs to be set to false when defining keys like this.
    lazy = false,
    keys = {
        {
            "<leader>bt",
            function()
                local tabnr = vim.fn.input("Assign current buffer to tab: ")
                vim.cmd("ScopeMoveBuf " .. tabnr)
            end,
            desc = "Assign buffer to tab",
        },
    },
    config = function()
        require("scope").setup()
        require("telescope").load_extension("scope")
    end,
}
