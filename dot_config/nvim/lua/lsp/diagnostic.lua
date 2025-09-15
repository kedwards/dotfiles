local Base = require("lsp.base")
local Sign = require("lsp.signs")

print("Attaching diagnostics")

local Diagnostic = {}
Diagnostic.__index = Diagnostic
setmetatable(Diagnostic, { __index = Base })

function Diagnostic:new(client, buffer)
  return setmetatable({ client = client, buffer = buffer }, Diagnostic)
end

function Diagnostic:on_attach()
  vim.diagnostic.enable(true, { buffer = self.buffer })

  self:map("]d", self.diagnostic_goto(1), { desc = "Next Diagnostic" })
  self:map("[d", self.diagnostic_goto(-1), { desc = "Prev Diagnostic" })
  self:map("]e", self.diagnostic_goto(1, vim.diagnostic.severity.ERROR), { desc = "Next Error" })
  self:map("[e", self.diagnostic_goto(-1, vim.diagnostic.severity.ERROR), { desc = "Prev Error" })
  self:map("]w", self.diagnostic_goto(1, vim.diagnostic.severity.WARN), { desc = "Next Warning" })
  self:map("[w", self.diagnostic_goto(-1, vim.diagnostic.severity.WARN), { desc = "Prev Warning" })

  self:map("K", vim.lsp.buf.hover, { desc = "Hover" })
  self:map("gK", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })

  self:map("<leader>la", vim.lsp.buf.code_action, {
    desc = "Code Action", mode = { "n", "v" }, has = "codeAction"
  })

  self:map("<leader>lr", vim.lsp.buf.rename, { expr = true, desc = "Rename", has = "rename" })

  self:map("<leader>ld", function()
    local enabled = vim.diagnostic.is_enabled({ buffer = self.buffer })
    vim.diagnostic.enable(not enabled, { buffer = self.buffer })
  end, { desc = "Toggle diagnostics" })

  Sign.define_diagnostic_signs()
end

function Diagnostic:map(lhs, rhs, opts)
  opts = opts or {}
  if opts.has and not self:has(type(opts.has) == "table" and opts.has or { opts.has }) then
    return
  end

  Base.map(self, lhs, rhs, opts)
end

function Diagnostic:has(caps)
  for _, cap in ipairs(caps) do
    if not self.client.server_capabilities[cap .. "Provider"] then
      return false
    end
  end
  return true
end

function Diagnostic.diagnostic_goto(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump({ count = next, forward = next, severity = severity, float = false })
  end
end

function Diagnostic:toggle()
  self.diagnostic = not self.diagnostic

  if self.diagnostic then
    vim.diagnostic.enable(true)
    vim.notify("[LSP] Diagnostics enabled", vim.log.levels.INFO)
  else
    vim.diagnostic.enable(false)
    vim.notify("[LSP] Diagnostics disabled", vim.log.levels.INFO)
  end
end

return Diagnostic
