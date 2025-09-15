return {
  dap = {},
  format = {
    go = { "goimports" },
  },
  lint = {
    go = { "revive" },
  },
  lsp = {
    gopls = {
      settings = {
        gopls = {
          experimentalPostfixCompletions = true,
          analyses = {
            unusedparams = true,
            shadow = true,
          },
          staticcheck = true,
        },
      },
    },
  },
}
