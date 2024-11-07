local Class = require "utils.classes"
local LineChecker = require "models.LineChecker"
local LevelBaseModel = Class:Extend();

function LevelBaseModel:construct()
    self.lines = {}
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
            result = func(result, line);
        end
    end
    return result;
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

function LevelBaseModel:debug()
    for i, line in ipairs(self.lines) do
        print(i..": ".. line:debug());
    end
end


return LevelBaseModel