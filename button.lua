require "utils"

Button = {
	x = 0,
	y = 0,
	selected   = false,
	hovered    = false,
	showSquare = false,
	image      = nil,
	onClick    = nil,
	quadSel    = nil,
	quadUnsel  = nil
}

function Button:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Button:init(newX, newY, newImage, newQuadSel, newQuadUnsel)
	self.x = newX
	self.y = newY

	self.image     = newImage
	self.quadSel   = newQuadSel
	self.quadUnsel = newQuadUnsel
end

function Button:changePosition(newX, newY)
	self.x = newX
	self.y = newY
end

function Button:update(dt)
	self.position = self.position + (self.momentum * dt)
end

function Button:draw()
	if (self.selected) and (self.showSquare) then
		local x, y, w, h = self.quadSel:getViewport()
		love.graphics.rectangle("line", self.x - 1, self.y - 1, w + 1, h + 1)
	end

	if (self.selected) or (self.hovered) then
		love.graphics.draw(self.image, self.quadSel, self.x, self.y)
	else
		love.graphics.draw(self.image, self.quadUnsel, self.x, self.y)
	end
end

function Button:selectButton(isSelected)
	self.selected = isSelected
end

function Button:hover(xPos, yPos, valueIfNotHover, valueIfHover)
	local x, y, w, h = self.quadSel:getViewport()

	self.hovered = containsPoint(xPos, yPos, self.x, self.y, (self.x + w), (self.y + h))

	return IfThen(self.hovered, valueIfNotHover, valueIfHover)
end

function Button:isSelected()
	return self.selected
end

function Button:showSelectSquare(showIt)
	self.showSquare = showIt
end

function Button:isClicked(xPos, yPos)
	local x, y, w, h = self.quadSel:getViewport()

	return containsPoint(xPos, yPos, self.x, self.y, (self.x + w), (self.y + h))
end

function Button:setOnCLick(clickFunction)
	self.onClick = clickFunction
end

function Button:executeClick(sender, button)
	self.onClick(sender, button)
end