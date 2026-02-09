--->>>OOP
local Constructor = {} ;

local Class = {} ;
Class.__index = Class

--->>>ConstructorMethod
function Constructor.new()
    local instance = setmetatable({}, Class) ;
    return instance ;
end ;

function Constructor.Is(object: any) : boolean
end ;

--->>>ClassMethods

return Constructor ;