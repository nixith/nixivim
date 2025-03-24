local scheme = require("nixCats").cats.colorScheme

return {
	"mini.nvim",
	colorscheme = "mini16",
	after = function()
		require("mini.base16").setup({
			palette = scheme,
			use_cterm = true,
		})
	end,
}
