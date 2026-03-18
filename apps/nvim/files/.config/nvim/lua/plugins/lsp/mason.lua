-- ~/.config/nvim/lua/plugins/lsp/mason.lua
return {
	"mason-org/mason.nvim",
	build = ":MasonUpdate",
	cmd = "Mason",
	opts = {
		registries = {
			"github:mason-org/mason-registry",
			"github:Crashdummyy/mason-registry",
		},
		ui = {
			border = "rounded",
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},

		-- 🧩 Tools and formatters to ensure are installed (non-LSP)
		ensure_installed = {
			-- Lua
			"stylua",
			"lua-language-server",

			-- Shell
			"shfmt",

			-- Docker
			"dockerfile-language-server",

			-- Web / JS
			"eslint_d",
			"prettierd",
			"css-lsp",
			"css-variables-language-server",
			"cssmodules-language-server",
			"stylelint",
			"html-lsp",
			"emmet-language-server",
			"json-lsp",

			-- Python
			"pyright",
			"black",
			"isort",
			"pylint",

			-- Debugging
			"js-debug-adapter",

			-- C#
			-- "csharp-language-server",
			"csharpier",

			-- Azure
			"bicep-lsp",

			-- XML
			"xmlformatter",
		},
	},

	config = function(_, opts)
		local mason = require("mason")
		local mr = require("mason-registry")

		mason.setup(opts)

		-- Auto-install any missing tools from ensure_installed list
		for _, tool in ipairs(opts.ensure_installed or {}) do
			local p = mr.get_package(tool)
			if not p:is_installed() then
				p:install()
			end
		end
	end,
}
