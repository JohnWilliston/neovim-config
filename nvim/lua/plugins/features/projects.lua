return {
    -- Manages workspaces tied to working directories. Provides a telescope
    -- powered selection tool to choose and switch.
    {
        "natecraddock/workspaces.nvim",
        cmd = {
            "WorkspacesAdd",
            "WorkspacesAddDir",
            "WorkspacesRemove",
            "WorkspacesRemoveDir",
            "WorkspacesRename",
            "WorkspacesList",
            "WorkspacesListDirs",
            "WorkspacesSyncDirs",
        },
        keys = {
            { "<leader>pa",  "<cmd>WorkspacesAddDir<CR>",    desc = "Project add dir" },
            { "<leader>pd",  "<cmd>WorkspacesRemoveDir<CR>", desc = "Project delete dir" },
            { "<leader>pln", "<cmd>WorkspacesList<CR>",      desc = "Project list names" },
            { "<leader>pld", "<cmd>WorkspacesListDirs<CR>",  desc = "Project list dirs" },
            { "<leader>po",  "<cmd>WorkspacesOpen<CR>",      desc = "Project open" },
            { "<leader>ps",  "<cmd>SessionSave<CR>",         desc = "Project save session" },
        },
        opts = {
            hooks = {
                open = { "SessionRestore" }, -- Calls the auto-session plugin.
            },
        },
    },
    -- Manages open windows, layout, files, etc. saved to standard session
    -- files. Invoked automatically when switching workspace.
    {
        "rmagatti/auto-session",
        lazy = false,
        enabled = true,

        ---enables autocomplete for opts
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            auto_restore = false,
            auto_save = false,
            suppressed_dirs = { "~/", "~/Dropbox", "~/Downloads", "/" },
            -- log_level = 'debug',

            -- Ties scope plugin into the process. I didn't find it worked
            -- reliably, however, so I'm not sure it's worth it. Still, using
            -- code here worked better than the auto-session configuration I
            -- tried in the scope plugin spec. Go figure.
            pre_save_cmds = {
                "ScopeSaveState",
            },
            post_restore_cmds = {
                "ScopeLoadState",
            },
        },
    },
}
