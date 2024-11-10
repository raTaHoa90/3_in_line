require "utils.constants"
local Class         = require "utils.classes"
local ItemSystem    = require "systems.ItemSystem"
local CellModel = Class:Extend();

function CellModel:construct(nextCellFlow, position)
    self.nextFlow = nextCellFlow;
    self.letter = 0;
    self.position = position
    self.progress = nil
    self.status = ANIMATION_STATUS_STOP
end

function CellModel:hasEmpty()
    return self.letter == 0;
end

function CellModel:flow()
    if self:hasEmpty() then return true; end

    if self.nextFlow and self.nextFlow:hasEmpty() then
        self.nextFlow.letter = self.letter;
        self.letter = 0
        return true;
    end
    return false;
end

function CellModel:init()
    self.letter = ItemSystem:RandomNum()
end

function CellModel:dump(renderer)
    if type(renderer.write) == "function" then
        local letter = self.letter
        if self.progress then 
            letter = self.progress
        end
        renderer:write(self.position.x, self.position.y, letter);
    end
end

function CellModel:hasAnimationRun()
    return self.status ~= ANIMATION_STATUS_STOP
end

function CellModel:hasAnimationStart()
    return self.status == ANIMATION_STATUS_START
end

function CellModel:StartAimationCollapse()
    if self:hasEmpty() or self.status == ANIMATION_STATUS_RUN  then return end
    self.progress = nil
    self.status = ANIMATION_STATUS_START
end

function CellModel:tick()
    if self:hasEmpty() then return end

    if self:hasAnimationRun() then
        local item = self:GetItem();
        if item then
            self.progress, self.status = item:tick(self.progress, self.status)
        else
            self.status = ANIMATION_STATUS_STOP
            self.progress = nil
        end
        
        if self.status == ANIMATION_STATUS_STOP or self.progress == nil then 
            self.letter = 0
        end
    else
        self:flow()
    end
end

function CellModel:GetItem()
    return ItemSystem:Get(self.letter);
end

function CellModel:ItemOnNearCut(thisPos, cutPos, map)
    local item = self:GetItem()
    if item then
        item:onNearCut(thisPos, cutPos, map)
    end
end

return CellModel;