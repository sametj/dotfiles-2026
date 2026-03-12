return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = { "ToggleTerm", "TermExec", "TermNew", "TermSelect" },
		keys = {
			{ "<leader>wr", desc = "Dotnet Watch Run" },
			{ "<leader>wp", desc = "Dotnet Watch Project Run" },
			{ "<leader>wt", desc = "ToggleTerm" },
		},
		opts = {
			direction = "horizontal",
			size = 15,
			close_on_exit = false,
			start_in_insert = true,
			persist_mode = true,
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)

			local Terminal = require("toggleterm.terminal").Terminal

			local dotnet_watch = Terminal:new({
				cmd = "dotnet watch run",
				direction = "horizontal",
				close_on_exit = false,
				hidden = true,
			})

			local dotnet_watch_project = Terminal:new({
				cmd = "dotnet watch --project . run",
				direction = "horizontal",
				close_on_exit = false,
				hidden = true,
			})

			vim.keymap.set("n", "<leader>wr", function()
				dotnet_watch:toggle()
			end, { desc = "Dotnet Watch Run" })

			vim.keymap.set("n", "<leader>wp", function()
				dotnet_watch_project:toggle()
			end, { desc = "Dotnet Watch Project Run" })

			vim.keymap.set("n", "<leader>wt", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })
		end,
	},
}
