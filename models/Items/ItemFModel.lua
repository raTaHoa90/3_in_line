local BaseItemModel = require "models.Items.BaseItemModel"
local ItemFModel = BaseItemModel:Extend()

function ItemFModel:construct(animNum)
    self:Parent().construct(self, animNum, "F")
end

return ItemFModel