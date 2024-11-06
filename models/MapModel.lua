require "utils/strings"

local MapModel = {}
function CellModel:new(view)
	local o = setmetatable({__instanceof=self}, self)
	self.__index = self
	

	return o
end

function MapModel:init()

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