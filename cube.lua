require "resources"

local Vec = require "vector"

c_kinds = {
	top    = {0, 0, -15},
	bottom = {1, 0,  15},
	front  = {2, 52,  0},
	back   = {3, 52, 0},
	left   = {4, 104, 0},
	right  = {5, 104, -8}
}

m_dirs = { toFront = 1, toBack = 2, toLeft = 3, toRight = 4}

m_dirsValues = {
	{1, 1},
	{1, 1},
	{1, 1},
	{1, 1},
}

Cube = {
	floorx        = 0,
	floory        = 0,
	position      = nil,
	movingCount   = 0,
	movementPos   = Vec(0, 0),
	movementDir   = 0,
	movementDelay = 0.0,
	translating   = false,
	helpTime      = 0.0,
	targetPos     = Vec(0, 0),
	topFace       = nil,
	bottomFace    = nil,
	frontFace     = nil,
	backFace      = nil,
	leftFace      = nil,
	rightFace     = nil,
	middleAnim    = nil
}

function Cube:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Cube:init(newX, newY, newFloorX, newFloorY)
    self.position      = Vec(newX, newY)
    self.momentum      = Vec(0, 0)
	self.movementDelay = 0.0
	self.movingCount   = 0
	self.floorx        = newFloorX
	self.floory        = newFloorY

	self.topFace   = CubePart:new{}
	self.topFace:init(i_blockp, c_colors.blue, c_kinds.top)

	self.bottomFace = CubePart:new{}
	self.bottomFace:init(i_blockp, c_colors.orange, c_kinds.bottom)

	self.frontFace = CubePart:new{}
	self.frontFace:init(i_blockp, c_colors.red, c_kinds.front)

	self.backFace = CubePart:new{}
	self.backFace:init(i_blockp, c_colors.green, c_kinds.back)

	self.leftFace = CubePart:new{}
	self.leftFace:init(i_blockp, c_colors.yellow, c_kinds.left)

	self.rightFace = CubePart:new{}
	self.rightFace:init(i_blockp, c_colors.purple, c_kinds.right)

	self.middleAnim = Animation:new{}
	self.middleAnim:init()
    self.middleAnim:addFrame(i_blockmid, 0.2, 0, 0, 32, 32)
    self.middleAnim:addFrame(i_blockmid, 0.3, 32, 0, 32, 32)
	self.middleAnim:reset()
end

function Cube:draw()
	if self.helpTime > 0.0 then
		love.graphics.draw(i_help, self.position.x - 122, self.position.y - 40)
	end

	self.bottomFace:draw(self.position.x, self.position.y)
	self.rightFace:draw(self.position.x - 26, self.position.y - 4)
	self.backFace:draw(self.position.x + 26, self.position.y - 10)

	self.middleAnim:draw(self.position.x + 16, self.position.y + 2)

	self.leftFace:draw(self.position.x, self.position.y)
	self.frontFace:draw(self.position.x, self.position.y)
	self.topFace:draw(self.position.x, self.position.y)	
end

function Cube:activateHelp(duration)
	self.helpTime = duration
end

function Cube:startMoving(direction, xMovement, yMovement)
	self.movementDir = direction
	self.movingCount = self.movingCount + 1
	self.movementPos = Vec(xMovement, yMovement)
end

function Cube:stopMoving()	
	self.movingCount = self.movingCount - 1

	if self.movingCount <= 0 then
		self.movementDelay = 0.0
		self.movingCount   = 0
		self.movementPos   = Vec(0, 0)
	end
end

function Cube:update(dt)
	self.middleAnim:update(dt)

	if self.movingCount > 0 then
		self.movementDelay = self.movementDelay - dt
		if self.movementDelay <= 0.0 then
			self.movementDelay = 0.25
			self:move()
		end
	end

	self.position = self.position + (self.momentum * dt)

	if self.translating then
		if math.abs(self.position.x - self.targetPos.x) < 1 then
			self.position.x  = self.targetPos.x
			self.momentum.x  = 0
		end

		if math.abs(self.position.y - self.targetPos.y) < 1 then
			self.position.y  = self.targetPos.y
			self.momentum.y  = 0
		end

		if self.momentum.x == 0 and self.momentum.y == 0 then
			self.translating = false
		end
	end

	if self.helpTime > 0.0 then
		self.helpTime = self.helpTime - dt
	end
