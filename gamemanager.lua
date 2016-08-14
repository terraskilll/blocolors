require "scene"
require "menuscene"
require "playscene"

GameManager = {
    currentScene = nil,
	currentLevel = nil,
	scenes       = {}
}

function GameManager:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function GameManager:init()
	self:loadLevels()

	table.insert(self.scenes, MenuScene:new{})

	self.currentScene = self.scenes[#self.scenes]
    self.currentScene:init(self)
end

function GameManager:update(dt)
    self.currentScene:update(dt)
end

function GameManager:draw()
    self.currentScene:draw()
end

function GameManager:changeToScene(newScene)
	table.insert(self.scenes, newScene)
    self.currentScene = self.scenes[#self.scenes]
    self.currentScene:init(self)
end

function GameManager:closeCurrentScene()
	self.currentScene:finalize()

	table.remove(self.scenes)
	self.currentScene = self.scenes[#self.scenes]
	self.currentScene:init(self)
end

function GameManager:handleKeyPress(key)
	if key == 'f12' then
		love.event.push('quit')
	else
		self.currentScene:doKeyPress(key)
	end
end

function GameManager:handleKeyRelease(key)
	self.currentScene:doKeyRelease(key)
end

function GameManager:handleMousePress(x, y, button, istouch)
	self.currentScene:doMousePress(x, y, button, istouch)
end

function GameManager:handleMouseRelease(x, y, button, istouch)
	self.currentScene:doMouseRelease(x, y, button, istouch)
end

function GameManager:handleMouseMove(x, y, dx, dy)
	self.currentScene:doMouseMove(x, y, dx, dy)
end

function GameManager:saveLevels()
	path = love.filesystem.getSourceBaseDirectory() .. "/alllevels.lev"
	err = table.save(AllLevels, path)
	if err then
		print(path .. " :: " .. err)
	end
end

function GameManager:loadLevels()
	local path = love.filesystem.getSourceBaseDirectory() .. "/alllevels.lev"
	AllLevels, err = table.load(path)
	if err then
		print(path .. " :: " .. err)
		AllLevels = {}
	end
end
