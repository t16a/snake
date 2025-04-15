local Border = Object:extend()

function Border:new()
    self.left = {
        width = Utils.getLineWidth(),
        height = Utils.getLineHeight() * 16,
        x = Utils.getLineHeight(),
        y = Utils.getLineWidth() * 2
    }
    self.right = {
        width = Utils.getLineWidth(),
        height = Utils.getLineHeight() * 16,
        x = Utils.getLineHeight() * 30,
        y = Utils.getLineWidth() * 2
    }
    self.top = {
        width = Utils.getLineWidth() * 30,
        height = Utils.getLineHeight(),
        x = Utils.getLineHeight(),
        y = Utils.getLineWidth() * 2
    }
    self.bottom = {
        width = Utils.getLineWidth() * 30,
        height = Utils.getLineHeight(),
        x = Utils.getLineHeight(),
        y = Utils.getLineWidth() * 18
    }
    self.borders = {self.left, self.right, self.top, self.bottom}
end

function Border:update(snake, state, sfx)
    for i, v in ipairs(self.borders) do
        -- check collision with snake head
        if Utils.checkCollision(snake.head, v) then
            sfx.death:play()
            state:update(state.states.GAME_OVER)
        end
    end
end

function Border:draw()
    for i, v in ipairs(self.borders) do
        love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
    end
end

return Border
