local M = {}

require("lz.n").trigger_load("nvim-dap")
local dap = require("dap")

local function read_args()
	local args = vim.fn.input("Enter args: ")
	return require("dap.utils").splitstr(args)
end

dap.configurations.c = {
	{
		name = "Launch",
		type = "gdb",
		request = "launch",
		program = function()
			return require("dap.utils").pick_file()
		end,
		cwd = "${workspaceFolder}",
		args = function()
			return read_args()
		end,
		stopAtBeginningOfMainSubprogram = false,
	},
	{
		name = "Select and attach to process",
		type = "gdb",
		request = "attach",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		pid = function()
			local name = vim.fn.input("Executable name (filter): ")
			return require("dap.utils").pick_process({ filter = name })
		end,
		cwd = "${workspaceFolder}",
	},
	{
		name = "Attach to gdbserver :1234",
		type = "gdb",
		request = "attach",
		target = "localhost:1234",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
	},
}

-- register the lldb plugin
M.register_lldb = function() -- singleton load lldb
	if vim.g.lldb_loaded then
		return
	end

	require("lz.n").load({ -- handles weird packadd things
		"nvim-dap-lldb",
		lazy = false,
		after = function()
			local lldb_path = require("nixCats").cats.LLDB_PATH.content
			require("dap-lldb").setup({
				codelldb_path = lldb_path,
			})
		end,
	})

	vim.g.lldb_loaded = true
end

M.register_gdb = function()
	if vim.g.gdb_loaded then
		return
	end

	dap.adapters.gdb = {
		type = "executable",
		command = "gdb",
		args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
	}

	vim.g.gdb_loaded = true
end

--TODO: more debuggers

return M
