require "scene"
require "utils"
require "playscene"
require "howtoscene"
require "editorscene"
require "button"
require "savetable"

MenuScene = Scene:new{
	option = 0,

	buttonPlay   = nil, 
	buttonEditor = nil, 
	buttonHowto  = nil, 
	buttonExit   = nil,

	buttons = {}
}

function MenuScene:init(newManager)
	Scene:init(newManager)

	love.graphics.setBackgroundColor(5, 5, 10)

	quad1 = love.graphics.newQuad(0, 0, 185, 38, i_mjogar:getDimensions())
	quad2 = love.graphics.newQuad(0, 40, 185, 35, i_mjogar:getDimensions())

	self.buttonPlay = Button:new{}
	self.buttonPlay:init(420, 350, i_mjogar, quad1, quad2)
	self.buttonPlay:setOnCLick( 
		function (sender)
			sender.gameManager:changeToScene(PlayScene:new{})
		end )

	self.buttonHowto = Button:new{}
	self.buttonHowto:init(420, 430, i_mhowto, quad1, quad2)
	self.buttonHowto:setOnCLick( 
		function (sender)
			sender.gameManager:changeToScene(HowToScene:new{})
		end )

	self.buttonEditor = Button:new{}
	self.buttonEditor:init(420, 510, i_meditor, quad1, quad2)
	self.buttonEditor:setOnCLick( 
		function (sender) 
			sender.gameManager:changeToScene(EditorScene:new{})
		end )

	self.buttonExit = Button:new{}
	self.buttonExit:init(420, 590, i_msair, quad1, quad2)
	self.buttonExit:setOnCLick( 
		function (sender) 
			love.event.quit()
		end )

	self.buttons[0] = self.buttonPlay
	self.buttons[1] = self.buttonHowto
	self.buttons[2] = self.buttonEditor
	self.buttons[3] = self.buttonExit

	self:updateButtons()
end

function MenuScene:update(dt)
	local xp, yp = love.mouse.getPosition()

	self.option = self.buttonPlay:hover(xp, yp, 0, self.option)
	self.option = self.buttonHowto:hover(xp, yp, 1, self.option)
	self.option = self.buttonEditor:hover(xp, yp, 2, self.option)
	self.option = self.buttonExit:hover(xp, yp, 3, self.option)

	self:updateButtons()
end

function MenuScene:draw()
	love.graphics.draw(i_title, love.graphics.getWidth() / 2 - 450, 40)

	love.graphics.setFont(f_font8)

	drawShadowedText("Versao " .. version, 16, love.graphics.getHeight() - 42, 100, 230, 30)

	self.buttonPlay:draw()
	self.buttonHowto:draw()
	self.buttonEditor:draw()
	self.buttonExit:draw()
end

function MenuScene:doKeyPress(key)
	if key == 'return' then
		self.buttons[self.option]:executeClick(self, button)
	end

	if key == 'up' then
		self.option = self.option - 1
	end

	if key == 'down' then
		self.option = self.option + 1
	end

	self.option = IfThen(self.option < 0, 0, IfThen(self.option > 3, 3, self.option))

	self:updateButtons()
end

function MenuScene:updateButtons()
	self.buttonPlay:selectButton(self.option == 0)
	self.buttonHowto:selectButton(self.option == 1)
	self.buttonEditor:selectButton(self.option == 2)
	self.buttonExit:selectButton(self.option == 3)
end

function MenuScene:doKeyRelease(key)
	
end

function MenuScene:doMousePress(x, y, button, istouch)
	if self.buttonPlay:isClicked(x, y) then
		self.buttonPlay:executeClick(self, button)
	end

	if self.buttonHowto:isClicked(x, y) then
		self.buttonHowto:executeClick(self, button)
	end

	if self.buttonEditor:isClicked(x, y) then
		self.buttonEditor:executeClick(self, button)
	end

	if self.buttonExit:isClicked(x, y) then
		self.buttonExit:executeClick(self, button)
	end
end