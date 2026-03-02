-- ~/.config/nvim/lua/plugins/ui/lualine.lua
local formatter = function()
	local ok, conform = pcall(require, "conform")
	if not ok then
		return ""
	end
	local formatters = conform.list_formatters(0)
	if #formatters == 0 then
		return ""
	end
	return "󰛖 "
end

local linter = function()
	local ok, lint = pcall(require, "lint")
	if not ok then
		return ""
	end
	local linters = lint.linters_by_ft[vim.bo.filetype] or {}
	if vim.tbl_isempty(linters) then
		return ""
	end
	return "󱉶 "
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",

	opts = function()
		-- 🧩 LSP client name helper
		local function lsp_name()
			local msg = "No LSP"
			local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
			local clients = vim.lsp.get_clients()
			if next(clients) == nil then
				return msg
			end
			for _, client in ipairs(clients) do
				local filetypes = client.config.filetypes
				if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
					return " " .. client.name
				end
			end
			return msg
		end

		return {
			options = {
				theme = "auto",
				globalstatus = true,
				icons_enabled = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha", "dashboard", "snacks_dashboard", "neo-tree", "lazy" },
			},

			sections = {
				-- left bubble
				lualine_a = { { "mode", icon = "" } },
				lualine_b = { { "branch", icon = "" } },

				lualine_c = {
					{
						"filetype",
						icon_only = true,
						separator = "",
						padding = { left = 1, right = 0 },
					},
					{
						"filename",
						path = 1,
						symbols = { modified = "", readonly = "" },
					},
					{
						"diagnostics",
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
					},
				},

				-- right section (like LazyVim’s)
				lualine_x = {
					formatter, -- 󰛖  shows if Conform has a formatter
					linter, -- 󱉶  shows if nvim-lint has a linter
					{ lsp_name }, -- LSP client name
					{
						"diff",
						symbols = { added = " ", modified = " ", removed = " " },
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
					{
						"encoding",
						fmt = string.upper,
					},
				},

				lualine_y = { "progress" },
				lualine_z = {
					{ "location", separator = "" },
					{
						function()
							return ""
						end,
						padding = { left = 0, right = 1 },
					},
				},
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},

			extensions = { "lazy", "mason", "quickfix", "neo-tree" },
		}
	end,

	config = function(_, opts)
		require("lualine").setup(opts)

		-- Transparent background (for Kanagawa / Catppuccin)
		vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
	end,
}
