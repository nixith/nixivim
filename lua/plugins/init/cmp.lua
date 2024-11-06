local blink_keymap = {
	["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
	["<C-e>"] = { "hide" },
	["<C-enter>"] = { "select_and_accept", "fallback" },

	["<C-p>"] = { "select_prev", "fallback" },
	["<C-n>"] = { "select_next", "fallback" },

	["<C-b>"] = { "scroll_documentation_up", "fallback" },
	["<C-f>"] = { "scroll_documentation_down", "fallback" },

	["<Tab>"] = { "snippet_forward", "fallback" },
	["<S-Tab>"] = { "snippet_backward", "fallback" },
}
local blink_opts = {
	keymap = blink_keymap,
	highlight = {
		-- sets the fallback highlight groups to nvim-cmp's highlight groups
		-- useful for when your theme doesn't support blink.cmp
		-- will be removed in a future release, assuming themes add support
		use_nvim_cmp_as_default = true,
	},
	-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
	-- adjusts spacing to ensure icons are aligned
	nerd_font_variant = "Mono",
	windows = {
		autocomplete = {
			draw = "reversed",
			winblend = vim.o.pumblend,
		},
		documentation = {
			auto_show = true,
		},
		ghost_text = {
			enabled = true,
		},
	},

	sources = {
		completion = {
			-- remember to enable your providers here
			enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev" },
		},
		providers = {
			-- lazydev = {
			-- 	name = "lazydev", -- IMPORTANT: use the same name as you would for nvim-cmp
			-- 	module = "blink.compat.source",
			-- 	opts = {
			-- 		-- options for the completion source
			-- 		-- equivalent to `option` field of nvim-cmp source config
			-- 	},
			-- },
			lsp = { fallback_for = { "lazydev" } },
			lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
		},
	},

	-- experimental auto-brackets support
	accept = { auto_brackets = { enabled = true } },

	-- experimental signature help support
	trigger = { signature_help = { enabled = true } },
	fuzzy = { prebuilt_binaries = { download = false } },
}

require("blink.compat").setup({})
require("blink.cmp").setup(blink_opts)

return {} -- lazy loading handled internally
