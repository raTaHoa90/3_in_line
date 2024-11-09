local BaseItemModel   = require "models.Items.BaseItemModel"
local ItemSystem = {}

function ItemSystem:init()
    self.allItems = {}
end

function ItemSystem:Add(ItemClass)
    if ItemClass:InstanceOf(BaseItemModel) then
        table.insert(self.allItems, ItemClass)
        return #self.allItems
    end
    return nil
end

function ItemSystem:Get(num)
    return self.allItems[num];
end

function ItemSystem:RandomNum()
    return math.random(#self.allItems)
end

function ItemSystem:FindByValue(value)
    for i, item in ipairs(self.allItems) do
        if i == value or item:hasRange(value) then
            return i
        end
    end
    return nil
end


ItemSystem:init()

return ItemSystem