local notify = require('notify')
local spinner_frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
local client_notifications = {}

local function get_notification_data(client_id, token)
  if not client_notifications[client_id] then
    client_notifications[client_id] = {}
  end
  if not client_notifications[client_id][token] then
    client_notifications[client_id][token] = {}
  end
  return client_notifications[client_id][token]
end

local M = {}

local function update_spinner(client_id, token)
  local data = get_notification_data(client_id, token)
  if data.spinner then
    data.spinner      = (data.spinner + 1) % #spinner_frames
    data.notification = notify(nil, nil, {
      hide_from_history = true,
      icon = spinner_frames[data.spinner + 1],
      replace = data.notification
    })
    vim.defer_fn(function()
      update_spinner(client_id, token)
    end, 100)
  end
end

local function format_title(title, client_name)
  return client_name .. (#title > 0 and ': ' .. title or '')
end

local function format_message(message, percentage)
  return (percentage and math.ceil(percentage) .. '%\t' or '') .. (message or '')
end

local function handle_progress(_, result, ctx)
  local client_id = ctx.client_id
  local val = result.value

  if not val.kind then
    return
  end

  local data = get_notification_data(client_id, result.token)

  if val.kind == 'begin' then
    local message = format_message(val.message, val.percentage)

    data.spinner = 0
    data.notification = notify(message, 'info', {
      title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
      icon = spinner_frames[data.spinner + 1],
      timeout = false,
      hide_from_history = false,
    })
    update_spinner(client_id, result.token)
  elseif val.kind == 'report' and data then
    data.notification = notify(format_message(val.message, val.percentage), 'info', {
      replace = data.notification,
      hide_from_history = false,
    })
  elseif val.kind == 'end' and data then
    data.spinner = nil
    data.notification = notify(val.message and format_message(val.message) or 'Complete', 'info', {
      icon = '',
      replace = data.notification,
      timeout = 3000
    })
  end
end

function M.setup()
  vim.lsp.handlers["$/progress"] = handle_progress
end

return M
