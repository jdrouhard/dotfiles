local BUNDLE_ID = 'net.kovidgoyal.kitty'
local PATH = hs.application.pathForBundleID(BUNDLE_ID)
local GROUP = 'quake'
local GEOMETRY = hs.geometry({ x = 0, y = 0, w = 1, h = 0.4 })

---@type hs.task|nil
local task = nil

---@type boolean
local hasBeenFocused = false

---@return hs.window
local function getMainWindow(app)
  local win = nil
  while win == nil do
    win = app:mainWindow()
  end
  return win
end

---@param kitty hs.application
---@param space number
---@param screen hs.screen
local function moveWindow(kitty, space, screen)
  -- move to main space
  local win = getMainWindow(kitty)
  if win:isFullScreen() then
    hs.eventtap.keyStroke('fn', 'f', 0, kitty)
  end
  local winFrame = win:frame()
  local scrFrame = screen:fullFrame()
  winFrame.w = scrFrame.w
  winFrame.y = scrFrame.y
  winFrame.x = scrFrame.x
  win:setFrame(winFrame, 0)
  hs.spaces.moveWindowToSpace(win, space, true)
  if win:isFullScreen() then
    hs.eventtap.keyStroke('fn', 'f', 0, kitty)
  end
  win:focus()
end

local kittyMonitor = hs.application.watcher.new(function(_, event, app)
  if task and app:pid() == task:pid() then
    if event == hs.application.watcher.deactivated then
      if hasBeenFocused then
        app:hide()
      else
        hasBeenFocused = true
      end
    end

    if event == hs.application.watcher.launching then
      local win = getMainWindow(app)

      win:move(GEOMETRY)
      app:hide()

      local space = hs.spaces.focusedSpace()
      local screen = hs.screen.mainScreen()
      moveWindow(app, space, screen)
    end
  end
end)

local function launchKittyQuake()
  task = hs.task.new(PATH .. '/Contents/MacOS/kitty',
    function()
      task = nil
      hasBeenFocused = false
    end,
    function() return false end, {
      '-1', '--instance-group', GROUP, '-d', '$HOME', '-o', 'hide_window_decorations=titlebar-and-corners',
      '-o', 'background_opacity=0.9', '-o', 'background_blur=10', '-o', 'macos_quit_when_last_window_closed=true', '-o',
      'macos_hide_from_tasks=true',
    }):start() or nil
end

local M = {}

function M.init()
  kittyMonitor:start()
end

function M.toggle()
  if not task then
    launchKittyQuake()
  else
    local kitty = hs.application.applicationForPID(task:pid())
    if kitty:isFrontmost() then
      kitty:hide()
    else
      local space = hs.spaces.focusedSpace()
      local screen = hs.screen.mainScreen()
      moveWindow(kitty, space, screen)
    end
  end
end

return M
