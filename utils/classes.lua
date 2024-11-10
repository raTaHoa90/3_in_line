local Class = {}

function Class:Class()
    return getmetatable(self).__index
end

function Class:Parent()
    return getmetatable(self:Class()).__index
end

function Class.InstanceOf(object, class)
    if type(object) ~= "table" or type(class) ~= "table" or type(object.Class) ~= "function"  then 
        return false
    end

    if object:Class() == class then return true end

    while object do
        object = object:Parent()
        if object ~= nil and class == object then 
            return true
        end
    end
    return false
end

function Class.Extend(parentClass)
    local newClass = {}
    setmetatable(newClass,{__index = parentClass})
    --newClass.__index = sel;
    return newClass
end

function Class:new(...)
    local obj = self:Extend()
    obj.__index = obj
    if type(obj.construct) == "function" then 
        obj:construct(...)
    end
    return obj
end

return Class