require "resources"
local Vec = require "vector"

Floor = {
	isStart   = false,
    position  = nil,
    momentum  = nil,
	targetPos = nil,
	kind      = 0,
    image     = nil,
	imageQuad = nil,
	number    = 0,
	dnumber   = 0
}

function Floor:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Floor:init(newX, newY, newKind, isStartFloor)
	self.isStart    = isStartFloor
    self.position   = Vec(newX, newY)
    self.momentum   = Vec(0, 0)
    self.image      = i_floor
	self.kind       = newKind
	self.imageQuad  = love.graphics.newQuad((self.kind - 1) * 64, 0, 64, 64, self.image:getDimensions())
end

function Floor:setNumber(n)
	self.number = n
end

function Floor:setDNumber(n)
	self.dnumber = n
end

function Floor:update(dt)
	self.position = self.position + (self.momentum * dt)
end

function Floor:draw()
	if self.kind > 0 then
		love.graphics.draw(self.image, self.imageQuad, self.position.x, self.position.y)
		--love.graphics.print(self.number, self.position.x + 23, self.position.y + 22)
		--love.graphics.print(self.dnumber, self.position.x + 23, self.position.y + 32)
	end
end

function Floor:setMomentum(newMomentum)
	self.momentum = newMomentum
end

function Floor:translateTo(toX, toY)
	targetPos = Vec(toX, toY)

	self.momentum:set(2, 2)
end

function Floor:teleport(xInc, yInc)
	self.position.x = self.position.x + xInc
	self.position.y = self.position.y + yInc
end

function Floor:getPosition()
	return self.position
end

function Floor:getKind()
	return self.kind
end

function Floor:isStartFloor()
	return self.isStart
end