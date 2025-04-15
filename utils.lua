local Utils = {}

local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()
local lineHeight = 12
local lineWidth = 12

function Utils.checkCollision(a, b)
    local aRight = a.x + a.width
    local aBottom = a.y + a.height
    local bRight = b.x + b.width
    local bBottom = b.y + b.height

    return aRight > b.x and
        a.x < bRight and
        aBottom > b.y and
        a.y < bBottom
end

function Utils.getLineHeight() return lineHeight end

function Utils.getLineWidth() return lineWidth end

function Utils.getWindowWidth() return windowWidth end

function Utils.getWindowHeight() return windowHeight end

return Utils
