vim.opt.termguicolors = true

local bufferline_opts = {
	indicator = {
		style = "underline",
	},
	coloricons = true,
	diagnotics = "nvim_lsp",

	diagnostics_indicator = function(count, level, diagnostics_dict, context)
		local s = " "
		for e, n in pairs(diagnostics_dict) do
			local sym = e == "error" and " " or (e == "warning" and " " or " ")
			s = s .. n .. sym
		end
		return s
	end,
}

require("bufferline").setup({ options = bufferline_opts })

-- keybinds

local bufferline = require("bufferline")

vim.keymap.set("n", "<S-L>", "<cmd>BufferLineCycleNext<cr>")
vim.keymap.set("n", "<S-h>", function()
	bufferline.cycle(-1)
end)

local line = require("lualine") --TODO: Config
line.setup({})

-- notifications
vim.notify = require("notify")
require("telescope").load_extension("notify")
require("fidget").setup({})

-- trouble
local trouble = require("trouble")
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>xX",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ desc = "Buffer Diagnostics (Trouble)" }
)
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>cl",
	"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	{ desc = "LSP Definitions / references / ... (Trouble)" }
)
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

trouble.setup() --TODO: filter out conjure

--gitsigns
require("gitsigns").setup()
require("marks").setup()

--markdown render
require("render-markdown").setup()

--todo comonets
require("todo-comments").setup()

return {} -- TODO: Lazyload? I feel like I almost always want this, maybe when I have multiple buffers
