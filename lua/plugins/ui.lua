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
				typst = {
					code_blocks = { enable = false },
					code_spans = { enable = false },
					math_blocks = { enable = false },
					math_spans = { enable = false },
				},
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
	{
		"trouble.nvim",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
			{
				"<leader>ci",
				"<cmd>Trouble lsp toggle<cr>",
				desc = "LSP Information (Trouble)",
			},
		},
		cmd = "Trouble",
		after = function()
			require("trouble").setup()
		end,
	},
}
