return {

	"rcarriga/nvim-dap-ui",
	dependencies = { 
    "mfussenegger/nvim-dap", 
    "nvim-neotest/nvim-nio",
    "leoluz/nvim-dap-go"
  },

	config = function()
		local dap, dapui = require("dap"), require("dapui")
    
    require("dap-go").setup()
    
    require("dapui").setup()

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
		vim.keymap.set("n", "<Leader>b", function()
			require("dap").toggle_breakpoint()
		end)
		vim.keymap.set("n", "<Leader>dc", function()
			require("dap").continue()
		end)
	end,
}
