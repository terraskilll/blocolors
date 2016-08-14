require "scene"
require "level"
require "cube"
require "hud"
require "utils"

local Vec = require "vector"

-- http://stackoverflow.com/questions/892811/drawing-isometric-game-worlds

PlayScene = Scene:new{
	maxLevel     = 0,
	currentLevel = -1,

	testing    = false,
	paused     = false,
	completed  = false,
	lost       = false,
	moved      = false,
	acceptMove = true,
	level      = nil,
	cube       = nil,
	hud        = nil,

	buttonTest  = nil,
	buttonNext  = nil,
	buttonRetry = nil,
	buttonExit  = nil,

	repeatPos  = {x = 0, y = 0}
}

function PlayScene:init(newManager)
	Scene:init(newManager)

	self:createButtons()

	love.graphics.setBackgroundColor(10, 0, 20)

	self.hud = HUD:new{}

	self.currentLevel = IfThen(self.currentLevel == -1, 1, self.currentLevel)

	if #AllLevels == 0 then
		self:setLevel(self:createTestLevel())
		self.maxLevel = 1
	else
		self.maxLevel = #AllLevels
		level = Level:new{}
		level:init(rotateTable(AllLevels[self.currentLevel].grid), AllLevels[self.currentLevel].duration)
		self:setLevel(level)
	end
end

function PlayScene:setCurrentLevel(newCurrentLevel)
	self.currentLevel = newCurrentLevel
end

function PlayScene:createButtons()
	local quad1 = love.graphics.newQuad(0, 0, 60, 60, i_pretry:getDimensions())
	local quad2 = love.graphics.newQuad(60, 0, 60, 60, i_pretry:getDimensions())

	self.buttonTest = Button:new{}
	self.buttonTest:init(400, 360, i_pconfirm, quad1, quad2)
	self.buttonTest:setOnCLick( 
		function (sender)
			sender:closeTest()
		end )
	
	self.buttonNext = Button:new{}
	self.buttonNext:init(400, 360, i_pnext, quad1, quad2)
	self.buttonNext:setOnCLick( 
		function (sender)
			sender:nextLevel()
		end )

	self.buttonRetry = Button:new{}
	self.buttonRetry:init(540, 360, i_pretry, quad1, quad2)
	self.buttonRetry:setOnCLick( 
		function (sender)
			sender:resetLevel()
		end )

	self.buttonExit = Button:new{}
	self.buttonExit:init(475, 420, i_pexitlevel, quad1, quad2)
	self.buttonExit:setOnCLick( 
		function (sender)
			sender:exitLevel()
		end )	
end

function PlayScene:createTestLevel()
	fMatrix = {}
	fLevel = Level:new{}

	for i=0,10 do
        fMatrix[i] = {}

        for j=0,8 do
			fMatrix[i][j] = 1
        end
    end

	fMatrix[9][7] = 10

	fMatrix[4][1] = 0
	fMatrix[4][6] = 0

	fMatrix[7][1] = 2
	fMatrix[7][2] = 3
	fMatrix[7][3] = 4
	fMatrix[7][4] = 5
	fMatrix[7][5] = 6
	fMatrix[7][6] = 7

	fLevel:init(fMatrix)
	fLevel:setStartFloor(0, 0)

	return fLevel
end

function PlayScene:setLevel(newLevel)
	self.level = newLevel

	local startX, startY = self.level:getStartFloor()
	local pos = self.level:getFloorPosition(startX, startY)

	self.cube = Cube:new{}
	self.cube:init(pos.x, pos.y - 2, startX, startY)

	self.hud:init()
	self.hud:setTotalTime(self.level:getDuration())
	self.hud:reset(self.currentLevel, self.maxLevel)

	self:centerElements()

	self.acceptMove = true
end

function PlayScene:resetLevel()
	local startX, startY = self.level:getStartFloor()
	local pos = self.level:getFloorPosition(startX, startY)

	self.hud:init()
	self.cube:init(pos.x, pos.y - 2, startX, startY)

	self.hud:setTotalTime(self.level:getDuration())

	self.moved     = false
	self.completed = false
	self.lost      = false
	self.hud:reset(self.currentLevel, self.maxLevel)

	self:centerElements()

	self.acceptMove = true
end

function PlayScene:nextLevel()
	if self.currentLevel < self.maxLevel then
		self.currentLevel = self.currentLevel + 1

		self.moved     = false
		self.completed = false
		self.lost      = false
		self.hud:reset(self.currentLevel, self.maxLevel)

		level = Level:new{}
		level:init(rotateTable(AllLevels[self.currentLevel].grid), AllLevels[self.currentLevel].duration)
		self:setLevel(level)

		self.acceptMove = true
	end
end

function PlayScene:closeTest()
	self.gameManager:closeCurrentScene()
end

function PlayScene:exitLevel()
	self.gameManager:closeCurrentScene()
end

function PlayScene:setTesting(isATest)
	self.testing = isATest
end

function PlayScene:update(dt)
	local xp, yp = love.mouse.getPosition()

    if not self.paused then
		self.level:update(dt)

		self.cube:update(dt)

		self.hud:update(dt)
	end

	self.buttonTest:hover(xp, yp, 0, 0)
	self.buttonNext:hover(xp, yp, 0, 0)
	self.buttonRetry:hover(xp, yp, 0, 0)
	self.buttonExit:hover(xp, yp, 0, 0)

	self:checkSituation()
