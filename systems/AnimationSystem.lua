local AnimatorModel = require "models.AnimatorModel"

local AnimationSystem = {}

function AnimationSystem:init()
    self.allAnimates = {}
end

function AnimationSystem:Add(animTable, indexKeys)
    table.insert(self.allAnimates, AnimatorModel:new(animTable, indexKeys))
    return #self.allAnimates
end

function AnimationSystem:Get(num)
    return self.allAnimates[num]
end

function AnimationSystem:FindByValue(value)
    for i, animate in ipairs(self.allAnimates) do
        if animate:hasRange(value) then
            return i
        end
    end
    return nil
end

AnimationSystem:init()

return AnimationSystem