end

function Cube:move()
	if self.movementDir == m_dirs.toFront then
		self:moveForward()
	elseif self.movementDir == m_dirs.toBack then
		self:moveBackward()
	elseif self.movementDir == m_dirs.toLeft then
		self:moveLeft()
	elseif self.movementDir == m_dirs.toRight then
		self:moveRight()
	end
end

function Cube:moveForward()
	tmp             = self.frontFace
	self.frontFace  = self.topFace
	self.topFace    = self.backFace
	self.backFace   = self.bottomFace
	self.bottomFace = tmp

	self.frontFace:changeKind(c_kinds.front)
	self.topFace:changeKind(c_kinds.top)
	self.backFace:changeKind(c_kinds.back)
	self.bottomFace:changeKind(c_kinds.bottom)

	self.position = self.position + self.movementPos
	
	self.floory = self.floory - 1
end

function Cube:moveBackward()
	tmp             = self.frontFace
	self.frontFace  = self.bottomFace
	self.bottomFace = self.backFace
	self.backFace   = self.topFace
	self.topFace    = tmp

	self.frontFace:changeKind(c_kinds.front)
	self.topFace:changeKind(c_kinds.top)
	self.backFace:changeKind(c_kinds.back)
	self.bottomFace:changeKind(c_kinds.bottom)

	self.position = self.position + self.movementPos

	self.floory = self.floory + 1
end

function Cube:moveLeft()
	tmp             = self.topFace
	self.topFace    = self.leftFace
	self.leftFace   = self.bottomFace
	self.bottomFace = self.rightFace
	self.rightFace  = tmp

	self.topFace:changeKind(c_kinds.top)
	self.leftFace:changeKind(c_kinds.left)
	self.bottomFace:changeKind(c_kinds.bottom)
	self.rightFace:changeKind(c_kinds.right)

	self.position = self.position + self.movementPos
	
	self.floorx = self.floorx - 1
end

function Cube:moveRight()
	tmp             = self.topFace
	self.topFace    = self.rightFace
	self.rightFace  = self.bottomFace
	self.bottomFace = self.leftFace
	self.leftFace   = tmp

	self.topFace:changeKind(c_kinds.top)
	self.leftFace:changeKind(c_kinds.left)
	self.bottomFace:changeKind(c_kinds.bottom)
	self.rightFace:changeKind(c_kinds.right)

	self.position = self.position + self.movementPos
	
	self.floorx = self.floorx + 1
end

function Cube:matchBottom(floorKind, alreadyWon)
	return (alreadyWon) or (floorKind == 0) or (floorKind == self.bottomFace.color)
end

function Cube:teleport(xInc, yInc)
	self.position.x = self.position.x + xInc
	self.position.y = self.position.y + yInc
end

----------------------------------------------------------------------------------
----------- CUBEPART -------------------------------------------------------------
----------------------------------------------------------------------------------

CubePart = {
	kind       = nil,
	color      = nil,
	image      = nil,
	imageQuad  = nil
}

function CubePart:new(o)
	o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function CubePart:init(newImage, newColor, newKind)
	self.image      = newImage
	self.color      = newColor
	self.kind       = newKind
	self.imageQuad  = love.graphics.newQuad((self.color - 1) * 64, self.kind[2], 64, 52, self.image:getDimensions())
end

function CubePart:draw(x, y)
	love.graphics.draw(self.image, self.imageQuad, x, y + self.kind[3])
end

function CubePart:changeKind(newKind)
	self.kind      = newKind
	self.imageQuad = love.graphics.newQuad((self.color - 1) * 64, self.kind[2], 64, 52, self.image:getDimensions())
end