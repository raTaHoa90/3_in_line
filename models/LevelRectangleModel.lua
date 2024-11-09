local LevelBaseModel = require "models.LevelBaseModel"
local LevelRectangleModel = LevelBaseModel:Extend();

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

return LevelRectangleModel
