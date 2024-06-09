-- if EmmyLua Spoon is installed, load it
pcall(hs.loadSpoon, 'EmmyLua')

local quake = require('kitty_quake')

quake.init()
hs.hotkey.bind({ 'shift', 'command' }, 'space', quake.toggle)
