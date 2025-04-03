local M = {}

--TODO: Doc Comment
M.setup = function(ft, formatter, linter, lsp)
	--TODO: check if this should actually be a different autocmd per buffer, not sure of the implications
	require("lint").linters_by_ft[ft] = { linter }

	require("conform").formatters_by_ft[ft] = { formatter }

	vim.lsp.enable({ lsp })
end

return M
