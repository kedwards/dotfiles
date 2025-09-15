return {
  "monkoose/neocodeium",
  dependencies = {
    -- 'saghen/blink.cmp',
  },
  event = "VeryLazy",
  config = function()
    local neocodeium = require("neocodeium")
    -- local blink = require('blink.cmp')

    vim.keymap.set("i", "<A-g>", neocodeium.accept)
    vim.keymap.set("i", "<A-w>", neocodeium.accept_word)
    vim.keymap.set("i", "<A-a>", neocodeium.accept_line)
    vim.keymap.set("i", "<A-e>", neocodeium.cycle_or_complete)
    vim.keymap.set("i", "<A-c>", neocodeium.clear)

    -- vim.api.nvim_create_autocmd("User", {
    --   pattern = "BlinkCmpMenuOpen",
    --   callback = function()
    --     neocodeium.clear()
    --   end,
    -- })
    --
    -- neocodeium.setup({
    --   filter = function()
    --     return not blink.is_visible()
    --   end,
    -- })
    neocodeium.setup({
      manual = true, -- recommended to not conflict with nvim-cmp
    })

    -- create an autocommand which closes cmp when ai completions are displayed
    vim.api.nvim_create_autocmd("User", {
      pattern = "NeoCodeiumCompletionDisplayed",
      callback = function()
        require("cmp").abort()
      end,
    })
  end,
}
