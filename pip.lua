local Pip = Object:extend()

function Pip:new(x, y, width, height, menu)
	self.menu = menu
	self.x = x
	self.y = y
	self.width = width
	self.height = height
end

function Pip:update(snake)
	local temp = { width = Utils.getLineWidth(), height = Utils.getLineHeight() }
	local overlaps = true
	local cellX, cellY

	if self.menu:isBorder() then
		cellX = math.random(2, 32 - 3)
		cellY = math.random(4, 20 - 3)
		temp.x = cellX * Utils.getLineWidth()
		temp.y = cellY * Utils.getLineHeight()
	else
		cellX = math.random(1, 32 - 1)
		cellY = math.random(2, 20 - 1)
		temp.x = cellX * Utils.getLineWidth()
		temp.y = cellY * Utils.getLineHeight()
	end

	for i = 1, #snake do
		overlaps = Utils.checkCollision(temp, snake[i])
		if overlaps then
			break
		end
	end

	if overlaps then
		self:update(snake)
	else
		self.x = temp.x
		self.y = temp.y
	end
end

function Pip:draw()
	love.graphics.rectangle("fill", self.x + 2, self.y + 2, self.width, self.height)
end

return Pip
