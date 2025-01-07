return {
    "rmagatti/auto-session",
    lazy = false,
    enabled = true,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        auto_restore = false,
        auto_save = false,
        suppressed_dirs = { '~/', '~/Dropbox', '~/Downloads', '/' },
        -- log_level = 'debug',
    }
}
