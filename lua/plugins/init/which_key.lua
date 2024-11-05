-- which key installation module

-- keymaps
local which_key = require("which-key")

--vim.keymap.set('n', '<leader>?', which_key.show({ global = false }), { desc = "Buffer Local Keymaps (which-key)" })
which_key.setup({
	triggers = {
		{ "<auto>", mode = "nixsotc" },
		{ "a", mode = { "n", "v" } },
	},
})

return {} -- TODO lazyload
