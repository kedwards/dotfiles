return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'AndreM222/copilot-lualine',
  },
  config = function()
    local lazy_status = require("lazy.status")
    local devicons = require("nvim-web-devicons")

    local lsp_active = function()
      local lsps = vim.lsp.get_clients({ bufnr = vim.fn.bufnr() })
      local icon = devicons.get_icon_by_filetype(
        vim.bo.filetype
      )

      if lsps and #lsps > 0 then
        local names = {}
        for _, lsp in ipairs(lsps) do
          table.insert(names, lsp.name)
        end
        return string.format("%s", icon)
        -- return string.format("%s %s", table.concat(names, ", "), icon)
        -- return string.format("%s", table.concat(names, ", "))
      else
        return icon or ""
      end
    end

    local lsp_color = function()
      local _, color = devicons.get_icon_cterm_color_by_filetype(vim.bo.filetype)
      return { fg = color }
    end

    local opts = {
      options = {
        theme = "onedark",
      },
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = function(str) return str:sub(1, 1) end,
          },
        },
        lualine_b = { 'branch', 'diff',
          {
            'diagnostics',
            sources = { "nvim_diagnostic" },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' }
          },
          {
            lsp_active,
            color = lsp_color,
          },
        },
        lualine_c = {
          'copilot',
          'filename',
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          'encoding',
          'fileformat',
          'filetype'
        }
      }
    }
    require("lualine").setup(opts)
  end
}
