local scheme = require("nixCats").cats.colorScheme

require("mini.base16").setup({
	palette = scheme,
	use_cterm = true,
})
--vim.print(({ 	palette = scheme, use_cterm = true }).palette)
