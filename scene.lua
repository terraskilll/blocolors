require "utils"

Scene = {
    gameManager = nil
}

function Scene:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Scene:init(newManager)
    self.gameManager = newManager
end

function Scene:update(dt)
end

function Scene:draw()
    love.graphics.print("Scene not defined...", 0, 0)
end

function Scene:doKeyPress(key)
	print(key)
end

function Scene:doKeyRelease(key)
	print(key)
end

function Scene:doMousePress(x, y, button, istouch)
	print("Position: " .. x .. " - " .. y .. "  Button: " .. button)
end

function Scene:doMouseRelease(x, y, button, istouch)
	print("Position: " .. x .. " - " .. y .. "  Button: " .. button)
end

function Scene:doMouseMove(x, y, dx, dy)
	-- do nothing, please =D
end

function Scene:finalize()
	resetColor()
end