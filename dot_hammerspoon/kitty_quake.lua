local BUNDLE_ID = 'net.kovidgoyal.kitty'
local PATH = hs.application.pathForBundleID(BUNDLE_ID)
local TITLE = 'KittyQuake'
local GROUP = 'quake'
local GEOMETRY = hs.geometry({ x = 0, y = 0, w = 1, h = 0.4 })

local M = {}

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

---@return hs.application|nil
local function findKittyQuake()
  for _, app in ipairs(hs.application.applicationsForBundleID(BUNDLE_ID)) do
    if getMainWindow(app):title() == TITLE then
      return app
    end
  end
end

local pid = nil
M.hideWatcher = hs.application.watcher.new(function(_, event, app)
  if pid and event == hs.application.watcher.terminated then
    pid = nil
  end

  if app:bundleID() == BUNDLE_ID and app:getWindow(TITLE) then
    if event == hs.application.watcher.deactivated then
      if pid then
        app:hide()
      else
        pid = app:pid()
      end
    end
  end
end)

-- must be on module for lifetime purposes
M.startWatcher = hs.application.watcher.new(function(_, event, app)
  if app:bundleID() ~= BUNDLE_ID then
    return
  end

  if event == hs.application.watcher.launching then
    local win = getMainWindow(app)
    if win:title() ~= TITLE then
      return
    end

    win:move(GEOMETRY)
    app:hide()

    local space = hs.spaces.focusedSpace()
    local screen = hs.screen.mainScreen()
    moveWindow(app, space, screen)
    M.startWatcher:stop()
  end
end)

local function launchKittyQuake()
  local t = hs.task.new(PATH .. '/Contents/MacOS/kitty', nil, function() return false end, {
    '-1', '-T', TITLE, '--instance-group', GROUP, '-d', '$HOME', '-o', 'hide_window_decorations=titlebar-and-corners',
    '-o', 'background_opacity=0.9', '-o', 'macos_quit_when_last_window_closed=true', '-o', 'macos_hide_from_tasks=true',
  })

  M.startWatcher:start()
  return t:start()
end

function M.init()
  M.hideWatcher:start()
end

function M.toggle()
  local kitty = findKittyQuake()

  if not kitty then
    launchKittyQuake()
  elseif kitty:isFrontmost() then
    kitty:hide()
  else
    local space = hs.spaces.focusedSpace()
    local screen = hs.screen.mainScreen()
    moveWindow(kitty, space, screen)
  end
end

return M
