return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ignore_install = {},
      modules = {},
      auto_install = true,
      ensure_installed = {
        "bash",
        "diff",
        "dockerfile",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "python",
        "regex",
        "sql",
        "vim",
        "vimdoc",
        "yaml",
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
