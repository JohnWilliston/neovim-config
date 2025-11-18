return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

        -- Builtin list here for future reference:
        -- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
		null_ls.setup({
			sources = {
				-- Actions
                -- I disabled this because it was generating a blame option
                -- for every single line in every single file.
				-- null_ls.builtins.code_actions.gitsigns,
				null_ls.builtins.code_actions.refactoring,

				-- Doesn't seem to exist or can't install or something.
				-- null_ls.builtins.code_actions.ts_node_action,

				-- Completion
				null_ls.builtins.completion.luasnip,    -- Duplication?
				null_ls.builtins.completion.spell,
				-- null_ls.builtins.completion.tags,    -- Won't use enough

				-- Diagnostics
				null_ls.builtins.diagnostics.actionlint, -- Too noisy
				--null_ls.builtins.diagnostics.ansiblelint,
				-- null_ls.builtins.diagnostics.clazy,      -- Can't run
				null_ls.builtins.diagnostics.cmake_lint,
				-- null_ls.builtins.diagnostics.cppcheck,   -- Can't run
				null_ls.builtins.diagnostics.dotenv_linter,
				null_ls.builtins.diagnostics.markdownlint,
				-- null_ls.builtins.diagnostics.npm_groovy_lint,
				null_ls.builtins.diagnostics.pylint,     -- Too noisy
				--null_ls.builtins.diagnostics.selene,     -- Too noisy
				-- null_ls.builtins.diagnostics.spectral,   -- Can't run
				-- null_ls.builtins.diagnostics.sqlfluff.with({
				-- 	extra_args = { "--dialect", "postgres" },
				-- }),
				-- null_ls.builtins.diagnostics.stylelint,
				null_ls.builtins.diagnostics.terraform_validate,
				null_ls.builtins.diagnostics.tfsec,
				-- null_ls.builtins.diagnostics.yamllint,   -- Too noisy
				null_ls.builtins.diagnostics.zsh,
				-- null_ls.builtins.code_actions.textlint,

				-- Formatting
				-- null_ls.builtins.formatting.asmfmt,
				-- null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.formatting.cmake_format,
				null_ls.builtins.formatting.codespell,
				null_ls.builtins.formatting.csharpier,
				-- null_ls.builtins.formatting.gersemi,
				null_ls.builtins.formatting.htmlbeautifier,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.formatting.mdformat,
				-- null_ls.builtins.formatting.npm_groovy_lint,
				-- null_ls.builtins.formatting.prettier,
				-- null_ls.builtins.formatting.pyink,
				-- null_ls.builtins.formatting.remark, -- Maybe duplicates mdformat?
				null_ls.builtins.formatting.shellharden,
				-- null_ls.builtins.formatting.shfmt, -- Maybe duplicates shellharden?
				-- null_ls.builtins.formatting.sqlfluff.with({
				-- 	extra_args = { "--dialect", "postgres" }, -- change to your dialect
				-- }),
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.terraform_fmt,
				null_ls.builtins.formatting.xmllint,
				null_ls.builtins.formatting.yamlfix,
				null_ls.builtins.formatting.yamlfmt,

                -- Hover
                null_ls.builtins.hover.dictionary,
                null_ls.builtins.hover.printenv,
			},
		})
	end,
}
