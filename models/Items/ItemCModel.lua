local BaseItemModel = require "models.Items.BaseItemModel"
local ItemCModel = BaseItemModel:Extend()

function ItemCModel:construct(animNum)
    self:Parent().construct(self, animNum, "C")
end

return ItemCModel