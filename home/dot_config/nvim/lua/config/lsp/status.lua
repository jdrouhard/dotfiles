local lsp_util = require('vim.lsp.util')

local spinner_frames = {'⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'}
local index = 0
local au_group = nil
local status_timer = nil
local progress_cache = nil
local requests_cache = nil
local active_requests = {}
local debouncing_requests = {}

local ignore_methods = {'documentHighlight', 'semanticTokens', 'codeAction'}

local M = {}

local function update_timer()
  local need_timer = not (vim.tbl_isempty(progress_cache or {}) and vim.tbl_isempty(requests_cache or {}))
  if status_timer == nil and need_timer then
    status_timer = vim.loop.new_timer()
    status_timer:start(100, 100, vim.schedule_wrap(function()
      index = (index + 1) % #spinner_frames
    end))
  elseif status_timer ~= nil and not need_timer then
    status_timer:close()
    status_timer = nil
  end
end

function M.invalidate_requests()
    requests_cache = nil
    update_timer()
end

function M.update_progress()
  local lsp_messages = lsp_util.get_progress_messages()
  local msgs = {}
  for _, msg in ipairs(lsp_messages) do
    local name = msg.name
    if msg.progress then
      local contents = { msg.title }
      if msg.message then
        contents[#contents + 1] = msg.message
      end

      if msg.percentage and msg.percentage > 0 then
        contents[#contents + 1] = '(' .. math.ceil(msg.percentage) .. '%%)'
      end

      if msg.done then
        vim.defer_fn(M.update_progress, 500)
      end

      msgs[name] = table.concat(contents, ' ')
    else
      msgs[name] = msg.content
    end
  end
  progress_cache = msgs
  update_timer()
end

function M.update_requests()
  requests_cache = {}
  local bufnr = vim.api.nvim_get_current_buf()
  for _, client in ipairs(vim.lsp.buf_get_clients()) do
    local name = client.name
    local result = {}
    local ids = {}
    for id, request in pairs(client.requests or {}) do
      if request.bufnr == bufnr then
        ids[#ids + 1] = id
        if not active_requests[id] and not debouncing_requests[id] then
          debouncing_requests[id] = vim.defer_fn(function()
            active_requests[id] = request
            debouncing_requests[id] = nil
            M.update_requests()
          end, 100)
        end
      end
    end
    for id, timer in pairs(debouncing_requests) do
      if not vim.tbl_contains(ids, id) then
        vim.schedule_wrap(function()
          timer:stop()
          timer:close()
          debouncing_requests[id] = nil
        end)
      end
    end
    local request_set = {
      pending = {},
      cancel = {},
    }
    for id, request in pairs(active_requests) do
      local type = request.type
      local method = request.method
      if not vim.tbl_contains(ids, id) then
        active_requests[id] = nil
      elseif not request_set[type][method] then
        request_set[type][method] = true
        local ignore = false
        for _, i in ipairs(ignore_methods) do
          if method:find(i) then
            ignore = true
            break
          end
        end

        if not ignore then
          result[#result + 1] = string.format("%s %s", type == 'pending' and 'requesting' or 'cancelling', string.sub(method, string.find(method, '/')+1))
        end
      end
    end
    if not vim.tbl_isempty(result) then
      requests_cache[name] = string.format('[%s]', table.concat(result, ', '))
    end
  end
  update_timer()
end

local function get_progress()
  if not progress_cache then
    M.update_progress()
  end
  return progress_cache or {}
end

local function get_requests()
  if not requests_cache then
    M.update_requests()
  end
  return requests_cache or {}
end

local function get_status()
  local msgs = {}
  for _, client in ipairs(vim.lsp.get_active_clients({bufnr = 0})) do
    local name = client.name
    local status = client.status
    if status then
      local uri = vim.uri_from_bufnr(0)
      if status[uri] then
        msgs[name] = status[uri]
      end
    end
  end
  return msgs
end

function M.statusline()
  if #vim.lsp.get_active_clients({ bufnr = 0 }) == 0 then
    return ''
  end

  local msgs = {}
  local function extend(section, add_spinner)
    for name, contents in pairs(section) do
      if not msgs[name] then
        msgs[name] = {}
      end
      local client_msgs = msgs[name]
      if add_spinner then
        client_msgs[#client_msgs + 1] = spinner_frames[index + 1]
      end
      client_msgs[#client_msgs + 1] = contents
    end
  end
  extend(get_requests(), true)
  extend(get_status())
  extend(get_progress(), true)

  return msgs
end

function M.on_attach()
  vim.api.nvim_create_autocmd('BufLeave', {
    group = au_group,
    callback = function() M.invalidate_requests() end,
    buffer = 0,
    desc = 'lsp_status.invalidate_requests',
  })
end

function M.setup(enable_progress)
  au_group = vim.api.nvim_create_augroup('lsp_status', {})
  vim.api.nvim_create_autocmd('User', {
    group = au_group,
    pattern = 'LspRequest',
    callback = function() M.update_requests() end,
    desc = 'lsp_status.update_requests',
  })
  if enable_progress then
    vim.api.nvim_create_autocmd('User', {
      group = au_group,
      pattern = 'LspProgressUpdate',
      callback = function() M.update_progress() end,
      desc = 'lsp_status.update_progress',
    })
  end
end

return M
