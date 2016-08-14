require "resources"
require "scene"
require "utils"
require "level"

local baseblockcursor = {
	{-13,  -6, -13, -13,  -6, -13},
	{  6, -13,  13, -13,  13,  -6},
	{ 13,   6,  13,  13,   6,  13},
	{-13,   6, -13,  13,  -6,  13},
}

local blockcursor = {}
local linesColor  = {240, 240, 240}
local barColor    = {20, 100, 180}
local cursorColor = {50, 50, 255}

local topBarHeight = 70
local leftBarWidth = 70

EditorScene = Scene:new{
	toolState  = 0,
	gridWidth  = 0,
	gridHeight = 0,
	gridHLines = {},
	gridVLines = {},
	gridMatrix = {},
	endPos     = {-1, -1},
	startPos   = {-1, -1},

	levelDuration = 0,
	
	levelCount   = 0,

	currentLevel = 0,

	option = 0,
	
	offSetX = 0,
	offSetY = 0,

	buttonExec = nil,
	buttonSave = nil,
	buttonExit = nil,
	buttonNew  = nil,
	buttonNext = nil,
	buttonPrev = nil,

	buttonBUp    = nil,
	buttonBDown  = nil,
	buttonBLeft  = nil,
	buttonBRight = nil,

	buttonAddW = nil,
	buttonAddH = nil,
	buttonRemW = nil,
	buttonRemH = nil,

	buttonIncT = nil,
	buttonDecT = nil,

	buttonGray   = nil,
	buttonBlue   = nil,
	buttonGreen  = nil,
	buttonYellow = nil,
	buttonOrange = nil,
	buttonRed    = nil,
	buttonPurple = nil,
	buttonEnd    = nil,
	buttonStart  = nil,

	collorButtons = {}
}

function EditorScene:init(newManager)
	Scene:init(newManager)

	love.graphics.setBackgroundColor(50, 50, 50)
	love.graphics.setLineWidth(2)

	self.currentLevel = 0

	self:createButtons()

	self:updateButtons()

	self.levelCount = #AllLevels

	if self.levelCount == 0 then
		self:createLevel()
	else
		self:loadLevel(1)
	end
end

