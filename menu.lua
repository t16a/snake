local Menu = Object:extend()

function Menu:new(state)
    self.state = state
    self.cursor = 1
    self.speed = 1
    self.border = false
    self.menuItems = { "Start", "Speed", "Walls", "Quit" }
end

function Menu:update(key)
    if key == "space" or key == "return" then
        if self.menuItems[self.cursor] == "Start" then
            self.state:update(self.state.states.PLAY)
        elseif self.menuItems[self.cursor] == "Speed" then
            if self.speed < 5 then
                self.speed = self.speed + 1
            else
                self.speed = 1
            end
        elseif self.menuItems[self.cursor] == "Walls" then
            self.border = not self.border
        elseif self.menuItems[self.cursor] == "Quit" then
            love.event.quit()
        end
    elseif key == "up" then
        if (self.cursor == 1) then
            self.cursor = #self.menuItems
        else
            self.cursor = self.cursor - 1
        end
    elseif key == "down" then
        if (self.cursor == #self.menuItems) then
            self.cursor = 1
        else
            self.cursor = self.cursor + 1
        end
    elseif key == "left" then
        if self.menuItems[self.cursor] == "Speed" then
            if self.speed == 1 then
                self.speed = 5
            else
                self.speed = self.speed - 1
            end
        elseif self.menuItems[self.cursor] == "Walls" then
            self.border = not self.border
        end
    elseif key == "right" then
        if self.menuItems[self.cursor] == "Speed" then
            if self.speed == 5 then
                self.speed = 1
            else
                self.speed = self.speed + 1
            end
        elseif self.menuItems[self.cursor] == "Walls" then
            self.border = not self.border
        end
    end
end

function Menu:draw()
    -- Title
    love.graphics.printf("SNAKE", 0, Utils.getLineHeight() * 2, Utils.getWindowWidth(), "center")
    love.graphics.printf("ANOTHER ONE", 0, Utils.getLineHeight() * 4, Utils.getWindowWidth(), "center")

    -- Menu
    for i, v in ipairs(self.menuItems) do
        local optionsHeight = Utils.getLineHeight() * (7 + i * 1.5)

        if self.cursor == i then
            love.graphics.printf(">", 120, optionsHeight, Utils.getWindowWidth(), "left")
        end

        if v == "Speed" then
            love.graphics.printf(self.speed, Utils.getWindowWidth() - 135, optionsHeight, Utils.getWindowWidth(),
                "left")
        end
        if v == "Walls" then
            local s
            if self.border then s = "on" else s = "off" end
            love.graphics.printf(s, Utils.getWindowWidth() - 135, optionsHeight, Utils.getWindowWidth(), "left")
        end

        love.graphics.printf(v, 0, optionsHeight, Utils.getWindowWidth(), "center")
    end
end

function Menu:getSpeed()
    return self.speed
end

function Menu:isBorder()
    return self.border
end

return Menu
