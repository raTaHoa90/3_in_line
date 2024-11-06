local Class = {}


function Class.Instanceof(object, class)
    if type(object) ~= "table" or type(class) ~= "table"  then 
        return false;
    end
    while object do
        object = getmetatable(object);
        if class == object then 
            return true;
        end
    end
    return false;
end

function Class.Extend(parentClass)
    local child = {};
    setmetatable(child,{__index = parentClass});
    return child;
end

function Class:new(...)
    local obj = self:extend();
    if type(obj.construct) == "function" then 
        obj:construct(...);
    end
    return obj;
end

return Class;