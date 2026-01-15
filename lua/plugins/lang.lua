---@type lz.n.Spec
return {
	{
		"hex.nvim",
		event = "DeferredUIEnter", --TODO: bind to keybinds/vimcmds
		after = function()
			require("hex").setup()
		end,
	},
}
