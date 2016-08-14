require "scene"
require "level"
require "cube"
require "hud"
require "utils"


HowToScene = Scene:new{
	option = 0,
	buttonExit = nil
}

function HowToScene:init(newManager)
	Scene:init(newManager)

	love.graphics.setBackgroundColor(10, 0, 20)
	love.graphics.setLineWidth(2)

	local quad1 = love.graphics.newQuad(0, 0, 50, 50, i_mexec:getDimensions())
	local quad2 = love.graphics.newQuad(50, 0, 50, 50, i_mexec:getDimensions())

	self.buttonExit = Button:new{}
	self.buttonExit:init(930, 580, i_mexit, quad1, quad2)
	self.buttonExit:setOnCLick( 
		function (sender)
			sender.gameManager:closeCurrentScene()
		end )
end

function HowToScene:update(dt)
	local xp, yp = love.mouse.getPosition()

	self.option = self.buttonExit:hover(xp, yp, 1, self.option)

	self.buttonExit:selectButton(self.option == 1)
end

function HowToScene:draw()
	love.graphics.draw(i_howto, 5, 5)

	self.buttonExit:draw()

	resetColor()
end

function HowToScene:doMousePress(x, y, button, istouch)
	mouseState[button] = true

	if mouseState[1] == true then
		if self.buttonExit:isClicked(x, y) then
			self.buttonExit:executeClick(self, button)
		end
	end
end

function HowToScene:doMouseRelease(x, y, button, istouch)
	mouseState[button] = false
end