return {
	{ -- Add indentation guides even on blank lines
		"indent-blankline",
		-- NOTE: nixCats: return true only if category is enabled, else false
		enabled = nixCats("editor"),
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		after = function()
			require("ibl").setup()
		end,
	},
}