function EditorScene:createButtons()
	local quad1 = love.graphics.newQuad(0, 0, 50, 50, i_mexec:getDimensions())
	local quad2 = love.graphics.newQuad(50, 0, 50, 50, i_mexec:getDimensions())

	self.buttonExec = Button:new{}
	self.buttonExec:init(80, 10, i_mexec, quad1, quad2)
	self.buttonExec:setOnCLick(
		function (sender)
			level = Level:new{}
			level:init(rotateTable(sender.gridMatrix), sender.levelDuration)
			playScene = PlayScene:new{}
			playScene:init(sender.gameManager)
			playScene:setCurrentLevel(self.currentLevel)
			playScene:setTesting(true)
			sender.gameManager:changeToScene(playScene)
		end )

	self.buttonNew = Button:new{}
	self.buttonNew:init(140, 10, i_mnew, quad1, quad2)
	self.buttonNew:setOnCLick( 
		function (sender)
			sender:createLevel()
		end )

	self.buttonSave = Button:new{}
	self.buttonSave:init(200, 10, i_msave, quad1, quad2)
	self.buttonSave:setOnCLick( 
		function (sender)
			AllLevels[sender.currentLevel] = {
				duration = sender.levelDuration,
				grid     = sender.gridMatrix
			}

			sender.gameManager:saveLevels()
		end )

	self.buttonExit = Button:new{}
	self.buttonExit:init(930, 10, i_mexit, quad1, quad2)
	self.buttonExit:setOnCLick( 
		function (sender)
			sender.gameManager:closeCurrentScene()
		end )

	self.buttonPrev = Button:new{}
	self.buttonPrev:init(480, 10, i_mprev, quad1, quad2)
	self.buttonPrev:setOnCLick( 
		function (sender)
			if sender.currentLevel > 1 then
				sender:loadLevel(self.currentLevel - 1)
			end
		end )

	self.buttonNext = Button:new{}
	self.buttonNext:init(620, 10, i_mnext, quad1, quad2)
	self.buttonNext:setOnCLick( 
		function (sender)
			if sender.currentLevel < self.levelCount then
				sender:loadLevel(self.currentLevel + 1)
			end
		end )

	--------------------------------------------------------------

	local quadudlr1 = love.graphics.newQuad(0, 0, 28, 28, i_mbup:getDimensions())
	local quadudlr2 = love.graphics.newQuad(28, 0, 28, 28, i_mbup:getDimensions())

	self.buttonBUp = Button:new{}
	self.buttonBUp:init(love.graphics.getWidth() - 28, topBarHeight, i_mbup, quadudlr1, quadudlr2)
	self.buttonBUp:setOnCLick(
		function (sender)
			if sender.offSetY > 0 then
				sender.offSetY = sender.offSetY - 1
			end
		end
	)

	self.buttonBDown = Button:new{}
	self.buttonBDown:init(love.graphics.getWidth() - 28, love.graphics.getHeight() - 56, i_mbdown, quadudlr1, quadudlr2)
	self.buttonBDown:setOnCLick(
		function (sender)
			if sender.offSetY < sender.gridHeight - 16 then
				sender.offSetY = sender.offSetY + 1
			end
		end
	)

	self.buttonBLeft = Button:new{}
	self.buttonBLeft:init(leftBarWidth, love.graphics.getHeight() - 28, i_mbleft, quadudlr1, quadudlr2)
	self.buttonBLeft:setOnCLick(
		function (sender)
			if sender.offSetX > 0 then
				sender.offSetX = sender.offSetX - 1
			end
		end
	)

	self.buttonBRight = Button:new{}
	self.buttonBRight:init(love.graphics.getWidth() - 56, love.graphics.getHeight() - 28, i_mbright, quadudlr1, quadudlr2)
	self.buttonBRight:setOnCLick(
		function (sender)
			if sender.offSetX < sender.gridWidth - 26 then
				sender.offSetX = sender.offSetX + 1
			end
		end
	)

	--------------------------------------------------------------

	local quadx = love.graphics.newQuad(0, 0, 48, 48, i_floormini:getDimensions())
	self.buttonGray = Button:new{}
	self.buttonGray:init(10, 70, i_floormini, quadx, quadx)
	self.buttonGray:showSelectSquare(true)

	local quadx = love.graphics.newQuad(48, 0, 48, 48, i_floormini:getDimensions())
	self.buttonBlue = Button:new{}
	self.buttonBlue:init(10, 130, i_floormini, quadx, quadx)
	self.buttonBlue:showSelectSquare(true)

	local quadx = love.graphics.newQuad(96, 0, 48, 48, i_floormini:getDimensions())
	self.buttonGreen = Button:new{}
	self.buttonGreen:init(10, 190, i_floormini, quadx, quadx)
	self.buttonGreen:showSelectSquare(true)

	local quadx = love.graphics.newQuad(144, 0, 48, 48, i_floormini:getDimensions())
	self.buttonYellow = Button:new{}
	self.buttonYellow:init(10, 250, i_floormini, quadx, quadx)
	self.buttonYellow:showSelectSquare(true)
	
	local quadx = love.graphics.newQuad(192, 0, 48, 48, i_floormini:getDimensions())
	self.buttonOrange = Button:new{}
	self.buttonOrange:init(10, 310, i_floormini, quadx, quadx)
	self.buttonOrange:showSelectSquare(true)

	local quadx = love.graphics.newQuad(240, 0, 48, 48, i_floormini:getDimensions())
	self.buttonRed = Button:new{}
	self.buttonRed:init(10, 370, i_floormini, quadx, quadx)
	self.buttonRed:showSelectSquare(true)

	local quadx = love.graphics.newQuad(288, 0, 48, 48, i_floormini:getDimensions())
	self.buttonPurple = Button:new{}
	self.buttonPurple:init(10, 430, i_floormini, quadx, quadx)
	self.buttonPurple:showSelectSquare(true)

	local quadx = love.graphics.newQuad(0, 0, 48, 48, i_exitfloormini:getDimensions())
	self.buttonEnd = Button:new{}
	self.buttonEnd:init(10, 490, i_exitfloormini, quadx, quadx)
	self.buttonEnd:showSelectSquare(true)

	local quadx = love.graphics.newQuad(0, 0, 48, 48, i_start:getDimensions())
	self.buttonStart = Button:new{}
	self.buttonStart:init(10, 550, i_start, quadx, quadx)
	self.buttonStart:showSelectSquare(true)

	--------------------------------------------------------------
	
	local quada = love.graphics.newQuad(0, 0, 25, 25, i_mplus:getDimensions())
	local quadb = love.graphics.newQuad(25, 0, 25, 25, i_mplus:getDimensions())

	self.buttonAddW = Button:new{}
	self.buttonAddW:init(400, 10, i_mplus, quada, quadb)
	self.buttonAddW:setOnCLick( 
		function (sender)
			sender:increaseGridWidth()
		end )

	self.buttonAddH = Button:new{}
	self.buttonAddH:init(400, 35, i_mplus, quada, quadb)
	self.buttonAddH:setOnCLick( 
		function (sender)
			sender:increaseGridHeight()
		end )
		
	self.buttonRemW = Button:new{}
	self.buttonRemW:init(300, 10, i_mminus, quada, quadb)
	self.buttonRemW:setOnCLick( 
		function (sender)
			sender:decreaseGridWidth()
		end )

	self.buttonRemH = Button:new{}
	self.buttonRemH:init(300, 35, i_mminus, quada, quadb)
	self.buttonRemH:setOnCLick( 
		function (sender)
			sender:decreaseGridHeight()
		end )

	--------------------------------------------------------------

	self.buttonIncT = Button:new{}
	self.buttonIncT:init(830, 10, i_mplus, quada, quadb)
	self.buttonIncT:setOnCLick( 
		function (sender)
			sender:changeDuration(1)
		end )

	self.buttonDecT = Button:new{}
	self.buttonDecT:init(730, 10, i_mminus, quada, quadb)
	self.buttonDecT:setOnCLick( 
		function (sender)
			sender:changeDuration(-1)
		end )

	--------------------------------------------------------------

	table.insert(self.collorButtons, self.buttonGray)
	table.insert(self.collorButtons, self.buttonBlue)
	table.insert(self.collorButtons, self.buttonGreen)
	table.insert(self.collorButtons, self.buttonYellow)
	table.insert(self.collorButtons, self.buttonOrange)
	table.insert(self.collorButtons, self.buttonRed)
	table.insert(self.collorButtons, self.buttonPurple)
	table.insert(self.collorButtons, self.buttonEnd)
	table.insert(self.collorButtons, self.buttonStart)
