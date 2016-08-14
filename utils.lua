require "resources"

mouseState = {
	false,
	false,
	false
}

function IfThen(condition, firstValue, secondValue)
	if condition then return firstValue else return secondValue	end
end

function resetColor()
	love.graphics.setColor(255, 255, 255)
end

function containsPoint(x, y, startX, startY, endX, endY)
	local value = (
		x > startX and 
		y > startY and
		x < endX   and
		y < endY
	)

	return value
end

function rotateTable(oldTable)
	newTable = {}

	local w = #oldTable
	local h = #oldTable[0]

	for i = 0, w do
		newTable[i] = {}

		k = h - 1

		for j = 0, h do
			newTable[i][k] = oldTable[i][j]
			k = k - 1
		end

		newTable[i][h] = 0
	end

	return newTable
end

function copyTableData(sourceTable)
	newTable = {}

	local w = #sourceTable
	local h = #sourceTable[0]

	for i = 0, w do
		newTable[i] = {}

		for j = 0, h do
			newTable[i][j] = sourceTable[i][j]
		end
	end
	
	return newTable
end

function drawShadowedText(text, x, y, red, green, blue, alpha)
	red   = red or 255
	green = green or 255
	blue  = blue or 255
	alpha = alpha or 255

	love.graphics.setColor(0, 0, 0, 80)
	love.graphics.print(text, x + 2, y + 2)
	love.graphics.setColor(red, green, blue, alpha)
	love.graphics.print(text, x, y)
	resetColor()
end