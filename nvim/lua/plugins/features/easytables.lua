-- A few things worth noting:
--  1. You use one of those two commands to create a new table or edit one.
--  2. You have to save your changes with the `ExportTable` command.
--  3. There are a number of other commands to insert rows and such.
-- It's a nice plugin, but I wish it provided better/more keymaps.
return {
	"Myzel394/easytables.nvim",
	cmd = { "EasyTablesCreateNew", "EasyTablesImportThisTable" },
	ft = "markdown",
	lazy = true,
	config = true,
}
