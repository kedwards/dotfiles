return {
  "linrongbin16/gitlinker.nvim",
  cmd = "GitLink",
  opts = {},
  keys = {
    { "<leader>gy", "<cmd>GitLink<cr>",                 mode = { "n", "v" }, desc = "Yank git permalink" },
    { "<leader>gY", "<cmd>GitLink!<cr>",                mode = { "n", "v" }, desc = "Open git permalink" },
    { "<leader>gb", "<cmd>GitLink blame<cr>",           mode = { "n", "v" }, desc = "Yank git blame" },
    { "<leader>gB", "<cmd>GitLink! blame<cr>",          mode = { "n", "v" }, desc = "Open git blame link" },
    { "<leader>gc", "<cmd>GitLink current_branch<cr>",  mode = { "n", "v" }, desc = "Copy current branch link" },
    { "<leader>gC", "<cmd>GitLink! current_branch<cr>", mode = { "n", "v" }, desc = "Open current branch link" },
    { "<leader>gd", "<cmd>GitLink default_branch<cr>",  mode = { "n", "v" }, desc = "Copy default branch link" },
    { "<leader>gD", "<cmd>GitLink! default_branch<cr>", mode = { "n", "v" }, desc = "Open default branch link" },
  },
}
