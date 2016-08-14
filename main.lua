require "gamemanager"

local mgr = nil

function love.load()
    mgr = GameManager:new{}
    mgr:init()
end

function love.update(dt)
    mgr:update(dt)
end

function love.draw()
    mgr:draw()
end

function love.keypressed(k)
	mgr:handleKeyPress(k)
end

function love.keyreleased(key)
   mgr:handleKeyRelease(k)
end

function love.mousepressed(x, y, button, istouch)
	mgr:handleMousePress(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
	mgr:handleMouseRelease(x, y, button, istouch)
end

function love.mousemoved(x, y, dx, dy)
	mgr:handleMouseMove(x, y, dx, dy)
end