local BaseItemModel = require "models.Items.BaseItemModel"
local ItemBModel = BaseItemModel:Extend()

function ItemBModel:construct(animNum)
    self:Parent().construct(self, animNum, "B")
end

return ItemBModel