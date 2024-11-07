local Class   = require "utils.classes"
require "utils.strings"

local ConsoleView = Class:Extend();

local MAP_ITEM_TO_STR = {
    [-4] = "#",
    [-3] = "*",
    [-2] = "+",
    [-1] = "-",
    [0] = " ",
    [1] = "A",
    [2] = "B",
    [3] = "C",
    [4] = "D",
    [5] = "E",
    [6] = "F"
}

function ConsoleView:construct(width, height)
    self.map = {}
    self.width  = width;
    self.height = height;
    self.score = 0;
    self.maxScore = 50;
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


function ConsoleView:Draw()
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
            line = line..MAP_ITEM_TO_STR[self.map[y][x]].." "
        end
        print(line);
        print()
    end

    print();
    print("Score: "..self.score.." / "..self.maxScore);
    print("HELP:")
    print("    m <x> <y> <arrow(r|l|u|d)> = move");
    print("    c or q = exit")
    print("____________")
    io.write("> ");
end


return ConsoleView;