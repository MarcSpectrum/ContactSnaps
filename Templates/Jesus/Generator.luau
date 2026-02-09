--->>>OOP
local Constructor = {} ;

local Class = {} ;
Class.__index = Class

--[[
*Chad give Connector _Charged
]]

--->>>ConstructorMethod
function Constructor.new(basePlate: Instance, model: Instance, UniqueID, Voltage)
    local instance = setmetatable({}, Class);
    instance['_basePlate'] = basePlate;
    instance['_model'] = model;
    instance['_Charged'] = true;
    instance['_Color'] = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255));
    instance['Type'] = 'Generator';
    instance['UniqueID'] = UniqueID;
    instance['_basePlate'].Name = instance['UniqueID'];
    instance['Voltage'] = Voltage;
    instance['Solid'] = true;
    return instance;
end ;

function Constructor.is(object: any) : boolean
end ;

--->>>ClassMethods
function Class:__Refresh__()
    
end;

return Constructor ;