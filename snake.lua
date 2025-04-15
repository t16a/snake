local Snake = Object:extend()

local snake = {}
local snakeWidth = 10
local snakeHeight = 10
local moveDir = {dx = 1, dy = 0}

function Snake:new(state)
    self.windowWidth = Utils.getWindowWidth()
    self.windowHeight = Utils.getWindowHeight()
    self.state = state

    self.head = {
        x = Utils.getLineHeight() * 10,
        y = Utils.getLineWidth() * 10,
        width = snakeWidth,
        height = snakeHeight
    }
    self.body = {
        x = self.head.x - snakeWidth,
        y = self.head.y,
        width = snakeWidth,
        height = snakeHeight
    }
    self.tail = {
        x = self.body.x - snakeWidth,
        y = self.body.y,
        width = snakeWidth,
        height = snakeHeight
    }

    table.insert(snake, self.head)
    table.insert(snake, self.body)
    table.insert(snake, self.tail)
end

local function addBody()
    local part = {
        x = snake[#snake].x,
        y = snake[#snake].y,
        width = snakeWidth,
        height = snakeHeight
    }
    table.insert(snake, part)
end

function Snake:update(dirBuffer, pip, sfx, speed)
    local lastX = self.head.x
    local lastY = self.head.y

    local tempDir = dirBuffer[1]
    table.remove(dirBuffer, 1)

    if tempDir then
        if tempDir.dx == 0 and tempDir.dy == 0 then
            moveDir = moveDir
        elseif moveDir.dx > 0 and tempDir.dx >= 0 or moveDir.dx < 0 and tempDir.dx <= 0 then
            moveDir = tempDir
        elseif moveDir.dy > 0 and tempDir.dy >= 0 or moveDir.dy < 0 and tempDir.dy <= 0 then
            moveDir = tempDir
        end
    end

    if moveDir.dx > 0 then
        self.head.x = self.head.x + Utils.getLineWidth()
    elseif moveDir.dx < 0 then
        self.head.x = self.head.x - Utils.getLineWidth()
    elseif moveDir.dy > 0 then
        self.head.y = self.head.y + Utils.getLineHeight()
    elseif moveDir.dy < 0 then
        self.head.y = self.head.y - Utils.getLineHeight()
    end

    -- loop around of the playarea
    if self.head.x < Utils.getLineWidth() then
        self.head.x = Utils.getLineWidth() * 31 - self.head.width
    elseif self.head.x + self.head.width > Utils.getLineWidth() * 31 then
        self.head.x = Utils.getLineWidth()
    elseif self.head.y < Utils.getLineHeight() * 2 then
        self.head.y = Utils.getLineHeight() * 19 - self.head.height
    elseif self.head.y + self.head.height > Utils.getLineHeight() * 19 then
        self.head.y = Utils.getLineHeight() * 2
    end

    -- Update snake parts
    for i = 2, #snake do
        local tempX = snake[i].x
        local tempY = snake[i].y
        snake[i].x = lastX
        snake[i].y = lastY
        lastX = tempX
        lastY = tempY
    end

    -- Die
    for i = 2, #snake do
        if Utils.checkCollision(self.head, snake[i]) then
            sfx.death:play()
            self.state:update(self.state.states.GAME_OVER)
        end
    end

    -- Score
    if Utils.checkCollision(self.head, pip) then
        sfx.pip:play()
        Score = Score + 1 * speed
        addBody()
        pip:update(snake)
    end
end

function Snake:draw()
    for i = 1, #snake do
        love.graphics.rectangle("fill", snake[i].x, snake[i].y, snakeWidth + 2, snakeHeight + 2)
    end
end

return Snake
