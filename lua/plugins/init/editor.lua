-- auto pairs
local npairs = require("nvim-autopairs")
--local Rule = require("nvim-autopairs.rule")
npairs.setup({
	check_ts = true,
	ts_config = {},
})

-- auto tag pairs
local tag = require("nvim-ts-autotag")
tag.setup()

-- super edit
local grug = require("grug-far")
grug.setup()

--ripgrep substitute
local rip_sub = require("rip-substitute")
rip_sub.setup()

vim.keymap.set({ "n", "x" }, "<leader>fs", function()
	rip_sub.sub()
end, { desc = " rip substitute" })

--flush
local flash = require("flash")
flash.toggle(true)
vim.keymap.set({ "n", "x", "o" }, "s", function()
	flash.jump()
end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function()
	flash.treesitter()
end, { desc = "Flash Treesitter" })
vim.keymap.set({ "n", "x", "o" }, "r", function()
	flash.remote()
end, { desc = "Remote Flash" })
vim.keymap.set({ "n", "x", "o" }, "R", function()
	flash.treesitter_search()
end, { desc = "Treesitter Search" })

-- annotations
local gen = require("neogen")
gen.setup({})

--comments
require("Comment").setup()

vim.keymap.set("n", "<space>cg", function()
	gen.generate()
end, { desc = "Generate Annotation" })

-- persisted sessions
require("persisted").setup()

--project dirs
require("project_nvim").setup({
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
	update_focused_file = {
		enable = true,
		update_root = true,
	},
})

return {} -- TODO: setup lazy loading
