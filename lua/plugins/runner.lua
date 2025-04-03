---@type lz.n.Spec
return {
	"overseer.nvim",
	keys = {
		{
			"<leader>rt",
			function()
				require("overseer").toggle()
			end,
			desc = "overseer toggle ui",
		}, -- TODO: snacks toggle
		{
			"<leader>ra",
			function()
				vim.cmd("OverseerRun")
			end,
			desc = "overseer run action",
		}, -- TODO: snacks toggle
		{
			"<leader>rr",
			function()
				local overseer = require("overseer")
				local tasks = overseer.list_tasks({ recent_first = true })
				if vim.tbl_isempty(tasks) then
					vim.notify("No tasks found", vim.log.levels.WARN)
				else
					overseer.run_action(tasks[1], "restart")
				end
			end,
			desc = "overseer run last task",
		},
	},
	after = function()
		require("overseer").setup({
			task_list = {
				direction = "left",
			},
		})
	end,
}
