return {
    "jake-stewart/multicursor.nvim",
    config = function()
        local mc = require("multicursor-nvim")
        mc.setup()

        local set = vim.keymap.set

        -- Add or skip cursor above/below the main cursor.
        set({"n", "x"}, "<up>", function() mc.lineAddCursor(-1) end, { desc = "Add cursor up" })
        set({"n", "x"}, "<down>", function() mc.lineAddCursor(1) end, { desc = "Add cursor down" })
        set({"n", "x"}, "<leader><up>", function() mc.lineSkipCursor(-1) end, { desc = "Add cursor up" })
        set({"n", "x"}, "<leader><down>", function() mc.lineSkipCursor(1) end, { desc = "Add cursor down" })

        -- Add or skip adding a new cursor by matching word/selection
        set({"n", "x"}, "<leader>ec<down>", function() mc.matchAddCursor(1) end, { desc = "Add cursor match down" })
        set({"n", "x"}, "<leader>es<down>", function() mc.matchSkipCursor(1) end, { desc = "Skip cursor match down" })
        set({"n", "x"}, "<leader>ec<up>", function() mc.matchAddCursor(-1) end, { desc = "Add cursor match up" })
        set({"n", "x"}, "<leader>es<up>", function() mc.matchSkipCursor(-1) end, { desc = "Skip cursor match up" })

        -- Add and remove cursors with control + left click.
        -- set("n", "<c-leftmouse>", mc.handleMouse)
        -- set("n", "<c-leftdrag>", mc.handleMouseDrag)
        -- set("n", "<c-leftrelease>", mc.handleMouseRelease)

        -- Disable and enable cursors.
        set({"n", "x"}, "<c-q>", mc.toggleCursor, { desc = "Toggle multi-cursors" })

        -- Mappings defined in a keymap layer only apply when there are
        -- multiple cursors. This lets you have overlapping mappings.
        mc.addKeymapLayer(function(layerSet)

            -- Select a different cursor as the main one.
            layerSet({"n", "x"}, "<left>", mc.prevCursor, { desc = "Previous multicursor" } )
            layerSet({"n", "x"}, "<right>", mc.nextCursor, { desc = "Next multicursor" } )

            -- Delete the main cursor.
            layerSet({"n", "x"}, "<leader>x", mc.deleteCursor, { desc = "Delete main multicursor" })

            -- Enable and clear cursors using escape.
            layerSet("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                else
                    mc.clearCursors()
                end
            end)
        end)

        -- Customize how cursors look.
        local hl = vim.api.nvim_set_hl
        hl(0, "MultiCursorCursor", { reverse = true })
        hl(0, "MultiCursorVisual", { link = "Visual" })
        hl(0, "MultiCursorSign", { link = "SignColumn"})
        hl(0, "MultiCursorMatchPreview", { link = "Search" })
        hl(0, "MultiCursorDisabledCursor", { reverse = true })
        hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
        hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
    end,
}
