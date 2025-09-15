local mason = require("mason")
local Base = require("lsp.base")
local script_path = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
local config_directory = script_path .. "configs"

Base.read_configs(config_directory)
mason.setup()
Base.ensure_installed()
Base.on_attach(function(client, bufnr)
  Base.attach_lazy_modules(client, bufnr, {
    -- "lsp.diagnostic",
    "lsp.lint",
    "lsp.format",
  })
end)
