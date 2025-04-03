local lz = require("lz.n")

local dapview_keys = lz.keymap({
	"nvim-dap-view",
	after = function()
		local dap, dv = require("dap"), require("dap-view")
		dap.listeners.before.attach["dap-view-config"] = function()
			dv.open()
		end
		dap.listeners.before.launch["dap-view-config"] = function()
			dv.open()
		end
		dap.listeners.before.event_terminated["dap-view-config"] = function()
			dv.close()
		end
		dap.listeners.before.event_exited["dap-view-config"] = function()
			dv.close()
		end

		dap.defaults.fallback.switchbuf = "useopen"

		require("dap-view").setup({
			windows = {
				terminal = {
					-- NOTE Don't copy paste this snippet
					-- Use the actual names for the adapters you want to hide
					-- `go` is known to not use the terminal.
					hide = { "go", "some-other-adapter" },
				},
			},
		})
	end,
})

dapview_keys.set("n", "<leader>ud", function()
	require("dap-view").toggle()
end, { desc = "Toggle nvim-dap-view" })

---@type lz.n.Spec
return {
	{
		"nvim-dap",
		cmd = { "DapNew" },
		lazy = false, -- TODO: check if this affects startup times
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "continue",
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "run to cursor",
			},
			{
				"<leader>ds",
				function()
					require("dap").step_over()
				end,
				desc = "step over",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "step into",
			},
			{
				"<leader>dh",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "inspect hover",
			},
		},
		before = function()
			lz.trigger_load("nvim-dap-virtual-text")
		end,
		after = function() end,
	},
	{
		"nvim-dap-virtual-text",
		before = function()
			lz.trigger_load("nvim-dap")
		end,
		after = function()
			require("nvim-dap-virtual-text").setup({ enabled = true })
		end,
	},
}
