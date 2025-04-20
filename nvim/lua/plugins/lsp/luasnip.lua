return {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    -- version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
    },
    -- NB: These keys are relevant ONLY during the expansion of a snippet.
    keys = {
        -- NB: The expand bind lets you expand snippets within snippets.
        -- But I'm not even sure what that means.
        -- { "<C-x>", function () require("luasnip").expand() end, desc = "Expand snippet", mode = { "i", "s" } },
        {
            "<C-p>",
            function()
                require("luasnip").jump(-1)
            end,
            desc = "Previous parameter",
            mode = { "i", "s" },
        },
        {
            "<C-n>",
            function()
                require("luasnip").jump(1)
            end,
            desc = "Next parameter",
            mode = { "i", "s" },
        },
        -- Relevant only when a snippet has a "choice node".
        {
            "<C-q>",
            function()
                local ls = require("luasnip")
                if ls.choice_active() then
                    ls.change_choice(-1)
                end
            end,
            desc = "Previous choice",
            mode = { "i", "s" },
        },
        -- <C-e> conflicts with default: insert character from below the cursor.
        {
            "<C-w>",
            function()
                local ls = require("luasnip")
                if ls.choice_active() then
                    ls.change_choice(1)
                end
            end,
            desc = "Next choice",
            mode = { "i", "s" },
        },
    },
    config = function()
        -- First, make sure we load the VSCode snippets.
        require("luasnip.loaders.from_vscode").lazy_load()

        -- The remainder of this code demonstrates how to build snippets in Lua
        -- using the building blocks provided by the plugin.
        local ls = require("luasnip")
        local l = require("luasnip.extras").lambda
        local c = ls.choice_node
        local i = ls.insert_node
        local f = ls.function_node
        local s = ls.snippet
        local t = ls.text_node

        -- args is a table, where 1 is the text in Placeholder 1, 2 the text in
        -- placeholder 2,...
        local function copy(args)
            return args[1]
        end

        local date = function()
            return { os.date("%Y-%m-%d") }
        end

        -- Sample snippets taken from the following helpful article:
        -- https://sbulav.github.io/vim/neovim-setting-up-luasnip/
        ls.add_snippets(nil, {
            all = {
                -- An example snippet that calls a function for a date.
                s({
                    trig = "my_custom_date",
                    name = "Date",
                    dscr = "Date in the form of YYYY-MM-DD",
                }, {
                    f(date, {}),
                }),
                -- An example snippet with cursor jump location parameters. Use the
                -- <Tab> and <S-Tab> keys to jump forward and backward.
                s({
                    trig = "meta",
                    name = "Metadata",
                    dscr = "Yaml metadata format for markdown",
                }, {
                    t({ "---", "title: " }),
                    i(1, "note_title"),
                    t({ "", "author: " }),
                    i(2, "author"),
                    t({ "", "date: " }),
                    f(date, {}),
                    t({ "", "categories: " }),
                    i(3, "categories"),
                    t({ "", "lastmod: " }),
                    f(date, {}),
                    t({ "", "tags: " }),
                    i(4, "tag"),
                    t({ "", "comments: true", "---", "" }),
                    i(0),
                }),
                -- An example choice node.
                s(
                    "trig",
                    c(1, {
                        t("Ugh boring, a text node"),
                        i(nil, "At least I can edit something now..."),
                        f(function(args)
                            return "Still only counts as text!!"
                        end, {}),
                    })
                ),
            },
        })

        ls.add_snippets("all", {
            -- trigger is `fn`, second argument to snippet-constructor are the nodes to insert into the buffer on expansion.
            s("fn", {
                -- Simple static text.
                t("//Parameters: "),
                -- function, first parameter is the function, second the Placeholders
                -- whose text it gets as input.
                f(copy, 2),
                t({ "", "function " }),
                -- Placeholder/Insert.
                i(1),
                t("("),
                -- Placeholder with initial text.
                i(2, "int foo"),
                -- Linebreak
                t({ ") {", "\t" }),
                -- Last Placeholder, exit Point of the snippet.
                i(0),
                t({ "", "}" }),
            }),

            s("transform", {
                i(1, "initial text"),
                t({ "", "" }),
                -- lambda nodes accept an l._1,2,3,4,5, which in turn accept any string transformations.
                -- This list will be applied in order to the first node given in the second argument.
                l(l._1:match("[^i]*$"):gsub("i", "o"):gsub(" ", "_"):upper(), 1),
            }),
        }, {
            key = "all",
        })
    end,
}
