-- all tokens
vim.lsp.config("*", {
	root_markers = { ".git" },
})

vim.lsp.config("*", {
	capabilities = {
		textDocument = {
			semanticTokens = {
				multilineTokenSupport = true,
			},
		},
	},
})

-- set neovim's working dir to that of the lsp's
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client ~= nil and client.root_dir then
			vim.api.nvim_set_current_dir(client.root_dir)
		end
	end,
})

--TODO: move individual config extensions to lsp/<lsp>.lua
--TODO: move over to new lspconfig items, when they're ready
--TODO: lsp keybinds

vim.lsp.config("nixd", {
	filetypes = { "nix" },
	cmd = { "nixd" },
	root_markers = {
		".git",
		"flake.nix",
	},
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import <nixpkgs> { }",
			},
			formatting = {
				command = { "nixfmt" },
			},
		},
	},
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	root_marker = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
	filetypes = { "lua" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global, etc.
				globals = {
					"vim",
					"describe",
					"it",
					"assert",
					"stub",
				},
				disable = {
					"duplicate-set-field",
				},
			},
			-- workspace = {
			-- 	checkThirdParty = false,
			-- },
			telemetry = {
				enable = false,
			},
			hint = { -- inlay hints (supported in Neovim >= 0.10)
				enable = true,
			},
		},
	},
})

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--clang-tidy",
		"--background-index",
		"--offset-encoding=utf-8",
	},
	root_markers = { ".clangd", "compile_commands.json" },
	filetypes = { "c", "cpp" },
})

vim.lsp.enable({ "lua_ls", "nixd", "clangd" })

return {}

-- we're doing langs here for now.. I would prefer on filetype, buuuuuut it's weird
