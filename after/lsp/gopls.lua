vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client or client.name ~= "gopls" then
			return
		end

		-- Inject semantic tokens capability if missing
		if not client.server_capabilities.semanticTokensProvider then
			local semantic = client.config.capabilities.textDocument.semanticTokens
			if semantic then
				client.server_capabilities.semanticTokensProvider = {
					full = true,
					legend = {
						tokenModifiers = semantic.tokenModifiers,
						tokenTypes = semantic.tokenTypes,
					},
					range = true,
				}
			end
		end
	end,
})

return {
	settings = {
		gopls = {
			gofumpt = true,
			codelenses = {
				gc_details = false,
				generate = true,
				regenerate_cgo = true,
				run_govulncheck = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			analyses = {
				nilness = true,
				unusedparams = true,
				unusedwrite = true,
				useany = true,
			},
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
			semanticTokens = true,
		},
	},
	-- on_attach = function(client, bufnr)
	-- 	if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
	-- 		local semantic = client.config.capabilities.textDocument.semanticTokens
	-- 		if semantic then
	-- 			client.server_capabilities.semanticTokensProvider = {
	-- 				full = true,
	-- 				legend = {
	-- 					tokenModifiers = semantic.tokenModifiers,
	-- 					tokenTypes = semantic.tokenTypes,
	-- 				},
	-- 				range = true,
	-- 			}
	-- 		end
	-- 	end
	-- end,
}
