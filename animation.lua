require "animationframe"

Animation = {
    frames       = {},
    frameCount   = 0,
    frameNumber  = 0,
    currentFrame = nil,
    currentTime  = 0
}

function Animation:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Animation:init()
	self.frames = {}
end

function Animation:addFrame(frameImage, frameDuration, startX, startY, endX, endY)
	local frame = AnimationFrame:new{}
	frame:init(frameImage, startX, startY, endX, endY)
	frame:setDuration(frameDuration)
	
	table.insert(self.frames, frame)

    self.frameCount = #self.frames
end

function Animation:reset()
    self.frameNumber  = 1
    self.currentFrame = self.frames[self.frameNumber]
end

function Animation:update(dt)
    if self.frameCount > 0 then
        self.currentTime = self.currentTime + dt

        if self.currentTime > self.currentFrame:getDuration() then
            self.currentTime = 0

            self.frameNumber = self.frameNumber + 1

            if (self.frameNumber > self.frameCount) then
                self.frameNumber = 1
            end

            self.currentFrame = self.frames[self.frameNumber]
        end
    end
end

function Animation:draw(x, y)
    if self.frameCount > 0 then
        self.currentFrame:draw(x, y)
    end
end
