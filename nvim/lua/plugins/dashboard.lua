return {
    "nvimdev/dashboard-nvim",
    enabled = true,
    event = "VimEnter",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    --enabled = false,
    init = function()
        vim.cmd([[hi DashboardHeader guifg=#ee872d gui=bold]])
        vim.cmd([[hi DashboardProjectTitle guifg=#d55fde gui=bold]])
        vim.cmd([[hi DashboardProjectIcon guifg=#89ca78]])
        vim.cmd([[hi DashboardMruTitle guifg=#d55fde gui=bold]])
        vim.cmd([[hi DashboardShortCut guifg=#89ca78 gui=bold]])
    end,
    opts = {
        theme = "hyper",
        config = {
            -- header = {
            --     [[]],
            --     [[███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
            --     [[████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
            --     [[██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
            --     [[██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
            --     [[██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
            --     [[╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
            --     [[]],
            -- },
            header = {
[[]],
[[                 ,.ood888888888888boo.,                     ]],
[[              .od888P^""            ""^Y888bo.              ]],
[[          .od8P''   ..oood88888888booo.    ``Y8bo.          ]],
[[       .odP'"  .ood8888888888888888888888boo.  "`Ybo.       ]],
[[     .d8'   od8'd888888888f`8888't888888888b`8bo   `Yb.     ]],
[[    d8'  od8^   8888888888[  `'  ]8888888888   ^8bo  `8b    ]],
[[  .8P  d88'     8888888888P      Y8888888888     `88b  Y8.  ]],
[[ d8' .d8'       `Y88888888'      `88888888P'       `8b. `8b ]],
[[.8P .88P            """"            """"            Y88. Y8.]],
[[88  888                                              888  88]],
[[88  888                                              888  88]],
[[88  888.        ..                        ..        .888  88]],
[[`8b `88b,     d8888b.od8bo.      .od8bo.d8888b     ,d88' d8']],
[[ Y8. `Y88.    8888888888888b    d8888888888888    .88P' .8P ]],
[[  `8b  Y88b.  `88888888888888  88888888888888'  .d88P  d8'  ]],
[[    Y8.  ^Y88bod8888888888888..8888888888888bod88P^  .8P    ]],
[[     `Y8.   ^Y888888888888888LS888888888888888P^   .8P'     ]],
[[       `^Yb.,  `^^Y8888888888888888888888P^^'  ,.dP^'       ]],
[[          `^Y8b..   ``^^^Y88888888P^^^'    ..d8P^'          ]],
[[              `^Y888bo.,            ,.od888P^'              ]],
[[                   "`^^Y888888888888P^^'"                   ]],
[[]],
            },
--             header = {
-- [[]],
-- [[       _       _            __          ___ _ _ _     _              ]],
-- [[      | |     | |           \ \        / (_) | (_)   | |             ]],
-- [[      | | ___ | |__  _ __    \ \  /\  / / _| | |_ ___| |_ ___  _ __  ]], 
-- [[  _   | |/ _ \| '_ \| '_ \    \ \/  \/ / | | | | / __| __/ _ \| '_ \ ]], 
-- [[ | |__| | (_) | | | | | | |    \  /\  /  | | | | \__ \ || (_) | | | |]],
-- [[  \____/ \___/|_| |_|_| |_|     \/  \/   |_|_|_|_|___/\__\___/|_| |_|]],
-- [[]],
--             },
            shortcut = {
                {
                    icon = " ", --
                    desc = " Files",
                    group = "Label",
                    key = "f",
                    action = "Telescope find_files",
                },
                {
                    desc = "  Find text",
                    group = "@property",
                    key = "g",
                    action = "Telescope live_grep ",
                },
                {
                    desc = "  New file",
                    group = "Macro",
                    key = "n",
                    action = "enew",
                },
                {
                    desc = "  Config",
                    group = "DiagnosticHint",
                    key = "c",
                    action = "e $MYVIMRC ",
                },
                {
                    desc = "  Quit",
                    group = "Number",
                    key = "q",
                    action = "qa",
                },
                -- {
                --     desc = " Recent files",
                --     group = "",
                --     key = "r",
                --     action = "Telescope oldfiles ",
                -- },
                -- {
                --     desc = "󰊳 Update",
                --     group = "@property",
                --     key = "u",
                --     action = "Lazy update",
                -- },
                -- {
                --     icon="",
                --     icon_hl = "@variable",
                --     desc = "Apps",
                --     group = "DiagnosticHint",
                --     key = "a",
                --     action = "Telescope app",
                -- },
                -- {
                --     desc = " dotfiles",
                --     group = "Number",
                --     key = "d",
                --     action = "Telescope dotfiles",
                -- },
            },
            project = { enable = true, limit = 4 },
            mru = { enable = true, limit = 6 },
        },
        hide = {
            statusline = true, -- hide statusline default is true
            tabline = false, -- hide the tabline
            winbar = true, -- hide winbar
        },
    },
}
