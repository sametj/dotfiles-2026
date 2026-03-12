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
			"vim",
			"lua",
			"vimdoc",
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
			"vimdoc",
			"c_sharp",
			"bicep",
		},
		auto_install = true,
	},
}
