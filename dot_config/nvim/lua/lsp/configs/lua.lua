return {
  dap = {},
  format = {
    lua = { "stylua" },
  },
  lint = {
    lua = { "selene" },
  },
  -- luadev.nvim provides this functionality
  -- lsp = {
  --   lua_ls = {
  --     settings = {
  --       Lua = {
  --         runtime = {
  --           version = "LuaJIT",
  --           path = vim.split(package.path, ";"),
  --         },
  --         diagnostics = {
  --           globals = { "vim" },
  --         },
  --         workspace = {
  --           library = {
  --             vim.env.VIMRUNTIME,
  --             "${3rd}/luv/library",
  --           },
  --           checkThirdParty = false,
  --         },
  --         telemetry = {
  --           enable = false,
  --         },
  --       },
  --     },
  --   },
  -- },
}
