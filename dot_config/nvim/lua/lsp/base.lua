local mason_registry = require("mason-registry")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

local _cached_tools
local _modules = {}

local LSPBase = {}
LSPBase.__index = LSPBase

function LSPBase:new(fields)
  return setmetatable(fields or {}, self)
end

function LSPBase.lazy_require(name)
  if not _modules[name] then
    _modules[name] = require(name)
  end
  return _modules[name]
end

function LSPBase:map(lhs, rhs, opts)
  opts = opts or {}
  vim.keymap.set(opts.mode or "n", lhs, type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs, {
    silent = true,
    buffer = self.buffer,
    expr = opts.expr,
    desc = opts.desc,
    noremap = opts.noremap,
  })
end

-- lua =vim.lsp.get_clients()[1].server_capabilities
function LSPBase:has(caps)
  for _, cap in ipairs(caps) do
    if not self.client.server_capabilities[cap .. "Provider"] then
      return false
    end
  end
  return true
end

function LSPBase.get_lsp_capabilities()
  return require("blink.cmp").get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities()
end

function LSPBase.get_config_data(key, return_keys)
  local configs = LSPBase._configs
  local result = return_keys and {} or {}

  for _, cfg in pairs(configs or {}) do
    if cfg[key] then
      for name, value in pairs(cfg[key]) do
        if return_keys then
          table.insert(result, name)
        else
          result[name] = value
        end
        break
      end
    end
  end

  return result
end

function LSPBase.read_configs(cfg_dir)
  local result = {}

  for _, file in ipairs(vim.fn.readdir(cfg_dir)) do
    if file:match("%.lua$") then
      local name = file:gsub("%.lua$", "")
      result[name] = require("lsp.configs." .. name)
    end
  end

  LSPBase.set_configs(result) -- set + clear cache
  return result
end

function LSPBase.set_configs(configs)
  LSPBase._configs = configs
  _cached_tools = nil
end

function LSPBase.get_configs()
  return LSPBase._configs
end

function LSPBase:get_config(key)
  if not self._configs then
    vim.notify("[lsp.base] No configs loaded", vim.log.levels.WARN)
    return {}
  end

  local result = {}

  for _, config in pairs(self._configs) do
    if config[key] then
      for ft, tools in pairs(config[key]) do
        result[ft] = tools
      end
    end
  end

  return result
end

function LSPBase.safe_get_config(key, opts)
  opts = opts or {}
  local title = opts.title or ("LSP " .. key:gsub("^%l", string.upper))
  local subkey = opts.subkey -- filetype, linter name, etc.
  local warn_if_empty = opts.warn_if_empty ~= false -- default true

  local ok, config = pcall(LSPBase.get_config, LSPBase, key)
  if not ok or type(config) ~= "table" then
    vim.schedule(function()
      vim.notify("Failed to retrieve config: " .. key, vim.log.levels.ERROR, { title = title })
    end)
    return {}
  end

  if subkey then
    local section = config[subkey]
    if warn_if_empty and (not section or vim.tbl_isempty(section)) then
      vim.schedule(function()
        vim.notify("No config found for " .. key .. ": " .. subkey, vim.log.levels.WARN, { title = title })
      end)
    end
    return { [subkey] = section or {} }
  end

  return config
end

function LSPBase.reload_configs()
  LSPBase._configs = LSPBase.read_configs(LSPBase._config_dir)
  _cached_tools = nil
end

function LSPBase.extract_lsp_servers(configs)
  local result = {}
  local seen = {}

  for _, cfg in pairs(configs) do
    if cfg.lsp then
      for server_name, _ in pairs(cfg.lsp) do
        if not seen[server_name] then
          seen[server_name] = true
          table.insert(result, server_name)
        end
      end
    end
  end

  return result
end

function LSPBase.ensure_installed()
  local tools = LSPBase.get_all_tools()

  local all = {}
  local seen = {}

  for type, list in pairs(tools) do
    if type ~= "lsp" then
      for _, tool in ipairs(list) do
        if not seen[tool] then
          table.insert(all, tool)
          seen[tool] = true
        end
      end
    end
  end

  for _, tool in ipairs(all) do
    if mason_registry.has_package(tool) then
      if not mason_registry.is_installed(tool) then
        local package = mason_registry.get_package(tool)
        vim.notify("[Mason] Installing: " .. tool)
        package:install()
      end
    else
      vim.notify("[Mason] Tool not found in registry: " .. tool, vim.log.levels.WARN)
    end
  end

  mason_lspconfig.setup({
    ensure_installed = tools.lsp,
    automatic_enable = true,
    automatic_installation = true,
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local lsps = LSPBase.get_config_data("lsp", false)
  for server, config in pairs(lsps) do
    config.capabilities =
      require("blink.cmp").get_lsp_capabilities(vim.tbl_deep_extend("force", capabilities, config.capabilities or {}))
    lspconfig[server].setup(config)
  end
end

function LSPBase.get_all_tools()
  if _cached_tools then
    return _cached_tools
  end

  local tools = {
    lsp = {},
    format = {},
    lint = {},
  }

  local seen = {
    lsp = {},
    format = {},
    lint = {},
  }

  for _, cfg in pairs(LSPBase._configs or {}) do
    -- LSP servers
    for server, _ in pairs(cfg.lsp or {}) do
      if not seen.lsp[server] then
        table.insert(tools.lsp, server)
        seen.lsp[server] = true
      end
    end

    -- Formatters
    for _, formatters in pairs(cfg.format or {}) do
      for _, tool in ipairs(formatters) do
        if not seen.format[tool] then
          table.insert(tools.format, tool)
          seen.format[tool] = true
        end
      end
    end

    -- Linters
    for _, linters in pairs(cfg.lint or {}) do
      for _, tool in ipairs(linters) do
        if not seen.lint[tool] then
          table.insert(tools.lint, tool)
          seen.lint[tool] = true
        end
      end
    end
  end

  _cached_tools = tools
  return tools
end

function LSPBase.on_attach(callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      callback(client, bufnr)
    end,
  })
end

function LSPBase.attach_lazy_modules(client, bufnr, module_names)
  for _, name in ipairs(module_names) do
    local mod = LSPBase.lazy_require(name)
    local ok, instance = pcall(mod.new, mod, client, bufnr)
    if ok and instance.on_attach then
      instance:on_attach()
    else
      vim.notify("Failed to attach " .. name, vim.log.levels.WARN)
    end
  end
end

return LSPBase
