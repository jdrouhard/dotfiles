
local wallch = {}

function wallch.change_image ()
    local img_dir = '/home/jdrouhard/Dropbox/Apps/Desktoppr'
    awful.util.spawn_with_shell('awsetbg -r ' .. img_dir)
end

return wallch
