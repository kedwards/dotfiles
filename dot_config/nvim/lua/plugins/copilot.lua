return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    filetypes = {
      go = true,
      help = true,
      html = true,
      javascript = true,
      lua = true,
      markdown = true,
      python = true,
      sh = true,
      yaml = true,
      ["*"] = false,
    },
    suggestion = { enabled = false },
    panel = { enabled = false },
  },
}
