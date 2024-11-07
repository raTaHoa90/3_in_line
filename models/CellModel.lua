local Class = require "utils/classes"
local CellModel = Class:Extend();

function CellModel:construct(nextFlow, position)
    self.nextFlow = nextFlow;
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

    if self.nextFlow:flow() then
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
            self.letter = -2
        else
            self.letter = self.letter + 1
        end
    else
        self.animCollapse = false;
    end
end



return CellModel;