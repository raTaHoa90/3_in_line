local Class   = require "utils.classes"
require "utils.strings"
local AnimationSystem = require "systems.AnimationSystem"
local ItemSystem      = require "systems.ItemSystem"

local ConsoleView = Class:Extend();

function ConsoleView:construct(width, height)
    self.map = {}
    self.width  = width;
    self.height = height;
    self.score = 0;
    self.maxScore = 50;
    self.isDraw = false
    for y = 1, height do
        self.map[y] = {};
        for x = 1, width do
            self.map[y][x] = 0;
        end
    end
end

function ConsoleView:setScore(score)
    self.score = score;
    if score > self.maxScore then
        self.maxScore = score;
    end
end

function ConsoleView:write(x, y, letter)
    self.map[y][x] = letter;
end

function ConsoleView:getLetterDraw(x, y)
    local item = ItemSystem:FindByValue(self.map[y][x])
    local letter = " ";
    if item then
        letter = ItemSystem:Get(item):toDump(self.map[y][x])
    end
    return letter
end


function ConsoleView:Draw()
    self.isDraw = true;
    os.execute("cls");

    local line = "   ";
    for i = 0, self.width - 1 do
        line = line .. i .. " " ;
    end
    print(line);

    line = "   ";
    for i = 0, self.width - 1 do
        line = line .. "_ " ;
    end
    print(line);
    
    for y = 1, self.height do
        if y < 11 then 
            line = " "..(y - 1)..'|';
        else
            line = (y - 1).."|";
        end

        for x = 1, self.width do
            line = line..self:getLetterDraw(x, y).." "
        end
        print(line);
        print()
    end

    print();
    print("Score: "..self.score.." / "..self.maxScore);
    print("HELP:")
    print("    m <x> <y> <arrow(l|r|u|d)> = move");
    print("    c or q = quit")
    print("_________________")
    io.write("> ");

    self.isDraw = false;
end


return ConsoleView;