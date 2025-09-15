return {
  "mikavilpas/yazi.nvim",
  lazy = true, -- use `event = "VeryLazy"` for netrw replacement
  keys = {
    {
      "<leader>lm",
      "<cmd>Yazi<cr>",
      desc = "Open Yazi (file manager)",
    },
  },
  opts = {
    open_for_directories = true,
  },
}
