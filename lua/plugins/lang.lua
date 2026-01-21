---@type lz.n.Spec
return {
	{
		"hex.nvim",
		event = "DeferredUIEnter", --TODO: bind to keybinds/vimcmds
		after = function()
			require("hex").setup()
		end,
	},
	{
		"typst-preview.nvim",
		ft = "typst",
		after = function()
			-- setup typst stuff
			require("util.lang").setup("typst", "typstyle", nil, "tinymist")
			local tinymist = vim.env.TINYMIST_PATH
			local websocat = vim.env.WEBSOCAT_PATH
			require("typst-preview").setup({
				dependencies_bin = {
					["tinymist"] = tinymist, --NOTE: Relies on env var, want to move to category definition at some point if I can figure out how to mix explicit and implicit category stuffs.
					["websocat"] = websocat,
				},
			})
		end,
	},
}
