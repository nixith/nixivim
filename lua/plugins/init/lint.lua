local lint = require("lint")
lint.linters_by_ft = {
	--  markdown = {'vale'},
	lua = { "selene" },
	nix = { "nix" },
	python = { "ruff" },
	c = { "clangtify" },
}

lint.linters.cspell = require("lint.util").wrap(lint.linters.cspell, function(diagnostic)
	diagnostic.severity = vim.diagnostic.severity.HINT
	return diagnostic
end)

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		-- try_lint without arguments runs the linters defined in `linters_by_ft`
		-- for the current filetype
		lint.try_lint()

		-- You can call `try_lint` with a linter name or a list of names to always
		-- run specific linters, independent of the `linters_by_ft` configuration
		--lint.try_lint("cspell")
	end,
})

return {}
