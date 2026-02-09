--->>>Variables

local _Type = require('@self/_Type');
local _VoltClasses = {
    Generator = require('@self/_VoltageClasses/Generator');
    Connector = require('@self/_VoltageClasses/Connector');
    FixDirector = require('@self/_VoltageClasses/FixDirector');
    FlexDirector = require('@self/_VoltageClasses/FlexDirector');
};

--->>>Preset
local Constructor = {};

local Voltage = {};
Voltage.__index = Voltage;

local readOrder = {
    Generator = 4;
    Connector = 1;
    FixDirector = 2;
    FlexDirector = 3;
};

--->>>Constructor
function Constructor.new()
    local this = setmetatable({}, Voltage)
    this['_Container'] = {};
    this['_Libarary'] = {};
    return this;
end;

--->>>Voltage
function Voltage:__Calculate__()
    for h,v1 in self['_Libarary'] do 
        for _,v2 in v1 do
            v2:__Refresh__();
        end;
    end;
end;

function Voltage:Insert(basePlate: Instance, class: string, model: Instance)
    class = _VoltClasses[tostring(class)];
    if not class then return; end;
    local newInsert = class.new(basePlate, self);
    self['_Container'][newInsert['UniqueID']] = newInsert;
    self['_Libarary'][readOrder[newInsert['Type']]] = self['_Libarary'][readOrder[newInsert['Type']]] or {};
    table.insert(self['_Libarary'][readOrder[newInsert['Type']]], newInsert);
    --self:__Calculate__();
    return true;
end;

function Voltage:Get(key: string)
    return self['_Container'][key];
end;

return Constructor;