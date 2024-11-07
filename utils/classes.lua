local Class = {}


function Class.InstanceOf(object, class)
    if type(object) ~= "table" or type(class) ~= "table"  then 
        return false;
    end
    while object do
        object = getmetatable(object);
        if object ~= nil and class == object.__index then 
            return true;
        end
    end
    return false;
end

function Class.Extend(parentClass)
    local newClass = {}
    setmetatable(newClass,{__index = parentClass});
    --newClass.__index = sel;
    return newClass;
end

function Class:new(...)
    local obj = self:Extend();
    obj.__index = obj;
    if type(obj.construct) == "function" then 
        obj:construct(...);
    end
    return obj;
end

return Class;