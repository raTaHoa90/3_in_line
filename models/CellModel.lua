local Class = require "utils.classes"
local CellModel = Class:Extend();
local ANIMATED_START = -4

function CellModel:construct(nextCellFlow, position)
    self.nextFlow = nextCellFlow;
    self.letter = 0;
    self.animCollapse = false;
    self.position = position
end

function CellModel:hasEmpty()
    return self.letter <= 0;
end

function CellModel:flow()
    if self.letter == 0 then
        return true;
    end

    if self.nextFlow and self.nextFlow.letter == 0 then
        self.nextFlow.letter = self.letter;
        self.letter = 0
        return true;
    end
    return false;
end

function CellModel:init(max)
    self.letter = math.random(max)
end

function CellModel:dump(renderer)
    if type(renderer.write) == "function" then
        renderer:write(self.position.x, self.position.y, self.letter);
    end
end

function CellModel:StartAimationCollapse()
    self.animCollapse = true;
end

function CellModel:tick()
    if self.animCollapse then
        if self.letter > 0 then
            self.letter = ANIMATED_START
        else
            self.letter = self.letter + 1
            if self.letter == 0 then
                self.animCollapse = false;
            end
        end
    else
        self.animCollapse = false;
        self:flow()
    end
end



return CellModel;