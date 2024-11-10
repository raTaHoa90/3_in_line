local Class       = require "utils.classes"
local Vector2     = require "models.Vector2"
local CellModel   = require "models.CellModel"
local LineChecker = require "models.LineChecker"
local LevelBaseModel = Class:Extend()

function LevelBaseModel:construct()
    self.lines = {}
end

function LevelBaseModel:LevelInit(mapModel)
    for y = 1, mapModel.height do
        mapModel.map[y] = {}
        for x = 1, mapModel.width do
			local cell = CellModel:new(nil, Vector2:new(x, y))

            cell:init()

            mapModel.map[y][x] = cell
			self:AddCell(cell)
        end
    end
end

function LevelBaseModel:AddLine()
    local line = LineChecker:new()
    table.insert(self.lines, line)
    return line
end

function LevelBaseModel:AddCell(cell)
    self.lines[#self.lines].Add(cell)
end

function LevelBaseModel:ReduceLines(func, baseValue)
    local result = baseValue or nil;
    if type(func) == "function" then 
        for _, line in ipairs(self.lines) do
            result = func(result, line)
        end
    end
    return result
end

function LevelBaseModel:FillEmptyCell()
    for _, line in ipairs(self.lines) do
        for _, cell in ipairs(line.line) do
            if cell.letter == 0 then 
                cell.init()
            end
        end
    end
end

function LevelBaseModel:hasStepToLine(x, y, letter)
    for _, line in ipairs(self.lines) do
        if line[0].position.x == x and line[1].position.x == x then
            return line:testNextStepChecked(y, letter)
        elseif line[0].position.y == y and line[1].position.y == y then
            return line:testNextStepChecked(x, letter)
        end
    end
    return false
end

local function testAllLines(lastResult, line)
    return line:Test() or lastResult
end

function LevelBaseModel:AllTest()
    return self:ReduceLines(testAllLines, false)
end

local function linesAllCutChecked(lastScore, line)
    return lastScore + line:CutChecked()
end

function LevelBaseModel:AllCutChecked()
    return self:ReduceLines(linesAllCutChecked, 0)
end

function LevelBaseModel:debug()
    for i, line in ipairs(self.lines) do
        print(i..": ".. line:debug())
    end
end


return LevelBaseModel