local Base = require("lsp.base")
local lint = require("lint")
local Toggle = require("lsp.toggle")

local Lint = {}
Lint.__index = Lint
setmetatable(Lint, { __index = Base })

function Lint:new(client, buffer)
  local obj = setmetatable({ client = client, buffer = buffer }, Lint)
  lint.linters_by_ft = obj:get_linters_by_ft()
  return obj
end

function Lint:on_attach()
  local buffer = self.buffer
  if not vim.api.nvim_buf_is_valid(buffer) then return end

  vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost", "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("LspLint." .. buffer, { clear = true }),
    buffer = buffer,
    callback = function()
      self:lint()
    end,
  })

  -- Keymaps
  self:map("<leader>ll", function() self:lint() end, { expr = true, desc = "Lint Document" })

  -- self:map("<leader>X", function()
  --   local result = Toggle.toggle("lint", "buf", buffer)
  --   Toggle.notify("lint", "buf", buffer, result)
  -- end, { desc = "Toggle Linting for Buffer" })
  --
  -- self:map("<leader>X", function()
  --   local ft = vim.bo.filetype
  --   local result = Toggle.toggle("lint", "ft", ft)
  --   Toggle.notify("lint", "ft", ft, result)
  -- end, { desc = "Toggle Linting for Filetype" })

  vim.api.nvim_create_user_command("LintToggle", function()
    local result = Toggle.toggle("lint", "buf", buffer)
    Toggle.notify("lint", "buf", buffer, result)
  end, {})

  vim.api.nvim_create_user_command("LintToggleFT", function()
    local ft = vim.bo.filetype
    local result = Toggle.toggle("lint", "ft", ft)
    Toggle.notify("lint", "ft", ft, result)
  end, {})
end

function Lint:lint()
  if not Toggle.is_enabled("lint", self.buffer) then
    self:notify("Linting is disabled", vim.log.levels.INFO, { title = "LSP Lint" })
    return
  end

  lint.try_lint(nil, { bufnr = self.buffer })
end

function Lint:get_linters_by_ft()
  -- Load config
  local config = Base.safe_get_config("lint", {
    title = "LSP Lint",
  })

  return config
end

return Lint
