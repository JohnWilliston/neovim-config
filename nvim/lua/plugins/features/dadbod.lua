-- Use via the :DB command. The format to execute a SQL query is:
-- :DB postgresql://[user]:[password]@host:port/database [sql-query]
-- For example, the following pulls all the airfield data from Artiv:
-- :DB postgresql://postgres:[password]@rivendell:25432/Artiv_1.0 SELECT * FROM artiv.airfield;

return {
	"tpope/vim-dadbod",
}
