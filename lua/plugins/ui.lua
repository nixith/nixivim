local lz = require("lz.n")

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
	{
		"lualine.nvim",
		event = "DeferredUIEnter",
		after = function()
			lz.trigger_load("overseer.nvim")
			require("lualine").setup({
				-- tabline = {
				-- 	lualine_a = { "buffers" },
				-- 	lualine_b = { "branch" },
				-- 	lualine_c = { "filename" },
				-- 	lualine_x = {},
				-- 	lualine_y = {},
				-- 	lualine_z = { "tabs" },
				-- },
				-- winbar = {},
				-- inactive_winbar = {},
				sections = {
					lualine_x = { "overseer" },
				},
			})
		end,
	},
	{
		"todo-comments.nvim",
		event = "BufEnter",
		after = function()
			require("todo-comments").setup({})
		end,
	},
}
