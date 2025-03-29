---@module 'snacks'
---@type snacks.Config
local snack_opts = {
	bigfile = { enabled = true },
	dashboard = { enabled = false }, -- TODO: look into startup that doesn't require lazy.nvim
	explorer = { enabled = true },
	indent = { enabled = true },
	input = { enabled = true },
	image = { enabled = true },
	picker = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	scope = { enabled = true },
	scratch = { enabled = true },
	scroll = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
}
local explorer_opts = {
	---@type snacks.explorer.Config
	explorer = {
		replace_netrw = true,
	},
}

local picker_keys = {
	-- Top Pickers & Explorer
	{
		"<leader><space>",
		function()
			require("snacks").picker.smart()
		end,
		desc = "Smart Find Files",
	},
	{
		"<leader>,",
		function()
			require("snacks").picker.buffers()
		end,
		desc = "Buffers",
	},
	{
		"<leader>/",
		function()
			require("snacks").picker.grep()
		end,
		desc = "Grep",
	},
	{
		"<leader>:",
		function()
			require("snacks").picker.command_history()
		end,
		desc = "Command History",
	},
	{
		"<leader>n",
		function()
			require("snacks").picker.notifications()
		end,
		desc = "Notification History",
	},
	{
		"<leader>e",
		function()
			require("snacks").explorer()
		end,
		desc = "File Explorer",
	},
	-- find
	{
		"<leader>fb",
		function()
			require("snacks").picker.buffers()
		end,
		desc = "Buffers",
	},
	{
		"<leader>ff",
		function()
			require("snacks").picker.files()
		end,
		desc = "Find Files",
	},
	{
		"<leader>fg",
		function()
			require("snacks").picker.git_files()
		end,
		desc = "Find Git Files",
	},
	{
		"<leader>fp",
		function()
			require("snacks").picker.projects()
		end,
		desc = "Projects",
	},
	{
		"<leader>fr",
		function()
			require("snacks").picker.recent()
		end,
		desc = "Recent",
	},
	-- git
	{
		"<leader>gb",
		function()
			require("snacks").picker.git_branches()
		end,
		desc = "Git Branches",
	},
	{
		"<leader>gl",
		function()
			require("snacks").picker.git_log()
		end,
		desc = "Git Log",
	},
	{
		"<leader>gL",
		function()
			require("snacks").picker.git_log_line()
		end,
		desc = "Git Log Line",
	},
	{
		"<leader>gs",
		function()
			require("snacks").picker.git_status()
		end,
		desc = "Git Status",
	},
	{
		"<leader>gS",
		function()
			require("snacks").picker.git_stash()
		end,
		desc = "Git Stash",
	},
	{
		"<leader>gd",
		function()
			require("snacks").picker.git_diff()
		end,
		desc = "Git Diff (Hunks)",
	},
	{
		"<leader>gf",
		function()
			require("snacks").picker.git_log_file()
		end,
		desc = "Git Log File",
	},
	-- Grep
	{
		"<leader>sb",
		function()
			require("snacks").picker.lines()
		end,
		desc = "Buffer Lines",
	},
	{
		"<leader>sB",
		function()
			require("snacks").picker.grep_buffers()
		end,
		desc = "Grep Open Buffers",
	},
	{
		"<leader>sg",
		function()
			require("snacks").picker.grep()
		end,
		desc = "Grep",
	},
	{
		"<leader>sw",
		function()
			require("snacks").picker.grep_word()
		end,
		desc = "Visual selection or word",
		mode = { "n", "x" },
	},
	-- search
	{
		'<leader>s"',
		function()
			require("snacks").picker.registers()
		end,
		desc = "Registers",
	},
	{
		"<leader>s/",
		function()
			require("snacks").picker.search_history()
		end,
		desc = "Search History",
	},
	{
		"<leader>sa",
		function()
			require("snacks").picker.autocmds()
		end,
		desc = "Autocmds",
	},
	{
		"<leader>sb",
		function()
			require("snacks").picker.lines()
		end,
		desc = "Buffer Lines",
	},
	{
		"<leader>sc",
		function()
			require("snacks").picker.command_history()
		end,
		desc = "Command History",
	},
	{
		"<leader>sC",
		function()
			require("snacks").picker.commands()
		end,
		desc = "Commands",
	},
	{
		"<leader>sd",
		function()
			require("snacks").picker.diagnostics()
		end,
		desc = "Diagnostics",
	},
	{
		"<leader>sD",
		function()
			require("snacks").picker.diagnostics_buffer()
		end,
		desc = "Buffer Diagnostics",
	},
	{
		"<leader>sh",
		function()
			require("snacks").picker.help()
		end,
		desc = "Help Pages",
	},
	{
		"<leader>sH",
		function()
			require("snacks").picker.highlights()
		end,
		desc = "Highlights",
	},
	{
		"<leader>si",
		function()
			require("snacks").picker.icons()
		end,
		desc = "Icons",
	},
	{
		"<leader>sj",
		function()
			require("snacks").picker.jumps()
		end,
		desc = "Jumps",
	},
	{
		"<leader>sk",
		function()
			require("snacks").picker.keymaps()
		end,
		desc = "Keymaps",
	},
	{
		"<leader>sl",
		function()
			require("snacks").picker.loclist()
		end,
		desc = "Location List",
	},
	{
		"<leader>sm",
		function()
			require("snacks").picker.marks()
		end,
		desc = "Marks",
	},
	{
		"<leader>sM",
		function()
			require("snacks").picker.man()
		end,
		desc = "Man Pages",
	},
	{
		"<leader>sp",
		function()
			require("snacks").picker.lazy()
		end,
		desc = "Search for Plugin Spec",
	},
	{
		"<leader>sq",
		function()
			require("snacks").picker.qflist()
		end,
		desc = "Quickfix List",
	},
	{
		"<leader>sR",
		function()
			require("snacks").picker.resume()
		end,
		desc = "Resume",
	},
	{
		"<leader>su",
		function()
			require("snacks").picker.undo()
		end,
		desc = "Undo History",
	},
	{
		"<leader>uC",
		function()
			require("snacks").picker.colorschemes()
		end,
		desc = "Colorschemes",
	},
	-- LSP
	{
		"gd",
		function()
			require("snacks").picker.lsp_definitions()
		end,
		desc = "Goto Definition",
	},
	{
		"gD",
		function()
			require("snacks").picker.lsp_declarations()
		end,
		desc = "Goto Declaration",
	},
	{
		"gr",
		function()
			require("snacks").picker.lsp_references()
		end,
		nowait = true,
		desc = "References",
	},
	{
		"gI",
		function()
			require("snacks").picker.lsp_implementations()
		end,
		desc = "Goto Implementation",
	},
	{
		"gy",
		function()
			require("snacks").picker.lsp_type_definitions()
		end,
		desc = "Goto T[y]pe Definition",
	},
	{
		"<leader>ss",
		function()
			require("snacks").picker.lsp_symbols()
		end,
		desc = "LSP Symbols",
	},
	{
		"<leader>sS",
		function()
			require("snacks").picker.lsp_workspace_symbols()
		end,
		desc = "LSP Workspace Symbols",
	},
}

local lazygit_keys = {
	{
		"<leader>gg",
		function()
			require("snacks").lazygit.open()
		end,
		desc = "Open Lazygit",
	},
}

local scratch_keys = {
	{
		"<leader>.",
		function()
			require("snacks").scratch()
		end,
		desc = "Toggle Scratch Buffer",
	},
	{
		"<leader>S",
		function()
			require("snacks").scratch.select()
		end,
		desc = "Select Scratch Buffer",
	},
}

local term_keys = {
	{
		"<c-/>",
		function()
			require("snacks").terminal.toggle()
		end,
		desc = "Toggle Scratch Buffer",
	},
}

local final_opts = vim.tbl_deep_extend("force", snack_opts, explorer_opts)
local final_keys = vim.tbl_deep_extend("force", picker_keys, lazygit_keys, scratch_keys, term_keys)

return {
	"snacks.nvim",
	keys = final_keys,
	lazy = false,
	after = function()
		local Snacks = require("snacks")
		Snacks.setup(final_opts)
		Snacks.scroll.enable()
		vim.opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
	end,
}
