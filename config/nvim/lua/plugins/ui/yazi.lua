return {
	"mikavilpas/yazi.nvim",
	keys = {
		{ "<leader>e", "<cmd>Yazi<cr>", desc = "Yazi (Current File)" },
		{ "<leader>E", "<cmd>Yazi cwd<cr>", desc = "Yazi (cwd)" },
		{ "<A-e>", "<cmd>Yazi toggle<cr>", desc = "Resume Last Yazi Session" },
	},
	opts = {
		open_for_directories = true,
		floating_window_scaling_factor = 0.9, -- 90% of screen size
		yazi_floating_window_border = "rounded",
		yazi_floating_window_winblend = 0, -- 0 = fully opaque, higher = transparent
		yazi_floating_window_zindex = 100, -- make sure it’s on top
		open_multiple_tabs = false,
		highlight_hovered_buffers_in_same_directory = true,
		change_neovim_cwd_on_close = false,
		integrations = {
			grep_in_directory = "snacks.picker",
			grep_in_selected_files = "snacks.picker",
		},
	},
}
