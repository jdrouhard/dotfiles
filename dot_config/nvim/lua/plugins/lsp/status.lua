local api = vim.api

local status_timer = vim.loop.new_timer()
local spinner_frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
local index = 0
local progress_cache = {}
local requests_cache = {}
local progress_state = {}
local request_state = vim.defaulttable()

local ignore_methods = {
  'documentHighlight',
  'semanticTokens',
  'codeAction',
  'documentSymbol'
}

local M = {}

local function update_timer()
  local need_timer = not vim.tbl_isempty(progress_cache) or not vim.tbl_isempty(requests_cache)

  if need_timer then
    status_timer:start(100, 100, vim.schedule_wrap(function()
      index = (index + 1) % #spinner_frames
      vim.cmd.redrawstatus({ bang = true })
    end))
  elseif status_timer:is_active() then
    status_timer:stop()
    vim.cmd.redrawstatus({ bang = true })
  end
end

local function invalidate_progress()
  progress_cache = {}
  update_timer()
end

local function invalidate_requests(bufnr)
  requests_cache[bufnr] = {}
  update_timer()
end

local function update_progress(progress_event)
  local data = progress_event.data
  local client_id = data.client_id
  local progress = data.params or data.result
  local value = progress.value
  local token = progress.token

  local state = progress_state[client_id]
  if not state then
    state = {}
    progress_state[client_id] = state
  end

  if type(value) == 'table' and value.kind then
    local group = state[token]
    if not group then
      group = {}
      state[token] = group
    end
    group.title = value.title or group.title
    if value.kind ~= 'end' then
      group.message = value.message or group.message
      if value.percentage then
        group.percentage = math.max(group.percentage or 0, value.percentage)
      end
    else -- value.kind == 'end'
      group.message = nil
      if group.percentage then
        group.percentage = 100
      end
      vim.defer_fn(function()
        state[token] = nil
        invalidate_progress()
      end, 3000)
    end
  elseif type(value) == 'string' then
    state.contents = value
  end

  invalidate_progress()
end

local function rebuild_progress_cache()
  progress_cache = {}

  for client_id, client_state in pairs(progress_state) do
    local client = vim.lsp.get_client_by_id(client_id)
    local name = client.name

    local result = {}
    for _, group in pairs(client_state) do
      if type(group) == 'string' then
        result[#result + 1] = group
      else
        local contents = { group.title }
        if group.message then
          contents[#contents + 1] = group.message
        end

        if group.percentage and group.percentage > 0 then
          contents[#contents + 1] = '(' .. math.ceil(group.percentage) .. '%%)'
        end

        result[#result + 1] = table.concat(contents, ' ')
      end
    end
    if not vim.tbl_isempty(result) then
      progress_cache[name] = table.concat(result, ', ')
    end
  end

  update_timer()
end

local function update_request(request_event)
  local data = request_event.data
  local bufnr = request_event.buf
  local client_id = data.client_id
  local id = data.request_id
  local request = data.request

  local state = request_state[bufnr][client_id]

  if request.type ~= 'complete' then
    for _, i in ipairs(ignore_methods) do
      if request.method:find(i) then
        return
      end
    end
    if not rawget(state.active, id) and not rawget(state.debouncing, id) then
      local timer = vim.loop.new_timer()
      state.debouncing[id] = timer
      timer:start(100, 0, function()
        state.active[id] = request
        state.debouncing[id] = nil
        vim.schedule_wrap(invalidate_requests)(bufnr)
      end)
    end
  else -- request.type == 'complete'
    local timer = rawget(state.debouncing, id)
    if timer then
      state.debouncing[id] = nil
      timer:stop()
      timer:close()
    end
    state.active[id] = nil
  end

  invalidate_requests(bufnr)
end

local function rebuild_requests_cache(bufnr)
  requests_cache[bufnr] = {}

  local cache = requests_cache[bufnr]
  local state = request_state[bufnr]

  for client_id, client_state in pairs(state) do
    local client = vim.lsp.get_client_by_id(client_id)
    local name = client.name
    local active = client_state.active

    local result = {}
    local request_set = {
      pending = {},
      cancel = {},
    }
    for _, request in pairs(active) do
      local type = request.type
      local method = request.method

      if not request_set[type][method] then
        request_set[type][method] = true
        result[#result + 1] = string.format("%s %s", type == 'pending' and 'requesting' or 'canceling',
          string.sub(method, string.find(method, '/') + 1))
      end
    end
    if not vim.tbl_isempty(result) then
      cache[name] = string.format('[%s]', table.concat(result, ', '))
    end
  end

  update_timer()
end


local function get_progress()
  if vim.tbl_isempty(progress_cache) then
    rebuild_progress_cache()
  end
  return progress_cache
end

local function get_requests(bufnr)
  if not requests_cache[bufnr] then
    rebuild_requests_cache(bufnr)
  end
  return requests_cache[bufnr]
end

local function get_status(bufnr)
  local msgs = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    local name = client.name
    local status = client.status
    if status then
      if type(status) == "table" then
        local uri = vim.uri_from_bufnr(bufnr)
        if status[uri] then
          msgs[name] = status[uri]
        end
      else
        msgs[name] = status:gsub("%$%(loading~spin%)", spinner_frames[index + 1])
      end
    end
  end
  return msgs
end

function M.statusline(bufnr)
  bufnr = (not bufnr or bufnr == 0) and api.nvim_get_current_buf() or bufnr

  if #vim.lsp.get_clients({ bufnr = bufnr }) == 0 then
    return {}
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

  extend(get_requests(bufnr), true)
  extend(get_status(bufnr))
  extend(get_progress(), true)

  return msgs
end

function M.setup(enable_progress)
  local au_group = api.nvim_create_augroup('lsp_status.aucmds', {})

  api.nvim_create_autocmd('LspDetach', {
    group = au_group,
    callback = function(ev)
      local bufnr = ev.buf
      local client_id = ev.data.client_id

      progress_state[client_id] = nil
      request_state[bufnr][client_id] = nil
      if vim.tbl_isempty(request_state[bufnr]) then
        request_state[bufnr] = nil
      end

      invalidate_progress()
      invalidate_requests(bufnr)
    end,
    desc = 'lsp_status.detach',
  })

  api.nvim_create_autocmd('LspRequest', {
    group = au_group,
    callback = function(ev) update_request(ev) end,
    desc = 'lsp_status.update_request',
  })

  if enable_progress then
    api.nvim_create_autocmd('LspProgress', {
      group = au_group,
      callback = function(ev) update_progress(ev) end,
      desc = 'lsp_status.update_progress',
    })
  end
end

return M
