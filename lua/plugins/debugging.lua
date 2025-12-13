return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
		"leoluz/nvim-dap-go",
	},

	config = function()
		local dap, dapui = require("dap"), require("dapui")

		-- Go debugging
		require("dap-go").setup()

		-- DAP UI setup
		dapui.setup()

		-- Open UI automatically
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
			vim.cmd("wincmd =")
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
		dap.listeners.after.event_stopped["auto_jump"] = function()
			dap.goto_()
		end

		-- Keymaps
		vim.keymap.set("n", "<Leader>b", function()
			require("dap").toggle_breakpoint()
		end)
		vim.keymap.set("n", "<Leader>dc", function()
			require("dap").continue()
		end)
		vim.keymap.set("n", "<Leader>dr", dapui.toggle)
		vim.keymap.set("n", "<Leader>dq", function()
			require("dapui").close()
			require("dap").terminate()
		end, { desc = "Close DAP UI and terminate debugger" })

		----------------------------------------------------------------------
		-- C / C++ / Rust debugging with lldb-dap
		----------------------------------------------------------------------

		dap.adapters.lldb = {
			type = "executable",
			-- Adjust path if installed via Homebrew:
			--   /opt/homebrew/opt/llvm/bin/lldb-dap (Apple Silicon)
			--   /usr/local/opt/llvm/bin/lldb-dap (Intel)
			-- Or check with: `which lldb-dap`
			command = "/opt/homebrew/opt/llvm/bin/lldb-dap",
			name = "lldb",
		}

		dap.configurations.cpp = {
			{
				name = "Launch file",
				type = "lldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
			},
		}

		-- Reuse config for C and Rust
		dap.configurations.c = dap.configurations.cpp
		dap.configurations.rust = dap.configurations.cpp
	end,
}
