local cfg = require("config.init")

return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  opts = {},
  dependencies = {
    'nvim-tree/nvim-web-devicons'
  },
  keys = {
    { "<leader>d", "<cmd>Dashboard<cr>", desc = "Open Dashboard" }
  },
  config = function()
    local center = {
      {
        desc = "Find Project",
        keymap = "",
        key_format = ' %s',
        key = "p",
        icon = "  ",
        action = "Telescope project",
      },
      {
        desc = "Recents",
        keymap = "",
        key_format = ' %s',
        key = "r",
        icon = "  ",
        action = "Telescope oldfiles",
      },
      {
        desc = "Update Plugins",
        keymap = "",
        key = "u",
        key_format = ' %s',
        icon = "  ",
        action = "Lazy update",
      },

      {
        desc = "manage extensions",
        keymap = "",
        key = "e",
        key_format = ' %s',
        icon = "  ",
        action = "mason",
      },
      {
        desc = "config",
        keymap = "",
        key_format = ' %s',
        key = "c",
        icon = "  ",
        action = "telescope find_files cwd=~/.config/kedwards",
      },
      {
        desc = "exit",
        keymap = "",
        key_format = ' %s',
        key = "q",
        icon = "  ",
        action = "exit",
      },
    }

    vim.api.nvim_create_autocmd("Filetype", {
      pattern = "dashboard",
      group = vim.api.nvim_create_augroup("Dashboard_au", { clear = true }),
      callback = function()
        vim.cmd([[
          setlocal buftype=nofile
          setlocal nonumber norelativenumber nocursorline noruler
        ]])
      end,
    })

    require("dashboard").setup({
      theme = "doom",
      config = {
        header = cfg.header,
        center = center,
        footer = function()
          return {
            "Startup time: " .. require "lazy".stats().startuptime .. " ms"
          }
        end,
      },
    })
  end
}
