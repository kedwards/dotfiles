return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require('mini.ai').setup({})
    require('mini.surround').setup({})
    -- require('mini.files').setup({})
    -- require('mini.operator').setup({})
    require('mini.comment').setup({})
    -- require('mini.bracketed').setup({})
    -- require('mini.jump').setup({})
    -- require('mini.pairs').setup({})
    -- require('mini.pick').setup({})
  end,
  keys = {
    { '<leader>mf', function() if not MiniFiles.close() then MiniFiles.open() end end, desc = 'mini files toggle' },
  },
}