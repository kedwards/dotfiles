return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "jay-babu/mason-nvim-dap.nvim",
    "theHamsta/nvim-dap-virtual-text",
    "mason-org/mason.nvim",
  },
  config = function()
    local dap = require("dap")
    local ui = require "dapui"

    require("dapui").setup()
    require("nvim-dap-virtual-text").setup()

    dap.configurations.lua = {
      {
        name = 'Current file (local-lua-dbg, lua)',
        type = 'local-lua',
        request = 'launch',
        cwd = '${workspaceFolder}',
        program = {
          lua = 'lua5.4',
          file = '${file}',
        },
        args = {},
      },
    }

    vim.keymap.set("n", "<F1>", dap.continue)
    vim.keymap.set("n", "<F2>", dap.step_into)
    vim.keymap.set("n", "<F3>", dap.step_over)
    vim.keymap.set("n", "<F4>", dap.step_out)
    vim.keymap.set("n", "<F5>", dap.step_back)
    vim.keymap.set("n", "<F13>", dap.restart)

    dap.listeners.before.attach.dapui_config = function() ui.open() end
    dap.listeners.before.launch.dapui_config = function() ui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() ui.close() end
    dap.listeners.before.event_exited.dapui_config = function() ui.close() end
  end,
}
