return {
	"conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	after = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
			},
			format_on_save = {
				timeout_ms = 500,
				--async = true,
				lsp_format = "fallback",
			},
		})
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
