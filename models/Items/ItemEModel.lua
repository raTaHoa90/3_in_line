local BaseItemModel = require "models.Items.BaseItemModel"
local ItemEModel = BaseItemModel:Extend()

function ItemEModel:construct(animNum)
    self:Parent().construct(self, animNum, "E")
end

return ItemEModel