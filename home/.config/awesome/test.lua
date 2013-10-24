math.randomseed(os.time())

function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    for filename in popen('ls "'..directory..'"'):lines() do
        i = i+1
        t[i] = filename
    end
    return t
end

--local gears = require('gears')
function change_image()
    local img_dir = '/home/jdrouhard/Dropbox/Apps/Desktoppr'
    local images = scandir(img_dir)
    local img_file = img_dir .. '/' .. images[math.random(#images)]
    io.write(img_file,'\n')
end

change_image()
