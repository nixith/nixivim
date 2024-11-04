vim.opt.termguicolors = true
local opts = {
	indicator = {
		style = "underline",
	},
	coloricons = true,
	diagnotics = "nvim_lsp",

	diagnostics_indicator = function(count, level, diagnostics_dict, context)
		local s = " "
		for e, n in pairs(diagnostics_dict) do
			local sym = e == "error" and " " or (e == "warning" and " " or " ")
			s = s .. n .. sym
		end
		return s
	end,
}

require("bufferline").setup({ options = opts })
return {} -- TODO: Lazyload? I feel like I almost always want this, maybe when I have multiple buffers
