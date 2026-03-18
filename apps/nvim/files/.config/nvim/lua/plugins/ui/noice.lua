return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
			inc_rename = false,
			lsp_doc_border = true,
		},
		views = {
			mini = {
				position = {
					row = "0%", -- top of the screen
					col = "100%", -- right edge
				},
				win_options = {
					winblend = 0,
				},
			},
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
}
