return {
  "lewis6991/gitsigns.nvim",
  event = "BufEnter",
  cmd = "GitSigns",
  config = function()
    require("gitsigns").setup({
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gitsigns.nav_hunk('next')
          end
        end)

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- Actions
        map('n', '<leader>ss', gitsigns.stage_hunk, { desc = "Stage hunk" })
        map('n', '<leader>sr', gitsigns.reset_hunk, { desc = "Reset hunk" })

        map('v', '<leader>ss', function()
          gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = "Stage visual hunk" })

        map('v', '<leader>sr', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = "Reset visual hunk" })

        map('n', '<leader>sS', gitsigns.stage_buffer, { desc = "Stage buffer" })
        map('n', '<leader>sR', gitsigns.reset_buffer, { desc = "Reset buffer" })
        map('n', '<leader>sp', gitsigns.preview_hunk, { desc = "Preview hunk" })
        map('n', '<leader>si', gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

        map('n', '<leader>sb', function()
          gitsigns.blame_line({ full = true })
        end, { desc = "Blame line" })

        map('n', '<leader>sd', gitsigns.diffthis, { desc = "Diff this" })

        map('n', '<leader>sD', function()
          gitsigns.diffthis('~')
        end, { desc = "Diff all" })

        map('n', '<leader>sQ', function() gitsigns.setqflist('all') end, { desc = "Send all to qickfix" })
        map('n', '<leader>sq', gitsigns.setqflist, { desc = "Send to qickfix" })

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
        map('n', '<leader>td', gitsigns.toggle_deleted, { desc = "Toggle deleted" })
        map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = "Toggle word diff" })

        -- Text object
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = "Select hunk via textobject" })
      end
    })
  end
}
