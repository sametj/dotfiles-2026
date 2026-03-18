return {
	"projekt0n/github-nvim-theme",
	lazy = false,
	priority = 1000,
	config = function()
		require("github-theme").setup({
			options = {
				transparent = false, -- make background blend with terminal
				terminal_colors = true,
			},
		})
		vim.cmd.colorscheme("github_dark_default")
	end,
}
