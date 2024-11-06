require "utils/classes"
--local Vector2 = require "models/Vector2"
local CellModel = Class:Extend();

function CellModel:construct(nextFlow)
    self.nextFlow = nextFlow;
    self.letter = " ";
end

function CellModel:hasEmpty()
    return self.letter == " ";
end

function CellModel:flow()
    self.nextFlow:flow();
    if self.nextFlow:hasEmpty() then
        self.nextFlow.letter = self.letter;
        self.letter = " "
    end
end

return CellModel;