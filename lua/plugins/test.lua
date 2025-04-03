---@type lz.n.Spec
return {
	"neotest",
	event = "BufEnter",
	after = function()
		require("lz.n").trigger_load("overseer.nvim")
		require("neotest").setup({
			consumers = {
				overseer = require("neotest.consumers.overseer"),
			},
		})
	end,
}
