--->> Holder = Hold before got picked up
--->>>OOP
local Constructor = {} ;

local Class = {} ;
Class.__index = Class

--[[
*Holder = Hold before got picked up
]]

--->>>ConstructorMethod
function Constructor.new(basePlate: Instance, model: Instance, UniqueID, Voltage)
    local instance = setmetatable({}, Class);
    instance['_basePlate'] = basePlate;
    instance['_model'] = model;
    instance['_Charged'] = false;
    instance['Type'] = 'Holder';
    instance['UniqueID'] = UniqueID;
    instance['_basePlate'].Name = instance['UniqueID'];
    instance['Voltage'] = Voltage;
    instance['_Color'] = Color3.fromRGB(193, 193, 193);
    instance['Solid'] = true;
    return instance ;
end;

function Constructor.is(object: any) : boolean
end;

--->>>ClassMethods
function Class:__Refresh__()
end;

return Constructor ;