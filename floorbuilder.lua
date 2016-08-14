require "floor"
require "exitfloor"

function BuildFloor(x, y, kind, isStart)
	theFloor = Floor:new{}
	theFloor:init(50 + (y * 32) + (x * 32), 200 + (x * 16) - (y * 16), kind, isStart)
	return theFloor
end

function BuildExitFloor(x, y, kind)
	theFloor = ExitFloor:new{}
	theFloor:init(50 + (y * 32) + (x * 32), 200 + (x * 16) - (y * 16), kind, false)	
	return theFloor
end