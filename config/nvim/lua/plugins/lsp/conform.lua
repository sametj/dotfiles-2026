return {
	"stevearc/conform.nvim",
	event = "BufWritePre", -- auto-format on save
	cmd = { "ConformInfo" },
	opts = {
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			json = { "prettierd" },
			html = { "prettierd" },
			css = { "prettierd" },
			cs = { "csharpier" },
			cshtml = { "csharpier" },
			razor = { "csharpier" },
			xml = { "csharpier" },
			sh = { "shfmt" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
		},
	},
	config = function(_, opts)
		require("conform").setup(opts)

		-- Optional manual keymap
		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, { desc = "Format file" })
	end,
}
