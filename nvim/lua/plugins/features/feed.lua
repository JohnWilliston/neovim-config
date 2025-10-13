return {
    "neo451/feed.nvim",
    cmd = "Feed",
    ---@module 'feed'
    ---@type feed.config
    opts = {
        feeds = {
            news = {
                gaming = {
                    { "https://www.bluesnews.com/news/news_1_0.rdf", name = "Blues News" },
                },
                politics = {
                    { "https://drudgereportfeed.com/rss",     name = "Drudge Report" },
                    { "https://www.nationalreview.com/feed/", name = "National Review" },
                    { "https://reason.com/feed",              name = "Reason" },
                    { "https://thedispatch.com/feed",         name = "The Dispatch" },
                },
            },
        },
        ui = {
            tags = {
                color = "String",
                format = function(id, db)
                    local icons = {
                        news = "📰",
                        tech = "💻",
                        movies = "🎬",
                        games = "🎮",
                        music = "🎵",
                        podcast = "🎧",
                        books = "📚",
                        unread = "🆕",
                        read = "✅",
                        junk = "🚮",
                        star = "⭐",
                    }

                    local get_icon = function(name)
                        if icons[name] then
                            return icons[name]
                        end
                        local has_mini, MiniIcons = pcall(require, "mini.icons")
                        if has_mini then
                            local icon = MiniIcons.get("filetype", name)
                            if icon then
                                return icon .. " "
                            end
                        end
                        return name
                    end

                    local tags = vim.tbl_map(get_icon, db:get_tags(id))
                    table.sort(tags)
                    return "[" .. table.concat(tags, ", ") .. "]"
                end,
            },
        },
    },
}
