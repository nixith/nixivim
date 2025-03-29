local scheme = require("nixCats").cats.colorScheme

---@type lz.n.Spec
return {
	"mini.nvim",
	event = "DeferredUIEnter",
	colorscheme = "mini16",
	after = function()
		-- editing
		require("mini.basics").setup() -- NOTE: might not want
		require("mini.bracketed").setup()
		require("mini.ai").setup()
		require("mini.pairs").setup()
		require("mini.surround").setup()

		-- appearance
		require("mini.icons").setup()
		-- require("mini.base16").setup({
		-- 	palette = scheme,
		-- 	use_cterm = true,
		-- })

		require("mini.extra").setup() -- extras for hipatterns and ai
	end,
}