end

function EditorScene:updateButtons()
	self.buttonExec:selectButton(self.option == 1)
	self.buttonSave:selectButton(self.option == 2)
	self.buttonExit:selectButton(self.option == 3)
	self.buttonNew:selectButton(self.option == 4)
	self.buttonNext:selectButton(self.option == 5)
	self.buttonPrev:selectButton(self.option == 6)
end

function EditorScene:loadLevel(levelNumber)
	self.currentLevel  = levelNumber
	self.gridMatrix    = AllLevels[self.currentLevel].grid
	self.levelDuration = AllLevels[self.currentLevel].duration

	self.option       = 0
	self.toolState    = 0

	self.gridWidth  = #self.gridMatrix
	self.gridHeight = #self.gridMatrix[0]

	for i = 0, self.gridWidth-1 do
		for j = 0, self.gridHeight-1 do
			if self.gridMatrix[i][j] == 10 then
				self.endPos = {i, j}
			end

			if self.gridMatrix[i][j] == 11 then
				self.startPos = {i, j}
			end
		end
	end

	self:redoGrid(false)
end

function EditorScene:createLevel()
	self.toolState     = 0
	self.gridWidth     = 25
	self.gridHeight    = 15
	self.gridMatrix    = {}
	self.endPos        = {-1, -1}
	self.startPos      = {-1, -1}
	self.levelDuration = 50

	self.currentLevel = self.levelCount + 1

	self.option = 0

	self:redoGrid(true)
end

