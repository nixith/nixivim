local M = {}

--TODO: Doc Comment
M.setup = function(ft, formatter, linter, lsp)
	--TODO: check if this should actually be a different autocmd per buffer, not sure of the implications
	if linter ~= nil then
		require("lint").linters_by_ft[ft] = { linter }
	end

	if formatter ~= nil then
		require("conform").formatters_by_ft[ft] = { formatter }
	end

	if lsp ~= nil then
		vim.lsp.enable({ lsp })
	end
end

return M
