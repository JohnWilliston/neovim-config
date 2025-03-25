-- Seems like it limits buffers to tabs more reliably than the scope plugin,
-- but it causes all but the active buffer in each tab to be dropped when
-- restoring a session. Not a price worth paying.
return {
    "backdround/tabscope.nvim",
    config = true,
}
