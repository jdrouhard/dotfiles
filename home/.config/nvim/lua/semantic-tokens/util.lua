local M = {}

M.format_hl_name = function(prefix, ...)
  local result = prefix
  for i, piece in ipairs({...}) do
    result = result .. piece:gsub('^%l', string.upper)
  end
  return result
end

M.highlight_exists = function(name)
  if not name then return false end

  local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
  return ok and not (hl or {})[true]
end

return M
