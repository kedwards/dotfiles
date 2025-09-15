return {
  "ThePrimeagen/git-worktree.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  opts = {},
  keys = {
    {
      "<leader>gwm",
      function()
        require("telescope").extensions.git_worktree.git_worktrees()
      end,
      desc = "Manage",
    },
    {
      "<leader>gwc",
      function()
        require("telescope").extensions.git_worktree.create_git_worktree()
      end,
      desc = "Create",
    },
  },
}
