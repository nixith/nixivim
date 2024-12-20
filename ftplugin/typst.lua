require("typst-preview.nvim").setup({
	dependencies_bin = {
		["tinymist"] = vim.env.TINYMIST_PATH, --NOTE: Relies on env var, want to move to category definition at some point if I can figure out how to mix explicit and implicit category stuffs.
		["websocat"] = vim.env.WEBSOCAT_PATH,
	},
})
