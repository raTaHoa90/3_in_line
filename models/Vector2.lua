local Class   = require "utils.classes"
local Vector2 = Class:Extend();

function Vector2:construct(x, y)
    self.x = x;
    self.y = y;
end

return Vector2;