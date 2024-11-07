local Class     = require "utils.classes"
local CellModel = require "models.CellModel"
local Vector2   = require "models.Vector2"

local MAX_TYPE_ELEMENT = 6
local MapModel = Class:Extend();

function MapModel:construct(view, levelModel)
	self.renderer = view;
	self.level = levelModel;
	self.isMoved = false;
	self.isAnimate = false;
	self.isEmptyCell = false;
	self.score = 0;
end

function MapModel:isNotLoop()
	return not self.isMoved and not self.isAnimate and not self.isEmptyCell
end

------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------

function MapModel:init()
	self.width = self.renderer.width;
	self.height = self.renderer.height;

	self.map = {}
    for y = self.height, 1, -1 do
        self.map[y] = {};
        for x = 1, self.width do
			local nextFlow
			if y < self.height then
				nextFlow = self.map[y+1][x]
			else
				nextFlow = nil
			end

            self.map[y][x] = CellModel:new(nextFlow, Vector2:new(x, y));
			self.map[y][x]:init(MAX_TYPE_ELEMENT)
			self.level:AddCell(self.map[y][x])
        end
    end
end

function MapModel:tick()
	self.isAnimate = false;
	self.isEmptyCell = false;
	for y = self.height, 1, -1 do
        for x = 1, self.width do
			self.map[y][x]:tick()
			if self.map[y][x].animCollapse then 
				self.isAnimate = true;
			elseif self.map[y][x].letter <= 0 then
				self.isEmptyCell = true
			end 
		end
	end
	if not self.isEmptyCell then 
		self.isMoved = self.level:ReduceLines(function(lastResult, line)
			return line:Test() or lastResult
		end, false)

		local score = self.level:ReduceLines(function(lastScore, line)
			return lastScore + line:CutChecked()
		end, 0)
		if score > 0 then 
			self.score = self.score + score
			self.renderer:setScore(self.score);
		end
	end
end

function MapModel:move(from, to)
	local newPos = nil
	if to == "r" and from.x < self.width then
		newPos = Vector2:new(from.x + 1, from.y)
	elseif to == "l" and from.x > 1 then
		newPos = Vector2:new(from.x - 1, from.y)
	elseif to == "u" and from.y > 1 then
		newPos = Vector2:new(from.x, from.y - 1)
	elseif to == "d" and from.y < self.height then
		newPos = Vector2:new(from.x, from.y + 1)
	end
	if newPos then 
		self.map[from.y][from.x].letter, 
		self.map[newPos.y][newPos.x].letter = 
			self.map[newPos.y][newPos.x].letter, 
			self.map[from.y][from.x].letter
	end
end

function MapModel:mix()

end

function MapModel:dump()
	for y = 1, self.height do
        for x = 1, self.width do
			self.map[y][x]:dump(self.renderer)
		end
	end
end

------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------

return MapModel;