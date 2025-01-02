require("obsidian").setup({
	workspaces = {
		{ name = "personal", path = "~/Documents/vault" },
	},
})

require("render-markdown").setup()
