---@module 'which-key'
---@type  wk.Config
local opts = {}

---@type lz.n.Spec
return {
	"which-key.nvim",
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
	event = "DeferredUIEnter",
	after = function()
		local wk = require("which-key")
		wk.setup(opts)
	end,
}