end

function PlayScene:draw()
    self.level:draw()

	self.cube:draw()

	self.hud:draw(dt)

	if (self.testing == true) then
		drawShadowedText("TESTING", love.graphics.getWidth() / 2 - 80, 10, 200, 200, 150)
	end

	if (self.completed == true) then
		love.graphics.draw(i_tbg, -10, -10)

		love.graphics.draw(i_completed, love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 2 - 150)

		if (self.testing == true) then
			self.buttonTest:draw()
		else
			self.buttonNext:draw()
		end

		self.buttonRetry:draw()

		love.graphics.setFont(f_font8)

		if (self.testing == true) then
			drawShadowedText("SAIR DO TESTE", 375, 420, 100, 50, 100)
		else
			drawShadowedText("PROXIMO", 400, 420, 100, 50, 100)			
		end

		drawShadowedText("REPETIR", 540, 420, 100, 50, 100)
		love.graphics.setFont(f_font16)
	end

	if self.lost == true then
		love.graphics.draw(i_tbg, -10, -10)
		love.graphics.draw(i_failed, love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 2 - 150)
		self.buttonRetry:draw()

		love.graphics.setFont(f_font8)
		drawShadowedText("REPETIR", self.repeatPos.x, self.repeatPos.y, 100, 50, 100)
		love.graphics.setFont(f_font16)
	end

	if self.paused == true then
		thequad = love.graphics.newQuad(0, 0, 359, 70, i_mpause:getDimensions())
		love.graphics.draw(i_tbg, -10, -10)
		love.graphics.draw(i_mpause, thequad, love.graphics.getWidth() / 2 - 175, love.graphics.getHeight() / 2 - 200)
		love.graphics.draw(i_greensquare, love.graphics.getWidth() / 2 - 75, love.graphics.getHeight() / 2 + 50)
		
		drawShadowedText("SAIR", love.graphics.getWidth() / 2 - 35, love.graphics.getHeight() / 2 + 160, 100, 50, 100)

		self.buttonExit:draw()
	end
end

function PlayScene:checkSituation()
	local fkind = self.level:getFloorKind(self.cube.floorx, self.cube.floory)

	if fkind == 10 then
		self.completed  = true
		self.acceptMove = false

		self.hud:stopCounters()
		self.buttonRetry:changePosition(540, 360)
		self.repeatPos.x = 540
		self.repeatPos.y = 420
	end

	local matchBottom = self.cube:matchBottom(fkind - 1, self.completed)

	if (matchBottom == false) or (self.hud:getRemainingTime() <= 0.0) then
		self.lost       = true
		self.acceptMove = false

		self.hud:stopCounters()
		self.buttonRetry:changePosition(470, 320)
		self.repeatPos.x = 470
		self.repeatPos.y = 380
	end
end

function PlayScene:moveCube(direction, vx, vy)
	if self.moved == false then
		self.moved = true
		self.hud:startCounters()
	end

	self.cube:startMoving(direction, 32 * vx, 16 * vy)

	self.hud:incrementMoveCount()

	self:centerElements()
end

function PlayScene:centerElements()
	local xc = (love.graphics.getWidth() / 2) - (self.cube.position.x + 32)
	local yc = (love.graphics.getHeight() / 2) - (self.cube.position.y + 26)

	self.cube:teleport(xc, yc)
	self.level:teleportFloors(xc, yc)
end

function PlayScene:doKeyPress(key)
	if self.acceptMove then
		if key == 'up' and self.level:canGo(self.cube.floorx, self.cube.floory + 1) then
			self:moveCube(m_dirs.toBack, 1, -1)
		elseif key == 'down' and self.level:canGo(self.cube.floorx, self.cube.floory - 1) then
			self:moveCube(m_dirs.toFront, -1, 1)
		elseif key == 'left' and self.level:canGo(self.cube.floorx - 1, self.cube.floory) then
			self:moveCube(m_dirs.toLeft, -1, -1)
		elseif key == 'right' and self.level:canGo(self.cube.floorx + 1, self.cube.floory) then
			self:moveCube(m_dirs.toRight, 1, 1)
		end
	end

	if key == 'escape' then
		self.paused = IfThen(self.paused, false, true)
	end

	if key == 'f1' then
		self.cube:activateHelp(3)
	end
end

function PlayScene:doKeyRelease(key)
	self.cube:stopMoving()
end

function PlayScene:doMousePress(x, y, button, istouch)
	if (self.testing == true) then
		if (self.completed == true) and (self.buttonTest:isClicked(x, y)) then
			self.buttonTest:executeClick(self, button)
		end
	else 
		if (self.completed == true) and (self.buttonNext:isClicked(x, y)) then
			self.buttonNext:executeClick(self, button)
		end
	end

	if (self.completed == true) or (self.lost == true) and (self.buttonRetry:isClicked(x, y)) then
		self.buttonRetry:executeClick(self, button)
	end

	if (self.paused == true) and (self.buttonExit:isClicked(x, y)) then
		self.buttonExit:executeClick(self, button)
	end
end