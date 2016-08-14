require "resources"
require "utils"

HUD = {
	running       = false,
	totalTime     = 100,
	currentTime   = 0,
	currentLevel  = 0,
	maxLevel      = 0,
	movementCount = 0
}

function HUD:new(o)
	o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o	
end

function HUD:init()
	self:reset()
end

function HUD:setTotalTime(newTotalTime)
	self.totalTime = newTotalTime
end

function HUD:setLevel(newLevel)
	self.level = newLevel
end

function HUD:incrementLevel()
	self.level = self.level + 1
end

function HUD:incrementMoveCount()
	self.movementCount = self.movementCount + 1
end

function HUD:reset(newCurrentLevel, newMaxLevel)
	self.currentTime   = 0
	self.movementCount = 0
	self.currentLevel  = newCurrentLevel
	self.maxLevel      = newMaxLevel
end

function HUD:startCounters()
	self.running = true
end

function HUD:stopCounters()
	self.running = false
end

function HUD:update(dt)
	if self.running then
		self.currentTime = self.currentTime + dt
	end
end

function HUD:draw()
	love.graphics.setFont(f_font16)

	w = f_font16:getWidth(self.movementCount)

	drawShadowedText("Time:", 16, 10, 100, 230, 30)
	if (self:getRemainingTime() > 0.0) then
		drawShadowedText(string.format("%5.1f", self.totalTime - self.currentTime), 80, 10)
	else
		drawShadowedText(string.format("%5.1f", 0.0), 80, 10)
	end
	drawShadowedText("Moves:", love.graphics.getWidth() - w - 115, 10, 100, 230, 30)
	drawShadowedText(self.movementCount, love.graphics.getWidth() - w - 16, 10)

	drawShadowedText("Level:", 16, love.graphics.getHeight() - 42, 100, 230, 30)
	drawShadowedText(self.currentLevel .. "/" .. self.maxLevel, 105, love.graphics.getHeight() - 42)

	resetColor()
end

function HUD:getRemainingTime()
	return self.totalTime - self.currentTime
end

function HUD:getMoveCount()
	return self.movementCount
end