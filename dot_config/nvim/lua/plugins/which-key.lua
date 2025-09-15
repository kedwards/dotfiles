return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {},
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function()
    local wk = require("which-key")

    wk.add({
      -- defaults from keymaps.lua
      -- write buffers and Source NVIM
      {
        mode = { "n", "v" },
        { "<leader>b", group = "Buffers" },
        { "<space><space>", group = "Source" },
      },
      -- plugins/core/telescope.lua
      { "<leader>f", group = "Telescope" },
      -- plugins/core/fugitive.lua
      -- pliugins/core/telescope.lua
      { "<leader>g", group = "Git" },
    })
  end,
}
