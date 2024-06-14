local quake = require('kitty_quake')

-- if EmmyLua Spoon is installed, load it
hs.loadSpoon('EmmyLua')

hs.hotkey.bind({ 'shift', 'command' }, 'space', quake.toggle)
