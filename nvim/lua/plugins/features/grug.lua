return {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
        { "<leader>eg", "<cmd>GrugFar<cr>", desc = "Search & replace (grug)" },
    },
    opts = {},
    -- This is an interesting bit of code. If I put the call to which-key in the
    -- config function, then it wouldn't map the key. But if I put it in the 
    -- init function, it works just fine. I think maybe the config function is
    -- lazy called only when the plugin is actually loaded?
    -- init = function ()
    --     require("which-key").add({
    --         { "<leader>sn", "<cmd>GrugFar<cr>", desc = "Search and replace", icon = "" },
    --     })
    -- end,
}
