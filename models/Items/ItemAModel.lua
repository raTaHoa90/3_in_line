local BaseItemModel = require "models.Items.BaseItemModel"
local ItemAModel = BaseItemModel:Extend()

function ItemAModel:construct(animNum)
    self:Parent().construct(self, animNum, "A")
end

return ItemAModel