require("lint").linters_by_ft =
	{ --TODO: check if this should actually be a different autocmd per buffer, not sure of the implications
		c = { "clang-tidy" },
	}

vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.smartindent = true
