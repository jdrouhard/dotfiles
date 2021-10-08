local lsp_util = require('vim.lsp.util')
local utils = require('utils')
local autocmd = utils.autocmd

local spinner_frames = {'⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'}
local index = 0
local status_timer = nil
local progress_cache = nil
local requests_cache = nil
local active_requests = {}
local debouncing_requests = {}

local M = {}

local function update_timer()
  local need_timer = not (vim.tbl_isempty(progress_cache or {}) and vim.tbl_isempty(requests_cache or {}))
  if status_timer == nil and need_timer then
    status_timer = vim.loop.new_timer()
    status_timer:start(100, 100, vim.schedule_wrap(function()
      index = (index + 1) % #spinner_frames
      vim.api.nvim_command('redrawstatus')
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
    for id, method in pairs(client.active_requests[bufnr] or {}) do
      ids[#ids + 1] = id
      if not active_requests[id] and not debouncing_requests[id] then
        debouncing_requests[id] = vim.defer_fn(function()
          active_requests[id] = method
          debouncing_requests[id] = nil
          M.update_requests()
        end, 100)
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
    local request_set = {}
    for id, method in pairs(active_requests) do
      if not vim.tbl_contains(ids, id) then
        active_requests[id] = nil
      elseif not request_set[method] then
        request_set[method] = true
        if not method:find('documentHighlight') then
          result[#result + 1] = string.format("requesting %s", string.sub(method, string.find(method, '/')+1))
        end
      end
    end
    for _, method in pairs(client.cancel_requests[bufnr] or {}) do
      if not request_set[method] then
        request_set[method] = true
        if not method:find('documentHighlight') then
          result[#result + 1] = string.format("cancelling %s", string.sub(method, string.find(method, '/')+1))
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
  for _, client in ipairs(vim.lsp.buf_get_clients()) do
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
  if #vim.lsp.buf_get_clients() == 0 then
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

  local result = {}

  for name, msgs in pairs(msgs) do
    result[#result + 1] = string.format("%s: %s", name, table.concat(msgs, ' '))
  end

  return table.concat(result, '; ')
end

function M.on_attach()
  autocmd('lsp_status', {
    [[User LspRequestChange <buffer> lua require('lsp_status').update_requests()]],
    [[User LspProgressUpdate <buffer> lua require('lsp_status').update_progress()]],
    [[BufLeave <buffer> lua require('lsp_status').invalidate_requests()]],
  })
end

return M
