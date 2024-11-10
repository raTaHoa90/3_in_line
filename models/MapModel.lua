local Class      = require "utils.classes"
local Vector2    = require "models.Vector2"
local ItemSystem = require "systems.ItemSystem"

local MapModel = Class:Extend()

function MapModel:construct(view, levelModel)
	self.renderer    = view
	self.level       = levelModel
	self.isMoved     = false
	self.isAnimate   = false
	self.isEmptyCell = false
	self.score       = 0
	self.steps       = 0
end

function MapModel:isNotLoop()
	return not self.isMoved and not self.isAnimate and not self.isEmptyCell
end

function MapModel:onNearCut(x,y)
	local thisPos = Vector2:new(x, y)
	if x > 1 then
		self.map[y][x - 1]:ItemOnNearCut(Vector2:new(y, x - 1), thisPos, self)
	end

	if x < self.width then
		self.map[y][x + 1]:ItemOnNearCut(Vector2:new(y, x + 1), thisPos, self)
	end

	if y > 1 then
		self.map[y - 1][x]:ItemOnNearCut(Vector2:new(y - 1, x), thisPos, self)
	end

	if y < self.height then
		self.map[y + 1][x]:ItemOnNearCut(Vector2:new(y + 1, x), thisPos, self)
	end
end

function MapModel:tickCell(cell)
	if cell:hasAnimationStart() then
		self:onNearCut(cell.position.x, cell.position.y)
	end

	cell:tick()
	if cell:hasAnimationRun() then 
		self.isAnimate = true;
	elseif cell:hasEmpty() then
		self.isEmptyCell = true
	end 
end

function MapModel:cellXCHG(x1,y1, x2,y2)
	local cell1 = self.map[y1][x1]
	local cell2 = self.map[y2][x2]
	cell1.letter, cell2.letter = cell2.letter, cell1.letter
end

function MapModel:countStepsByXY(x, y, letter)
	local result = 0

	if  x > 1 then
		self:cellXCHG(x,y, x-1,y)
		if self.level:hasStepToLine(x - 1, y, letter) then result = result + 1 end
		self:cellXCHG(x,y, x-1,y)
	end

	if  y > 1 then
		self:cellXCHG(x,y, x,y-1)
		if self.level:hasStepToLine(x, y - 1, letter) then result = result + 1 end
		self:cellXCHG(x,y, x,y-1)
	end

	if  x < self.width then
		self:cellXCHG(x,y, x+1,y)
		if self.level:hasStepToLine(x + 1, y, letter)  then result = result + 1 end
		self:cellXCHG(x,y, x+1,y)
	end

	if y < self.height then 
		self:cellXCHG(x,y, x,y+1)
		if self.level:hasStepToLine(x, y + 1, letter) then result = result + 1 end
		self:cellXCHG(x,y, x,y+1)
	end

	return result
end

function MapModel:countSteps()
	local result = 0
	for y = 1, self.height do
		for x = 1, self.width do
			result = result + self:countStepsByXY(x, y, self.map[y][x].letter)
		end
	end
	return result
end

------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------

function MapModel:init()
	self.width = self.renderer.width
	self.height = self.renderer.height

	self.map = {}
	self.level:LevelInit(self)
end

function MapModel:tick()
	self.isAnimate = false
	self.isEmptyCell = false
	for y = self.height, 1, -1 do
        for x = 1, self.width do
			self:tickCell(self.map[y][x])
		end
	end
	
	if self.isEmptyCell then 
		self.level:FillEmptyCell()
	
	else
		self.isMoved = self.level:AllTest()
		if self.isMoved then 
			local score = self.level:AllCutChecked()
			if score > 0 then 
				self.score = self.score + score
				self.renderer:setScore(self.score)
			end
		else
			self.steps = self:countSteps()
			self.renderer:setSteps(self.steps)
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
		self:cellXCHG(from.x, from.y, newPos.x, newPos.y)

		ItemSystem:Get(self.map[from.y]  [from.x]  .letter):onMoved(newPos, from, self)
		ItemSystem:Get(self.map[newPos.y][newPos.x].letter):onMoved(from, newPos, self)
	end
end

function MapModel:mix()
	repeat
		for y = 1, self.height do
			for x = 1, self.width do
				self:cellXCHG(x,y, math.random(self.width), math.random(self.height))
			end
		end
		self.steps = self:countSteps()
	until not self.level:AllTest() and self.steps > 0
	self.renderer:setSteps(self.steps)
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

return MapModel