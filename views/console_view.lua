local ConsoleView = {}
function ConsoleView:new()
	local o = setmetatable({__instanceof=self}, self)
	self.__index = self
	


	return o
end


return ConsoleView;