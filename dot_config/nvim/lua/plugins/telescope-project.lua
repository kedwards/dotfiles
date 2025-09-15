return {
  "nvim-telescope/telescope-project.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "ThePrimeagen/git-worktree.nvim",
  },
  keys = {
    {
      "<leader>p",
      "<cmd>Telescope project<cr>",
      desc = "Project browser",
    },
  },
  config = function()
    local telescope = require("telescope")

    local find = function(prompt_bufnr)
      local actions = require("telescope.actions")
      local actions_state = require("telescope.actions.state")
      local _utils = require("telescope._extensions.project.utils")
      local builtin = require("telescope.builtin")

      actions.close(prompt_bufnr)

      local inside_work_tree = {}

      local project_path = actions_state.get_selected_entry().value
        
      print("Directory: " .. vim.inspect(project_path))

      local cd_successful = _utils.change_project_dir(project_path, "lcd")

      if cd_successful then
        local cwd = vim.fn.getcwd()
        if inside_work_tree[cwd] == nil then
          vim.fn.system("git rev-parse --is-inside-work-tree")
          inside_work_tree[cwd] = vim.v.shell_error == 0
        end

        if inside_work_tree[cwd] then
          vim.schedule(function()
            telescope.extensions.git_worktree.git_worktrees()
          end)
        else
          vim.schedule(function()
            builtin.find_files({ cwd = project_path })
          end)
        end
      end
    end

    telescope.setup({
      extensions = {
        project = {
          on_project_selected = find,
        },
      },
    })

    telescope.load_extension("project")
  end,
}
