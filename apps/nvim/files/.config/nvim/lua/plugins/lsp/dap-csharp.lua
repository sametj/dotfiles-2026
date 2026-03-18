return {
	{
		"mfussenegger/nvim-dap",
		ft = { "cs" },
		keys = {
			{ "<F5>", desc = "Debug Continue" },
			{ "<F10>", desc = "Debug Step Over" },
			{ "<F11>", desc = "Debug Step Into" },
			{ "<F12>", desc = "Debug Step Out" },
			{ "<leader>db", desc = "Toggle Breakpoint" },
			{ "<leader>dB", desc = "Conditional Breakpoint" },
			{ "<leader>du", desc = "Toggle Debug UI" },
			{ "<leader>dc", desc = "Debug Continue" },
			{ "<leader>di", desc = "Debug Step Into" },
			{ "<leader>do", desc = "Debug Step Over" },
			{ "<leader>dO", desc = "Debug Step Out" },
		},
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			dap.adapters.netcoredbg = {
				type = "executable",
				command = "netcoredbg",
				args = { "--interpreter=vscode" },
			}

			local function get_dll()
				local cwd = vim.fn.getcwd()

				local build_output = vim.fn.system("dotnet build")
				if vim.v.shell_error ~= 0 then
					vim.notify(build_output, vim.log.levels.ERROR)
					error("dotnet build failed")
				end

				local csproj = vim.fn.glob(cwd .. "/*.csproj")
				if csproj == "" then
					error("No .csproj file found in " .. cwd)
				end

				local project_name = vim.fn.fnamemodify(csproj, ":t:r")

				local dlls = vim.fn.glob(cwd .. "/bin/Debug/*/" .. project_name .. ".dll", true, true)
				local dll = dlls[1]

				if not dll or dll == "" then
					error("No DLL found for project: " .. project_name)
				end

				vim.notify("Launching: " .. dll)
				return dll
			end

			dap.configurations.cs = {
				{
					type = "netcoredbg",
					name = "Launch .NET Project",
					request = "launch",
					program = get_dll,
					cwd = "${workspaceFolder}",
					stopAtEntry = false,
					console = "integratedTerminal",
				},
			}

			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug Continue" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug Step Over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug Step Into" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug Step Out" })

			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Conditional Breakpoint" })

			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug Continue" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug Step Into" })
			vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug Step Over" })
			vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug Step Out" })
			vim.keymap.set("n", "<leader>du", function()
				dapui.toggle({})
			end, { desc = "Toggle Debug UI" })
		end,
	},
}
