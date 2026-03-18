return {
	{
		"nvim-mini/mini.pairs",
		version = false, -- always use the latest
		event = "VeryLazy",
		config = function()
			require("mini.pairs").setup({
				-- optional overrides
				modes = { insert = true, command = false, terminal = false },
			})
		end,
	},
}
