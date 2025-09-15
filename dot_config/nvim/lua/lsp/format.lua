local Base = require("lsp.base")
local conform = require("conform")
local Toggle = require("lsp.toggle")

local Format = {}
Format.__index = Format
setmetatable(Format, { __index = Base })

function Format:new(client, buffer)
  local obj = setmetatable({ client = client, buffer = buffer }, Format)
  conform.formatters_by_ft = obj:get_formatters_by_ft()
  return obj
end

function Format:on_attach()
  local buffer = self.buffer
  if not vim.api.nvim_buf_is_valid(buffer) then return end

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormat." .. buffer, { clear = true }),
    buffer = buffer,
    callback = function()
      self:format()
    end,
  })

  self:map("<leader>lf", function()
    self:format()
  end, { desc = "Format Document" })

  -- self:map("<leader>X", function()
  --   local result = Toggle.toggle("format", "buf", buffer)
  --   Toggle.notify("format", "buf", buffer, result)
  -- end, { desc = "Toggle formatting for Buffer" })
  --
  -- self:map("<leader>X", function()
  --   local ft = vim.bo.filetype
  --   local result = Toggle.toggle("format", "ft", ft)
  --   Toggle.notify("format", "ft", ft, result)
  -- end, { desc = "Toggle formatting for Filetype" })

  vim.api.nvim_create_user_command("FormatToggle", function()
    local result = Toggle.toggle("format", "buf", buffer)
    Toggle.notify("format", "buf", buffer, result)
  end, {})

  vim.api.nvim_create_user_command("FormatToggleFT", function()
    local ft = vim.bo[buffer].filetype
    local result = Toggle.toggle("format", "ft", ft)
    Toggle.notify("format", "ft", ft, result)
  end, {})
end

function Format:format()
  if not Toggle.is_enabled("format", self.buffer) then
    vim.notify("Formatting is disabled", vim.log.levels.INFO, { title = "LSP Format" })
    return
  end

  conform.format({ bufnr = self.buffer, async = false })
end

function Format:get_formatters_by_ft()
  -- Load config
  local config = Base.safe_get_config("format", {
    title = "LSP Format",
  })
   
  return config
end

return Format
