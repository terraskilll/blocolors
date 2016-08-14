require "floor"
require "exitfloor"
require "floorbuilder"

AllLevels = {}

Level = {
	width       = 0,
	height      = 0,
	duration    = 0,
	floorMatrix = {},
	floors      = {},
	startFloor  = { x = 0, y = 0 }
}

function Level:new(o)
	o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Level:init(newFloorMatrix, newDuration)
	newDuration      = newDuration or 10

	self.width       = #newFloorMatrix
	self.height      = #newFloorMatrix[1]
	self.floorMatrix = newFloorMatrix
	self.duration    = newDuration

	for i=0,self.width do
        self.floors[i] = {}

        for j=0, self.height do
			self:createFloor(i, j, self.floorMatrix[i][j])
        end
    end
end

function Level:update(dt)
	for i=0, self.width - 1 do
        for j=0, self.height - 1 do
            self.floors[i][j]:update(dt)
        end
    end
end

function Level:draw()
	a = 1

	love.graphics.setFont(f_font8)

	for i=0,self.width - 1 do
        for j=self.height - 1, 0, -1 do
            self.floors[i][j]:draw()
			--love.graphics.print(i .. "x" .. j, self.floors[i][j].position.x + 10, self.floors[i][j].position.y + 15)
			self.floors[i][j]:setDNumber(a)
			a = a + 1
        end
    end
end

function Level:setMatrix(newMatrix)
	self.floorMatrix = newMatrix
end

function Level:createFloor(x, y, kind)
	if kind == 10 then
		self.floors[x][y] = BuildExitFloor(x, y, kind)
	else
		self.floors[x][y] = BuildFloor(x, y, IfThen(kind == 11, 1, kind), kind == 11)
	end
end

function Level:setStartFloor(newX, newY)
	self.startFloor.x = newX
	self.startFloor.y = newY
end

function Level:setEndFloor(x, y)
	self.floors[x][y] = 10
end

function Level:getStartFloor()
	for i=0, self.width - 1 do
        for j=0, self.height - 1 do
            if self.floors[i][j]:isStartFloor() then
				return i, j
			end
        end
    end

	return 0, 0
end

function Level:canGo(x, y)
	canGo = (
		(x >= 0) and (y >= 0) and
		(x < self.width) and (y < self.height) and
		(self.floorMatrix[x][y] > 0)
	)

	return canGo
end

function Level:getFloorPosition(x, y)
	return self.floors[x][y]:getPosition()
end

function Level:getFloorKind(x, y)
	return self.floors[x][y]:getKind()
end

function Level:teleportFloors(xInc, yInc)
	for i=0, self.width - 1 do
        for j=0, self.height - 1 do
			self.floors[i][j]:teleport(xInc, yInc)
        end
    end
end

function Level:getDuration()
	return self.duration
end