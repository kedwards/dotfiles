return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      "<leader>bb",
      "<cmd>Telescope file_browser<cr>",
      desc = "File browser",
    },
  },
  opts = {
    extensions = {
      file_browser = {
        hijack_netrw = true,
      },
    },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("file_browser")
  end,
}
