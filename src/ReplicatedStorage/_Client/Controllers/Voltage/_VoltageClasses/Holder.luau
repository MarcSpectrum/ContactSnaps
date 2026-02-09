--->> Holder = Hold before got picked up
--->>>OOP
local Constructor = {} ;

local Class = {} ;
Class.__index = Class

--->>>ConstructorMethod
function Constructor.new()
    local instance = setmetatable({}, Class) ;
    instance['_Charged'] = false;
    instance['Type'] = 'Holder';
    instance:__Refresh__();
    return instance ;
end;

function Constructor.is(object: any) : boolean
end;

--->>>ClassMethods
function Class:__Refresh__()
end;

return Constructor ;