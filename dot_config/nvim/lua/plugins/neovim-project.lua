return {
  "kedwards/neovim-project",
  -- dir = "~/dev/neovim-project/worktree",
  opts = {
    projects = { -- define project roots
      "~/dev/*",
      "~/.config/*",
    },
    picker = {
      type = "telescope",
    }
  },
  init = function()
    -- enable saving the state of plugins in the session
    -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    vim.opt.sessionoptions:append("globals") 
  end,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
    { "Shatur/neovim-session-manager" },
    { "ThePrimeagen/git-worktree.nvim" },
  },
  lazy = false,
  priority = 100,
  keys = {
    { "<leader>Pd", "<cmd>NeovimProjectDiscover<cr>",                     mode = { "n", "v" }, desc = "Find a project based on patterns" },
    { "<leader>Pa", "<cmd>NeovimProjectDiscover alphabetical_name<cr>",   mode = { "n", "v" }, desc = "Find a project based on name" },
    { "<leader>Ph", "<cmd>NeovimProjectHistory<cr>",                      mode = { "n", "v" }, desc = "Select a project from history" },
    { "<leader>Pr", "<cmd>NeovimProjectLoadRecent<cr>",                   mode = { "n", "v" }, desc = "Open the prvious project session" },
  }
}
