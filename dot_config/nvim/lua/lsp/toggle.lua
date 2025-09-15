local Toggle = {
  state = {
    -- structure:
    -- lint = { _enabled_bufs = {}, _enabled_fts = {} }
    -- format = { _enabled_bufs = {}, _enabled_fts = {} }
  },
}

local function ensure_namespace(feature)
  if not Toggle.state[feature] then
    Toggle.state[feature] = {
      _enabled_bufs = {},
      _enabled_fts = {},
    }
  end
end

function Toggle.is_enabled(feature, bufnr)
  ensure_namespace(feature)
  bufnr = bufnr or 0
  local ft = vim.bo[bufnr].filetype
  local state = Toggle.state[feature]
  return state._enabled_bufs[bufnr] ~= false and state._enabled_fts[ft] ~= false
end

function Toggle.enable(feature, kind, id)
  ensure_namespace(feature)
  local state = Toggle.state[feature]
  if kind == "ft" then
    state._enabled_fts[id] = true
  else
    state._enabled_bufs[tonumber(id) or 0] = true
  end
end

function Toggle.disable(feature, kind, id)
  ensure_namespace(feature)
  local state = Toggle.state[feature]
  if kind == "ft" then
    state._enabled_fts[id] = false
  else
    state._enabled_bufs[tonumber(id) or 0] = false
  end
end

function Toggle.toggle(feature, kind, id)
  ensure_namespace(feature)
  local key = kind == "ft" and id or tonumber(id) or 0
  local is_ft = kind == "ft"
  local enabled = Toggle.is_enabled(feature, is_ft and 0 or key)

  if enabled then
    Toggle.disable(feature, kind, key)
  else
    Toggle.enable(feature, kind, key)
  end

  return not enabled
end

function Toggle.notify(feature, kind, id, enabled)
  local msg = string.format("%s %s for %s - %s",
    feature:gsub("^%l", string.upper),                    -- Capitalize feature name
    enabled and "enabled" or "disabled",
    kind == "ft" and id or "buffer " .. id,
    enabled and "✓" or "✗"
  )
  vim.notify(msg, vim.log.levels.INFO, { title = "LSP " .. feature:gsub("^%l", string.upper) })
end

return Toggle