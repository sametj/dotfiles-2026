return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts_extend = { "spec" },
	opts = {
		preset = "helix",
		delay = 300, -- popup delay
		win = {
			border = "rounded",
			padding = { 1, 2 },
			title = "Keymaps",
		},
		spec = {
			{
				mode = { "n", "v" },
				-- high-level groups
				{ "<leader><tab>", group = "tabs" },
				{ "<leader>b", group = "buffer" },
				{ "<leader>c", group = "code" },
				{ "<leader>d", group = "debug" },
				{ "<leader>f", group = "find/file" },
				{ "<leader>g", group = "git" },
				{ "<leader>q", group = "quit/session" },
				{ "<leader>s", group = "search" },
				{ "<leader>u", group = "ui" },
				{ "<leader>x", group = "diagnostics/quickfix" },
				{ "[", group = "prev" },
				{ "]", group = "next" },
				{ "g", group = "goto" },
				{ "z", group = "fold" },

				-- Example: Yazi shortcuts
				{ "<leader>e", desc = "Yazi (Current File)" },
				{ "<leader>E", desc = "Yazi (cwd)" },

				-- Optional: Snacks pickers
				{ "<leader>ff", desc = "Find Files (Snacks)" },
				{ "<leader>fg", desc = "Live Grep (Snacks)" },
				{ "<leader>fr", desc = "Recent Files" },
				{ "<leader>fb", desc = "Open Buffers" },
			},
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Show Which-Key popup",
		},
		{
			"<C-w><space>",
			function()
				require("which-key").show({ keys = "<C-w>", loop = true })
			end,
			desc = "Window mode (Which-Key)",
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
	end,
}
