---@module 'nvim-treesitter'

---@type TSConfig
local tsOpts = {
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
}

---@type lz.n.Spec
return {
	"nvim-treesitter",
	event = "DeferredUIEnter",
	after = function()
		require("nvim-treesitter.configs").setup(tsOpts)
	end,
}
