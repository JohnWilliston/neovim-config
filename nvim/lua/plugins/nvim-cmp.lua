return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        -- Autocompletion snippets plugin
        { "saadparwaiz1/cmp_luasnip" },
        -- Completion sources
        { "hrsh7th/cmp-nvim-lsp" }, -- neovim builtin LSP client
        { "hrsh7th/cmp-path" },     -- path
        { "hrsh7th/cmp-buffer" },   -- buffer words
        { "hrsh7th/cmp-nvim-lua" }, -- nvim lua
        { "hrsh7th/cmp-emoji" },    -- emoji
        { "hrsh7th/cmp-cmdline" },  -- vim's cmdline.
        { "hrsh7th/cmp-calc" },     -- doing simple calculations
        --"hrsh7th/cmp-omni",     -- Nvim's omnifunc

        -- The following is the original plugin, which had issues, followed by
        -- my new and original local copies for making it better. The final 
        -- plugin is my own fork of it until the author makes a proper fix.
        --"hrsh7th/cmp-nvim-lsp-document-symbol" -- improved searching through LSP data
        --{ dir = "~/src/cnlds-new" },
        --{ dir = "~/src/cnlds-original" },
        { "JohnWilliston/cmp-nvim-lsp-document-symbol" },
        -- { dir = "E:/Src/cmp-nvim-lsp-document-symbol" },
        { "chrisgrieser/cmp_yanky" },
    },
    opts = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        local kind_icons = {
            Text = "",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰇽",
            Variable = "󰂡",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "󰅲",
        }

        -- This is me fiddling around with alternate icons while working on some
        -- issues with my fork of the  cmp-nvim-lsp-document-symbol plugin.
        -- Glyph reference: https://raw.githubusercontent.com/archdroid20/nerd-fonts-complete/refs/heads/master/glyphnames.json
        local unused_but_new_kind_icons = {
            File = "󰈙",             -- 01 File
            Module = "",           -- 02 Module
            Unit = "",             -- 03 Namespace
            Folder = "󰉋",           -- 04 Package
            Class = "󰠱",            -- 05 Class
            Method = "󰆧",           -- 06 Method
            Property = "󰜢",         -- 07 Property
            Field = "󰇽",            -- 08 Field
            Constructor = "",      -- 09 Constructor
            Enum = "",             -- 10 Enum
            Interface = "",        -- 11 Interface
            Function = "󰊕",         -- 12 Function
            Variable = "󰂡",         -- 13 Variable
            Constant = "󰏿",         -- 14 Constant
            Text = "",             -- 15 String
            Value = "󰎠",            -- 16 Number
            -- Boolean?
            Boolean = "",          -- 17 Boolean
            -- Array?
            Array = "",            -- 18 Array
            -- Object?
            Object = "O",           -- 19 Object
            Keyword = "󰌋",          -- 20 Key
            -- Null?
            Null = "󰟢",             -- 21 Null
            EnumMember = "",       -- 22 Enum Member
            Struct = "",           -- 23 Struct
            Event = "",            -- 24 Event
            Operator = "󰆕",         -- 25 Operator
            TypeParameter = "󰅲",    -- 26 Type Parameter
        }

        local custom_menu_icon = {
            Calc = " 󰃬 ",
        }

        return {
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },

            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    -- Our little short circuit to provide a custom calculation icon.
                    -- Requires the cmp-calc plugin to be in place to provide as a source.
                    if entry.source.name == "calc" then
                        vim_item.kind = custom_menu_icon.Calc
                    else
                        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- Concatenates the icon with the name of the kind.
                    end
                    -- Source
                    vim_item.menu = ({
                        buffer = "[Buffer]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[LuaSnip]",
                        nvim_lua = "[Lua]",
                        latex_symbols = "[LaTeX]",
                        cmp_yanky = "[Yank]",
                    })[entry.source.name]
                    return vim_item
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                -- completion = {
                --     winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                --     col_offset = -3,
                --     side_padding = 0,
                -- },
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.confirm(),  -- Ctrl + Space doesn't seem to work at all.
                ["<C-e>"] = cmp.mapping({
                    i = cmp.mapping.abort(),
                    c = cmp.mapping.close(),
                }),
                ['<CR>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if luasnip.expandable() then
                            luasnip.expand()
                        else
                            cmp.confirm({
                                select = true,
                            })
                        end
                    else
                        fallback()
                    end
                end),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "luasnip" },
                { name = "path" },
                { name = "nvim_lua" },
                { name = "calc" },
                { name = "emoji" },
                { name = "omni" },
                { name = "nvim_lsp_document_symbol" },
                {
                    name = "cmp_yanky",
                    option = {
                        onlyCurrentFiletype = false,
                        minLength = 3,
                    },
                },
            })
        }
    end,
    config = function(_, opts)
        local cmp = require("cmp")
        cmp.setup(opts)

        -- This is my prior configuration before nvim_lsp_document_symbols.
        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        -- cmp.setup.cmdline({ "/", "?" }, {
        --     mapping = cmp.mapping.preset.cmdline(),
        --     sources = {
        --         { name = "buffer" },
        --     },
        -- })

        cmp.setup.cmdline({ "/", "?"}, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'nvim_lsp_document_symbol' }
            }, {
                { name = 'buffer' }
            })
        })

        -- `:` cmdline setup.
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' },
                {
                    name = 'cmdline',
                    option = {
                        ignore_cmds = { 'Man', '!' }
                    }
                }
            })
        })
    end,
}
