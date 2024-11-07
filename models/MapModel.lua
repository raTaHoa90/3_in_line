local Class = require "utils/classes"
local MapModel = Class:Extend();

function MapModel:construct(view)
	self.renderer = view;
end

function MapModel:init()
	self.width = self.renderer.width;
	self.height = self.renderer.height;
end

function MapModel:tick()

end

function MapModel:move(from, to)

end

function MapModel:mix()

end

function MapModel:dump()

end

return MapModel;