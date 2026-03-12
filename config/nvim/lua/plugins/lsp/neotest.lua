return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"Issafalcon/neotest-dotnet",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-dotnet")({
					dap = { justMyCode = false },
				}),
			},
		})

		vim.keymap.set("n", "<Leader>tt", function()
			require("neotest").run.run()
		end, { desc = "Run nearest test" })

		vim.keymap.set("n", "<Leader>tf", function()
			require("neotest").run.run(vim.fn.expand("%"))
		end, { desc = "Run test file" })

		vim.keymap.set("n", "<Leader>td", function()
			require("neotest").run.run({ strategy = "dap" })
		end, { desc = "Debug nearest test" })

		vim.keymap.set("n", "<Leader>to", function()
			require("neotest").output.open({ enter = true })
		end, { desc = "Open test output" })

		vim.keymap.set("n", "<Leader>ts", function()
			require("neotest").summary.toggle()
		end, { desc = "Toggle test summary" })
	end,
}
