AnimationFrame = {
    image         = nil,
    imageQuad     = nil,
    frameDuration = 1
}

function AnimationFrame:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function AnimationFrame:init(newImage, startX, startY, endX, endY)
    self.image     = newImage
    self.imageQuad = love.graphics.newQuad(startX, startY, endX, endY, self.image:getDimensions())
end

function AnimationFrame:draw(x, y)
    love.graphics.draw(self.image, self.imageQuad, x, y)
end

function AnimationFrame:setDuration(newDuration)
    self.frameDuration = newDuration
end

function AnimationFrame:getDuration()
    return self.frameDuration
end
