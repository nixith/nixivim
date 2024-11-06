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

require("marks").setup()

--markdown render
require("render-markdown").setup()

--todo comonets
require("todo-comments").setup()

local snacks = require("snacks")
snacks.setup({
	bigfile = { enabled = true },
	notifier = {
		enabled = true,
		timeout = 3000,
	},
	quickfile = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	-- styles = {
	-- 	notification = {
	-- 		wo = { wrap = true }, -- Wrap notifications
	-- 	},
	-- },
})
vim.keymap.set({ "n", "t" }, "<C-/>", function()
	snacks.terminal.toggle()
end, { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>gg", function()
	snacks.lazygit.open()
end, { desc = "Toggle lazygit" })

snacks.statuscolumn.setup()

vim.keymap.set("n", "<leader>gb", function()
	snacks.git.blame_line()
end, { desc = "run git blame on the current line" })
vim.keymap.set("n", "<leader>gB", function()
	snacks.gitbrowse()
end, { desc = "Git Browse" })

return {} -- TODO: Lazyload? I feel like I almost always want this, maybe when I have multiple buffers
