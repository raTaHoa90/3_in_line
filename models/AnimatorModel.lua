local Class = require "utils.classes"
local AnimatorModel = Class:Extend();


function AnimatorModel:construct(animTable, indexKeys)
    self.animates = animTable;
    self.sortedindex = indexKeys
end

function AnimatorModel:hasRange(value)
    for num, _ in pairs(self.animates) do
        if num == value then
            return true
        end
    end
    return false
end

function AnimatorModel:startValue()
    local _, num
    _, num = next(self.sortedindex)
    return num
end

function AnimatorModel:nextValue(value)
    local _next = false
    for _, num in ipairs(self.sortedindex) do
        if _next then 
            return num 
        elseif num == value then
            _next = true
        end
    end
    return nil
end

function AnimatorModel:toDump(value)
    for num, dump in pairs(self.animates) do
        if num == value then
            return dump
        end
    end
    return " "
end


return AnimatorModel