local config = require("config.init")

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type Snacks.Config
  opts = {
    bufdelete = { enabled = true },
    indent = { enabled = true },
    scroll = { enabled = true },
    dashboard = {
      enabled = false,
      preset = {
        keys = {
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "p", desc = "Find Project", action = ":Telescope project" },
          { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
          { icon = " ", key = "g", desc = "Find Text", action = ":Telescope live_grep" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
          { icon = " ", key = "c", desc = "Config", action = ":Telescope find_files({ cwd = vim.fn.stdpath('config') })" },
          { icon = " ", key = "e", desc = "Mason", action = ":Mason" },
          -- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" }, --icon = "  ",
        },
        header = config.header,
      },
      sections = {
        { section = "header" },
        { section = "keys",   gap = 0, padding = 1 },
        { section = "startup" },
      },
    },
  },
  keys = {
    -- bufdelete
    { "<leader>bx", function() Snacks.bufdelete.delete() end,                 desc = "Delete current buffer" },
    { "<leader>bX", function() Snacks.bufdelete.delete({ force = true }) end, desc = "Force delete current buffer" },
    { "<leader>by", function() Snacks.bufdelete.other() end,                  desc = "Delete other buffers" },
    { "<leader>bY", function() Snacks.bufdelete.delete({ force = true }) end, desc = "Force delete other buffers" },
    { "<leader>bz", function() Snacks.bufdelete.all() end,                    desc = "Delete all buffers" },
    { "<leader>bZ", function() Snacks.bufdelete.all({ force = true }) end,    desc = "Force delete all buffers" },
    -- scratch
    { "<leader>.",  function() Snacks.scratch() end,                          desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end,                   desc = "Select Scratch Buffer" },
  },
}
