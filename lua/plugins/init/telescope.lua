-- keymaps

-- builtin.quickfix
-- builtin.symbols
-- builtin.spell_suggest
-- builtin.keymaps
--builtin.current_buffer_fuzzy_find
--telescope.setup({})
require("fzf-lua").setup("default-title")

local builtin = require("fzf-lua")
vim.keymap.set("n", "<leader>ff", builtin.files, { desc = "[f]ind [f]iles from path" })
vim.keymap.set("n", "<leader>fw", builtin.live_grep_glob, { desc = "[f]ind [w]ord" })
vim.keymap.set("n", "<leader>ft", builtin.tags_live_grep, { desc = "[f]ind [t]ag" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[f]ind [b]uffers" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics_workspace, { desc = "[f]ind [d]iagnostics" })
vim.keymap.set("n", "<leader>fl", builtin.lsp_finder, { desc = "[f]ind [l]SP item" })
vim.keymap.set("n", "<leader>fh", builtin.helptags, { desc = "[f]ind [h]elp tags" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[f]ind [k]eymaps" })
vim.keymap.set("n", "<leader>fm", builtin.manpages, { desc = "[f]ind [m]anpages" })

-- debug

-- vim.api.nvim_create_autocmd("DapAtattch", { --TODO: DAP auGroup
-- 	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
-- 	callback = function(event)
-- 		-- NOTE: Remember that Lua is a real programming language, and as such it is possible
-- 		-- to define small helper and utility functions so you don't have to repeat yourself.
-- 		--
-- 		-- In this case, we create a function that lets us more easily define mappings specific
-- 		-- for LSP related items. It sets the mode, buffer and description for us each time.
-- 		local map = function(keys, func, desc)
-- 			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
-- 		end
--
-- 		map("<leader>dfc", builtin.manpages, "[d]ebug [f]ind [c]ommands")
-- 		map("<leader>dfC", builtin.manpages, "[d]ebug [f]ind [C]onfigurations")
-- 		map("<leader>dfb", builtin.manpages, "[d]ebug [f]ind [b]reakpoints")
-- 		map("<leader>dfv", builtin.manpages, "[d]ebug [f]ind [v]ariables")
-- 	end,
-- })
--TODO: lazy /loada
--
