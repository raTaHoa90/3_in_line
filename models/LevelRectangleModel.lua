local CellModel      = require "models.CellModel"
local LevelBaseModel = require "models.LevelBaseModel"
local Vector2        = require "models.Vector2"
local LevelRectangleModel = LevelBaseModel:Extend()

function LevelRectangleModel:construct(width, height)
    self:Parent().construct(self)

    self.width = width
    self.height = height
    self.verticalLines = {}
    self.horizontalLines = {}

    for i = 1, width do
        self:AddLineVertical()
    end

    for i = 1, height do
        self:AddLineHorizontal()
    end
end

function LevelRectangleModel:AddLineVertical()
    local line = self:AddLine()
    table.insert(self.verticalLines,line)
end

function LevelRectangleModel:AddLineHorizontal()
    local line = self:AddLine()
    table.insert(self.horizontalLines,line)
end

function LevelRectangleModel:AddCell(cell)
    local pos = cell.position
    self.verticalLines[pos.x]:Add(cell)
    self.horizontalLines[pos.y]:Add(cell)
end

function LevelRectangleModel:FillEmptyCell()
    for _, cell in ipairs(self.horizontalLines[1].line) do
        if cell:hasEmpty() then 
            cell:init()
        end
    end
end

function LevelRectangleModel:getLinesByXY(x,y)
    local result = {}
    if x > 0 and x <= #self.verticalLines then
        table.insert(result, self.verticalLines[x])
    end
    if y > 0 and y <= #self.horizontalLines then
        table.insert(result, self.horizontalLines[y])
    end
    return result
end

function LevelRectangleModel:LevelInit(mapModel)
    for y = self.height, 1, -1 do
        mapModel.map[y] = {}
        for x = 1, self.width do
            local nextFlow
			if y < self.height then
				nextFlow = mapModel.map[y+1][x]
			else
				nextFlow = nil
			end

			local cell = CellModel:new(nextFlow, Vector2:new(x, y))

            cell:init()

            mapModel.map[y][x] = cell
			self:AddCell(cell)
        end
    end
end

function LevelRectangleModel:hasStepToLine(x, y, letter)
    local result = false
    if x > 0 and x <= #self.verticalLines then
        result = self.verticalLines[x]:testNextStepChecked(y, letter)
    end
    if not result and y > 0 and y <= #self.horizontalLines then
        result = self.horizontalLines[y]:testNextStepChecked(x, letter)
    end
    
    return result
end

return LevelRectangleModel
