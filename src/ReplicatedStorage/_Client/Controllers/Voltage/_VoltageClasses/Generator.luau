--->>>OOP
local Constructor = {} ;

local Class = {
    Type = 'Generator';
} ;
Class.__index = Class

local _DefaultConstructor = require('./_DefaultConstructor');

--->>>ConstructorMethod
function Constructor.new(...)
    local this = setmetatable({}, Class);
    _DefaultConstructor.Construct(this, {...});
    this['_Charged'] = true;
    this['_Solid'] = true;
    this['_VoltColor'] = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255));
    this['Childrens'] = {};
    return this;
end;

--->>>ClassMethods
function Class:__Refresh__()
end;

function Class:__Interact__()
    self.Voltage:__Calculate__()
end;

return Constructor ;