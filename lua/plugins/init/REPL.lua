vim.g["conjure#mapping#doc_word"] = "gk" -- don't have conjure overwrite doc hover
require("conjure.main").main()
require("conjure.mapping")["on-filetype"]()

-- colorize conjure
vim.g.conjure_baleia = require("baleia").setup({ line_starts_at = 3 })

local augroup = vim.api.nvim_create_augroup("ConjureBaleia", { clear = true })

vim.api.nvim_create_user_command("BaleiaColorize", function()
	vim.g.conjure_baleia.once(vim.api.nvim_get_current_buf())
end, { bang = true })

vim.api.nvim_create_user_command("BaleiaLogs", vim.g.conjure_baleia.logger.show, { bang = true })

-- Print color codes if baleia.nvim is available
local colorize = 1 -- FIXME: detect that baleia is loaded
vim.g["conjure#log#strip_ansi_escape_sequences_line_limit"] = colorize and 1 or nil

-- Disable diagnostics in log buffer and colorize it
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	pattern = "conjure-log-*",
	callback = function()
		local buffer = vim.api.nvim_get_current_buf()
		vim.diagnostic.enable(false, { bufnr = buffer })
		if colorize and vim.g.conjure_baleia then
			vim.g.conjure_baleia.automatically(buffer)
		end
	end,
})

return {} --TODO: Lazy Load
