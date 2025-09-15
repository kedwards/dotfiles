-- Prepend mise shims to PATH first, before loading other modules
-- vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

for _, source in ipairs({
  "config",
  "Lazy",
}) do
  local status_ok, fault = pcall(require, source)
  if not status_ok then
    vim.notify("Failed to load " .. source .. "\n\n" .. fault)
  end
end
