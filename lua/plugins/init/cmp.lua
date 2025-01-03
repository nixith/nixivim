local blink_cmd_keymap = {
	["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
	["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
}

---@module 'blink.cmp'
---@type blink.cmp.Config
local blink_opts = {
	keymap = {
		preset = "enter",
		cmdline = {
			preset = "enter",
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		},
	},
	completion = {
		ghost_text = { enabled = true },
		list = {
			selection = function(ctx)
				return ctx.mode == "cmdline" and "auto_insert" or "preselect"
			end,
		},
		menu = { draw = { treesitter = { "lsp" } } },
	},
	sources = {
		default = { "lazydev", "lsp", "path", "snippets", "buffer" },
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
		},
	},
	signature = { enabled = true },
	fuzzy = { prebuilt_binaries = { download = false } },
	-- keymap = blink_keymap,
	-- highlight = {
	-- 	-- sets the fallback highlight groups to nvim-cmp's highlight groups
	-- 	-- useful for when your theme doesn't support blink.cmp
	-- 	-- will be removed in a future release, assuming themes add support
	-- 	use_nvim_cmp_as_default = true,
	-- },
	-- -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
	-- -- adjusts spacing to ensure icons are aligned
	--
	-- windows = {
	-- 	autocomplete = {
	-- 		draw = "reversed",
	-- 		winblend = vim.o.pumblend,
	-- 	},
	-- 	documentation = {
	-- 		auto_show = true,
	-- 	},
	-- 	ghost_text = {
	-- 		enabled = true,
	-- 	},
	-- },
	--  complestion = {
	--    list = { selection = 'auto_insert' },
	--  },
	-- sources = {
	-- 	completion = {
	-- 		-- remember to enable your providers here
	-- 		enabled_providers = {
	-- 			"lsp",
	-- 			"path",
	-- 			"snippets",
	-- 			"buffer",
	-- 			"lazydev",
	-- 			-- "markdown" --TODO: update when blink integration hits main
	-- 		},
	-- 	},
	-- 	providers = {
	-- 		-- lazydev = {
	-- 		-- 	name = "lazydev", -- IMPORTANT: use the same name as you would for nvim-cmp
	-- 		-- 	module = "blink.compat.source",
	-- 		-- 	opts = {
	-- 		-- 		-- options for the completion source
	-- 		-- 		-- equivalent to `option` field of nvim-cmp source config
	-- 		-- 	},
	-- 		-- },
	-- 		lsp = { fallback_for = { "lazydev" } },
	-- 		lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
	-- 		-- markdown = {
	-- 		-- 	name = "RenderMarkdown",
	-- 		-- 	module = "render-markdown.integ.blink",
	-- 		-- 	fallbacks = { "lsp" },
	-- 		-- },
	-- 	},
	-- },
	--
	-- -- experimental auto-brackets support
	-- accept = { auto_brackets = { enabled = true } },
	-- -- experimental signature help support
	-- signature = { enabled = true },
}

require("blink.compat").setup({})
require("blink.cmp").setup(blink_opts)

return {} -- lazy loading handled internally
