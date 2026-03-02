return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },

	-- correct module in your installed version
	main = "nvim-treesitter.config",

	opts = {
		highlight = { enable = true },
		indent = { enable = true },
		ensure_installed = {
			"lua",
			"typescript",
			"javascript",
			"python",
			"html",
			"css",
			"json",
			"bash",
			"yaml",
			"toml",
			"dockerfile",
		},
		auto_install = true,
	},
}
