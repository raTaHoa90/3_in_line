local Class     = require "utils/classes"
local CellModel = require "models/CellModel"
local Vector2   = require "models/Vector2"

local MAX_TYPE_ELEMENT = 6
local MapModel = Class:Extend();

function MapModel:construct(view)
	self.renderer = view;
end

------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------

function MapModel:init()
	self.width = self.renderer.width;
	self.height = self.renderer.height;

	self.map = {}
    for y = self.height, 1, -1 do
        self.map[y] = {};
        for x = 1, self.width do
			local nextFlow
			if y < self.height then
				nextFlow = self.map[y+1][x]
			else
				nextFlow = nil
			end

            self.map[y][x] = CellModel:new(nextFlow, Vector2:new(x, y));
			self.map[y][x]:init(MAX_TYPE_ELEMENT)
        end
    end
end

function MapModel:tick()
	for y = 1, self.height do
        for x = 1, self.width do
			self.map[y][x]:tick()
		end
	end
end

function MapModel:move(from, to)

end

function MapModel:mix()

end

function MapModel:dump()
	for y = 1, self.height do
        for x = 1, self.width do
			self.map[y][x]:dump(self.renderer)
		end
	end
end

------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------

return MapModel;