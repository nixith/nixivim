-- which key installation module

-- keymaps
local preview = require("typst-preview")

--vim.keymap.set('n', '<leader>?', which_key.show({ global = false }), { desc = "Buffer Local Keymaps (which-key)" })
preview.setup({
  follow_cursor = true,
    dependencies_bin = {
    ['tinymist'] =  -- TODO: nixcats path to tinymist OR nil if that is nil
    ['websocat'] =  --
  },
})

return {} -- TODO lazyload
