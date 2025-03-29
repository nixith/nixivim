---@type lz.n.Spec
return {
	{
		"gitsigns.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("gitsigns").setup()
		end,
	},
	{
		"markview.nvim",
		lazy = false, -- list lazy loaded
		after = function()
			require("markview").setup({
				preview = {
					icon_provider = "mini", -- "mini" or "devicons"
				},
			})
		end,
	},
}
