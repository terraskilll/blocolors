require "resources"
require "floor"
require "animation"

ExitFloor = Floor:new{
    animation = nil,
	glow      = nil
}

function ExitFloor:init(newX, newY, newKind)
    Floor:init(newX, newY, newKind)
    self.image     = i_exitfloor

    self.animation = Animation:new{}
	self.animation:init()
    self.animation:addFrame(self.image, 0.3, 0, 0, 64, 64)
    self.animation:addFrame(self.image, 0.3, 64, 0, 64, 64)
    self.animation:reset()

	self.glow = love.graphics.newParticleSystem(i_glow1, 100)
	self.glow:setEmissionRate(5)
	self.glow:setSpeed(0, 20)
	self.glow:setSizes(5, 3, 1)	
	self.glow:setParticleLifetime(1.5)
	self.glow:setEmitterLifetime(-1)
	self.glow:setDirection(math.rad(270))

	self.glow:start()
end

function ExitFloor:update(dt)
    self.animation:update(dt)
	self.position = self.position + (self.momentum * dt)

	self.glow:update(dt)
end

function ExitFloor:draw()
    self.animation:draw(self.position.x, self.position.y)
	love.graphics.draw(self.glow, self.position.x + 32, self.position.y + 32) -- shows particles
end