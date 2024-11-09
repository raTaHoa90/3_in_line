local BaseItemModel = require "models.Items.BaseItemModel"
local ItemDModel = BaseItemModel:Extend()

function ItemDModel:construct(animNum)
    self:Parent().construct(self, animNum, "D")
end

return ItemDModel