return {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  opts = {},
  -- opts = {
  --   PATH = "prepend", -- prepend Mason bin directory to PATH
  --   pip = {
  --     upgrade_pip = true,
  --   },
  --   log_level = vim.log.levels.INFO,
  --   max_concurrent_installers = 4,
  -- },
  -- config = function(_, opts)
  --   require("mason").setup(opts)
  --
  --   -- Ensure mise shims are in PATH for Mason
  --   local mise_shims = vim.env.HOME .. "/.local/share/mise/shims"
  --   if not vim.env.PATH:find(mise_shims, 1, true) then
  --     vim.env.PATH = mise_shims .. ":" .. vim.env.PATH
  --   end
  --
  --   -- Setup mason-lspconfig after mason
  --   -- Skip gopls since it's installed via mise
  --   require("mason-lspconfig").setup({
  --     automatic_installation = false, -- disable automatic installation
  --     ensure_installed = {}, -- don't automatically install anything
  --   })
  -- end,
}
