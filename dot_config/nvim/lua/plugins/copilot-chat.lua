return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "zbirenbaum/copilot.lua" },
    { "nvim-lua/plenary.nvim", branch = "master" },
  },
  build = "make tiktoken",
  config = function()
    local select = require("CopilotChat.select")
    local chat = require("CopilotChat")
    local wk = require("which-key")

    require("which-key").add({
      { mode = { "n", "v" }, "<leader>a", icon = copilot, desc = "CopilotChat" },
    })

    local opts = {
      debug = true,
      auto_follow_cursor = false,
    }

    chat.setup(opts)

    wk.add({
      {
        mode = { "n", "v" },
        {
          { "<leader>aa", "<cmd>CopilotChatToggle<cr>", desc = "Toggle chat window" },
          { "<leader>ad", "<cmd>CopilotChatDocs<cr>", desc = "Create documentation" },
          { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "Explain code" },
          { "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "Fix code" },
          { "<leader>am", "<cmd>CopilotChatCommit<cr>", desc = "Generate commit message" },
          { "<leader>ap", "<cmd>CopilotChatPrompt<cr>", desc = "Prompt actions" },
          { "<leader>ao", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize code" },
          { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "Review code" },
          { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "Refactor code" },
          { "<leader>as", "<cmd>CopilotChatStop<cr>", desc = "Stop current output" },
          { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "Generate tests" },
          { "<leader>ax", "<cmd>CopilotChatReset<cr>", desc = "Reset chat window" },
          { "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "Select Models" },
        },
      },
      {
        "<leader>ai",
        function()
          local input = vim.fn.input("Ask Copilot: ")
          if input ~= "" then
            vim.cmd("CopilotChat " .. input)
          end
        end,
        desc = "Ask input",
      },
    })
  end,
}
