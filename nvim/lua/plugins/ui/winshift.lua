return {
	"sindrets/winshift.nvim",
    cmd = "WinShift",
    keys = {
        { "<leader>wsh", "<cmd>WinShift left<cr>", desc = "Window shift left", mode = "n" },
        { "<leader>wsl", "<cmd>WinShift right<cr>", desc = "Window shift right", mode = "n" },
        { "<leader>wsj", "<cmd>WinShift down<cr>", desc = "Window shift down", mode = "n" },
        { "<leader>wsk", "<cmd>WinShift up<cr>", desc = "Window shift up", mode = "n" },
        { "<leader>wsfh", "<cmd>WinShift far_left<cr>", desc = "Window shift far left", mode = "n" },
        { "<leader>wsfl", "<cmd>WinShift far_right<cr>", desc = "Window shift far right", mode = "n" },
        { "<leader>wsfj", "<cmd>WinShift far_down<cr>", desc = "Window shift far down", mode = "n" },
        { "<leader>wsfk", "<cmd>WinShift far_up<cr>", desc = "Window shift far up", mode = "n" },
    },
}
