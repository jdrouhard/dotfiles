local BUNDLE_ID = 'net.kovidgoyal.kitty'
local PATH = hs.application.pathForBundleID(BUNDLE_ID)
local GROUP = 'quake'
local GEOMETRY = hs.geometry.new({ x = 0, y = 0, w = 1, h = 0.4 })

---@type hs.task|nil
local task = nil

---@param kitty hs.application
local function moveWindow(kitty)
  local win = kitty:mainWindow()
  local space = hs.spaces.focusedSpace()
  local screen = hs.screen.mainScreen()

  hs.spaces.moveWindowToSpace(win, space, true)
  win:move(GEOMETRY, screen, true, 0)
  win:focus()
end

local kittyMonitor = hs.application.watcher.new(function(_, event, app)
  if task and app:pid() == task:pid() then
    if event == hs.application.watcher.deactivated then
      app:hide()
    end

    if event == hs.application.watcher.launching then
      -- wait for main window to appear
      repeat until app:mainWindow()
      moveWindow(app)
    end
  end
end)

local function launchKittyQuake()
  kittyMonitor:start()

  task = hs.task.new(PATH .. '/Contents/MacOS/kitty',
    function() task = nil end,
    function() return false end, {
      '-1', '--instance-group', GROUP,
      '-d', '$HOME',
      '-o', 'hide_window_decorations=titlebar-and-corners',
      '-o', 'background_opacity=0.9',
      '-o', 'background_blur=10',
      '-o', 'macos_quit_when_last_window_closed=true',
      '-o', 'macos_hide_from_tasks=true',
    }):start() or nil
end

local M = {}

function M.toggle()
  if not task then
    launchKittyQuake()
  else
    local kitty = hs.application.applicationForPID(task:pid())
    if kitty:isFrontmost() then
      kitty:hide()
    else
      moveWindow(kitty)
    end
  end
end

return M
