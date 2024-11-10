require "utils.constants"
local Class = require "utils.classes"
local AnimationSystem = require "systems.AnimationSystem"
local BaseItemModel = Class:Extend()

function BaseItemModel:construct(animNum, viewchar)
    self.animate = animNum
    self.viewchar = viewchar
    self.status = ANIMATION_STATUS_STOP
end

function BaseItemModel:tick(progress, status)
    if status == ANIMATION_STATUS_START or progress == nil then
        progress = AnimationSystem:Get(self.animate):startValue()
        status = ANIMATION_STATUS_RUN
    elseif status == ANIMATION_STATUS_RUN and progress ~= nil then
        progress = AnimationSystem:Get(self.animate):nextValue(progress)
        if progress == nil then
            status = ANIMATION_STATUS_STOP
        end
    elseif status ~= ANIMATION_STATUS_STOP then
        status = ANIMATION_STATUS_STOP
        progress = nil
    end
    return progress, status
end

-- событие которое будет срабатывать, если сам элемент будет перенесен
function BaseItemModel:onMoved(fromPos, toPos, map)
end

-- событие которое будет срабатывать, если рядом с этим элементом произойдет сбор элементов
function BaseItemModel:onNearCut(thisPos, cutPos, map)
end

function BaseItemModel:hasRange(progress)
    return AnimationSystem:Get(self.animate):hasRange(progress)
end

function BaseItemModel:toDump(progress)
    local anim = AnimationSystem:Get(self.animate);
    if progress and anim and anim:hasRange(progress) then
        return anim:toDump(progress)
    else
        return self.viewchar
    end
end


return BaseItemModel