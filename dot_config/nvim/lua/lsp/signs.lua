local Signs = {}

print("define diagnostic signs")

-- Global flag to ensure diagnostic config is only set once
local diagnostic_config_set = false

function Signs.define_diagnostic_signs(opts)
  -- Only configure diagnostics once globally
  if diagnostic_config_set then
    return
  end
  
  local diag_sign_prefix = "DiagnosticSign"

  local default_diagnostic = {
    float = {
      border = "rounded",
    },
    underline = false,
    -- virtual_text = { spacing = 2, prefix = "●" },
    virtual_text = false,
    update_in_insert = false,
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = "󱩎 ",
        [vim.diagnostic.severity.INFO] = " ",
      },
      linehl = {
        --[vim.diagnostic.severity.ERROR] = diag_sign_prefix .. "Error",
        --[vim.diagnostic.severity.WARN] = diag_sign_prefix .. "Warn",
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = diag_sign_prefix .. "Error",
        [vim.diagnostic.severity.WARN] = diag_sign_prefix .. "Warn",
        [vim.diagnostic.severity.HINT] = diag_sign_prefix .. "Hint",
        [vim.diagnostic.severity.INFO] = diag_sign_prefix .. "Info",
      },
    },
  }
  vim.diagnostic.config(vim.tbl_deep_extend("force", default_diagnostic, opts or {}))
  diagnostic_config_set = true
end

return Signs