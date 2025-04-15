local title = "Snake - Another One"

function love.conf(t)
    t.window.title = title

    t.window.width = 384
    t.window.height = 240

    t.modules.joystick = false
    t.modules.physics = false
end