function EditorScene:redoGrid(erase)
	self.gridHLines = {}
	self.gridVLines = {}

	local width = (math.min(self.gridWidth, 26) + 1) * 32

	local height = (math.min(self.gridHeight, 16) + 1) * 32

	for i = 1, self.gridWidth + 1 do
		self.gridVLines[i] = {i * 32 + leftBarWidth, 32 + topBarHeight, i * 32 + leftBarWidth, height + topBarHeight}
	end

	for i = 1, self.gridHeight + 1 do
		self.gridHLines[i] = {32 + leftBarWidth, i * 32 + topBarHeight, width + leftBarWidth, i * 32 + topBarHeight}
	end

	if erase == true then
		self.endPos   = {-1, -1}
		self.startPos = {-1, -1}

		self.gridMatrix = {}

		for i = 0, self.gridWidth - 1 do
			self.gridMatrix[i] = {}

			for j = 0, self.gridHeight - 1 do
				self.gridMatrix[i][j] = 0
			end
		end
	else
		local oldMatrix = copyTableData(self.gridMatrix)

		self.gridMatrix = {}

		for i = 0, self.gridWidth do
			self.gridMatrix[i] = {}

			for j = 0, self.gridHeight do
				if (i < #oldMatrix and j < #oldMatrix[i]) then
					self.gridMatrix[i][j] = oldMatrix[i][j]
				else
					self.gridMatrix[i][j] = 0
				end
			end
		end
		
		if ((self.endPos[1] >= self.gridWidth) or (self.endPos[2] >= self.gridHeight)) then
			self.endPos   = {-1, -1}
		end

		if ((self.startPos[1] >= self.gridWidth) or (self.startPos[2] >= self.gridHeight)) then
			self.startPos   = {-1, -1}
		end
	end
end

function EditorScene:update(dt)
	local xp, yp = love.mouse.getPosition()

	self:updateBlockCursor(xp, yp)

	self.option = self.buttonExec:hover(xp, yp, 1, self.option)
	self.option = self.buttonSave:hover(xp, yp, 2, self.option)
	self.option = self.buttonExit:hover(xp, yp, 3, self.option)
	self.option = self.buttonNew:hover(xp, yp, 4, self.option)
	self.option = self.buttonNext:hover(xp, yp, 5, self.option)
	self.option = self.buttonPrev:hover(xp, yp, 6, self.option)

	self.option = self.buttonAddW:hover(xp, yp, 10, self.option)
	self.option = self.buttonAddH:hover(xp, yp, 11, self.option)
	self.option = self.buttonRemW:hover(xp, yp, 12, self.option)
	self.option = self.buttonRemH:hover(xp, yp, 13, self.option)

	self.option = self.buttonIncT:hover(xp, yp, 14, self.option)
	self.option = self.buttonDecT:hover(xp, yp, 15, self.option)

	self.buttonBUp:hover(xp, yp, 0, 0)
	self.buttonBDown:hover(xp, yp, 0, 0)
	self.buttonBLeft:hover(xp, yp, 0, 0)
	self.buttonBRight:hover(xp, yp, 0, 0)

	self:updateButtons()
end

function EditorScene:drawASquare(x, y, w, h, color)
	love.graphics.setColor(color)
	love.graphics.rectangle("fill", x, y, w, h)
end

function EditorScene:drawSquares()
	local xp = 0
	local yp = 0

	for i = 0, self.gridWidth - 1 do
		for j = 0, self.gridHeight - 1 do
			xp = (i + 1 - self.offSetX)
			yp = (j + 1 - self.offSetY)

			if (self.gridMatrix[i][j] > 0) and xp > 0 and yp > 0 and xp < 27 and yp < 17 then
				self:drawASquare(xp * 32 + leftBarWidth + 1, yp * 32 + topBarHeight + 1, 30, 30, e_colors[self.gridMatrix[i][j]])
			end
		end
	end

	resetColor()

	xp = (self.endPos[1] + 1 - self.offSetX)
	yp = (self.endPos[2] + 1 - self.offSetY)

	if self.endPos[1] > -1 and xp < 27 and yp < 16 then
		love.graphics.draw(i_endflag, xp * 32 + leftBarWidth + 1, yp * 32 + topBarHeight + 1)
	end

	xp = (self.startPos[1] + 1 - self.offSetX)
	yp = (self.startPos[2] + 1 - self.offSetY)

	if self.startPos[1] > -1 and xp < 27 and yp < 16 then
		love.graphics.draw(i_startflag, xp * 32 + leftBarWidth + 1, yp * 32 + topBarHeight + 1)
	end
end

function EditorScene:drawLines()
	love.graphics.setColor(linesColor)

	for i = 1, math.min(#self.gridHLines, 17) do
		love.graphics.line(self.gridHLines[i])
	end

	for i = 1, math.min(#self.gridVLines, 27) do
		love.graphics.line(self.gridVLines[i])
	end

	love.graphics.setFont(f_font8)

	for i = 1, math.min(self.gridWidth, 26) do
		love.graphics.print(i + self.offSetX, (i * 32) + leftBarWidth, topBarHeight + 5)
	end

	for i = 1, math.min(self.gridHeight, 16) do
		love.graphics.print(i + self.offSetY, leftBarWidth + 3, (i * 32) + topBarHeight)
	end

	love.graphics.setFont(f_font16)
end

function EditorScene:drawButtons()
	self.buttonNext:draw()
	self.buttonPrev:draw()

	self.buttonAddW:draw()
	self.buttonAddH:draw()
	self.buttonRemW:draw()
	self.buttonRemH:draw()

	self.buttonIncT:draw()
	self.buttonDecT:draw()

	self:drawBlockCursor()

	self.buttonExec:draw()
	self.buttonSave:draw()
	self.buttonNew:draw()
	self.buttonExit:draw()

	self.buttonGray:draw()
	self.buttonBlue:draw()
	self.buttonGreen:draw()
	self.buttonYellow:draw()
	self.buttonOrange:draw()
	self.buttonRed:draw()
	self.buttonPurple:draw()
	self.buttonEnd:draw()
	self.buttonStart:draw()
	
	if self.offSetY > 0 then
		self.buttonBUp:draw()
	end

	if self.offSetY < self.gridHeight - 16 then
		self.buttonBDown:draw()
	end

	if self.offSetX > 0 then
		self.buttonBLeft:draw()
	end

	if self.offSetX < self.gridWidth - 26 then
		self.buttonBRight:draw()
	end
end

function EditorScene:draw()
	self:drawLines()

	self:drawSquares()

	love.graphics.setColor(barColor)

	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), topBarHeight)
	love.graphics.rectangle("fill", 0, 0, leftBarWidth, love.graphics.getHeight())

	resetColor()

	love.graphics.draw(i_lwidth,  330, 10)
	love.graphics.draw(i_lheight, 330, 35)

	love.graphics.draw(i_mlevel, 540, 10)
	love.graphics.draw(i_mduration, 760, 10)

	drawShadowedText(self.levelDuration, 755, 30, 255, 220, 180)

	drawShadowedText(self.currentLevel, 545, 30, 255, 220, 180)

	self:drawButtons()

	resetColor()
end

function EditorScene:drawBlockCursor()
	local xp, yp = love.mouse.getPosition()

	if xp > leftBarWidth and yp > topBarHeight then
		love.graphics.setColor(cursorColor)

		for i=1, #blockcursor do
			love.graphics.line(blockcursor[i])
		end
	end

	resetColor()
end

function EditorScene:unselectColorButtons()
	for i=1, #self.collorButtons do
		self.collorButtons[i]:selectButton(false)
	end
end

function EditorScene:updateBlockCursor(mouseX, mouseY)
	blockcursor = {}

	for i=1, #baseblockcursor do
		blockcursor[i] = {}
		blockcursor[i][1] = baseblockcursor[i][1] + mouseX
		blockcursor[i][2] = baseblockcursor[i][2] + mouseY
		blockcursor[i][3] = baseblockcursor[i][3] + mouseX
		blockcursor[i][4] = baseblockcursor[i][4] + mouseY
		blockcursor[i][5] = baseblockcursor[i][5] + mouseX
		blockcursor[i][6] = baseblockcursor[i][6] + mouseY
	end
end

function EditorScene:checkSelectButton(button, x, y, newState)
	if button:isClicked(x, y) then
		self:unselectColorButtons()
		button:selectButton(true)
		self.toolState = newState
	end
end

function EditorScene:increaseGridWidth()
	self.gridWidth = self.gridWidth + 1

	self:redoGrid(false)
end

function EditorScene:increaseGridHeight()
	self.gridHeight = self.gridHeight + 1

	self:redoGrid(false)
end

function EditorScene:decreaseGridWidth()
	self.gridWidth = self.gridWidth - 1

	self.gridWidth = IfThen(self.gridWidth > 0, self.gridWidth, 1)

	self:redoGrid(false)
end

function EditorScene:decreaseGridHeight()
	self.gridHeight = self.gridHeight - 1

	self.gridHeight = IfThen(self.gridHeight > 0, self.gridHeight, 1)

	self:redoGrid(false)
end

function EditorScene:changeDuration(increment)
	self.levelDuration = self.levelDuration + increment
end

function EditorScene:doKeyPress(key)

end

function EditorScene:doKeyRelease(key)
	
end

function EditorScene:doMouseMove(x, y, dx, dy)
	if mouseState[1] == true then
		local i = math.floor((x - leftBarWidth) / 32) + self.offSetX
		local j = math.floor((y - topBarHeight) / 32) + self.offSetY

		if i > 0 and j > 0 and i <= self.gridWidth + self.offSetX and j <= self.gridHeight + self.offSetY then
			self.gridMatrix[i-1][j-1] = self.toolState

			if self.toolState == 10 then
				self.endPos = {i-1, j-1}
			end
		end
	end

	if mouseState[2] == true then
		if x > leftBarWidth and y > topBarHeight then
			local i = math.floor((x - leftBarWidth) / 32) + self.offSetX
			local j = math.floor((y - topBarHeight) / 32) + self.offSetY

			if (self.gridMatrix[i-1][j-1] == 10) and (self.endPos[1] == i-1) and (self.endPos[2] == j-1) then
				self.endPos = {-1, -1}
			end

			self.gridMatrix[i-1][j-1] = 0
		end
	end
end

function EditorScene:doMousePress(x, y, button, istouch)
	mouseState[button] = true

	if mouseState[1] == true then
		if self.buttonExec:isClicked(x, y) then
			self.buttonExec:executeClick(self, button)
		end

		if self.buttonSave:isClicked(x, y) then
			self.buttonSave:executeClick(self, button)
		end

		if self.buttonExit:isClicked(x, y) then
			self.buttonExit:executeClick(self, button)
		end

		if self.buttonNew:isClicked(x, y) then
			self.buttonNew:executeClick(self, button)
		end

		if self.buttonNext:isClicked(x, y) then
			self.buttonNext:executeClick(self, button)
		end

		if self.buttonPrev:isClicked(x, y) then
			self.buttonPrev:executeClick(self, button)
		end

		if self.buttonAddW:isClicked(x, y) then
			self.buttonAddW:executeClick(self, button)
		end

		if self.buttonAddH:isClicked(x, y) then
			self.buttonAddH:executeClick(self, button)
		end
		
		if self.buttonRemW:isClicked(x, y) then
			self.buttonRemW:executeClick(self, button)
		end

		if self.buttonRemH:isClicked(x, y) then
			self.buttonRemH:executeClick(self, button)
		end

		if self.buttonIncT:isClicked(x, y) then
			self.buttonIncT:executeClick(self, button)
		end

		if self.buttonDecT:isClicked(x, y) then
			self.buttonDecT:executeClick(self, button)
		end

		if self.buttonBUp:isClicked(x, y) then
			self.buttonBUp:executeClick(self, button)
		end

		if self.buttonBDown:isClicked(x, y) then
			self.buttonBDown:executeClick(self, button)
		end

		if self.buttonBLeft:isClicked(x, y) then
			self.buttonBLeft:executeClick(self, button)
		end

		if self.buttonBRight:isClicked(x, y) then
			self.buttonBRight:executeClick(self, button)
		end

		self:checkSelectButton(self.buttonGray, x, y, 1)
		self:checkSelectButton(self.buttonBlue, x, y, 2)
		self:checkSelectButton(self.buttonGreen, x, y, 3)
		self:checkSelectButton(self.buttonYellow, x, y, 4)
		self:checkSelectButton(self.buttonOrange, x, y, 5)
		self:checkSelectButton(self.buttonRed, x, y, 6)
		self:checkSelectButton(self.buttonPurple, x, y, 7)
		self:checkSelectButton(self.buttonEnd, x, y, 10)
		self:checkSelectButton(self.buttonStart, x, y, 11)

		if x > leftBarWidth and y > topBarHeight then
			local i = math.floor((x - leftBarWidth) / 32) + self.offSetX
			local j = math.floor((y - topBarHeight) / 32) + self.offSetY

			if i > 0 and j > 0 and i <= self.gridWidth + self.offSetX and j <= self.gridHeight + self.offSetY then
				self.gridMatrix[i-1][j-1] = self.toolState

				if self.toolState == 10 then
					if self.endPos[1] > 0 then
						self.gridMatrix[self.endPos[1]][self.endPos[2]] = 1
					end

					self.endPos = {i-1, j-1}
				end

				if self.toolState == 11 then
					if self.startPos[1] > 0 then
						self.gridMatrix[self.startPos[1]][self.startPos[2]] = 1
					end

					self.startPos = {i-1, j-1}
				end
			end
		end
	end

	if mouseState[2] == true then
		if x > leftBarWidth and y > topBarHeight then
			local i = math.floor((x - leftBarWidth) / 32) + self.offSetX
			local j = math.floor((y - topBarHeight) / 32) + self.offSetY

			if (self.gridMatrix[i-1][j-1] == 10) and (self.endPos[1] == i-1) and (self.endPos[2] == j-1) then
				self.endPos = {-1, -1}
			end

			if (self.gridMatrix[i-1][j-1] == 11) and (self.startPos[1] == i-1) and (self.startPos[2] == j-1) then
				self.startPos = {-1, -1}
			end

			self.gridMatrix[i-1][j-1] = 0
		end
	end
end

function EditorScene:doMouseRelease(x, y, button, istouch)
	mouseState[button] = false
end