--->>>Variables
local HTTP = game:GetService('HttpService');

local _Type = require('@self/_Type');
local _VoltClasses = {
    Connector = require('@self/_VoltageClasses/Connector');
    Director = require('@self/_VoltageClasses/Director');
    Generator = require('@self/_VoltageClasses/Generator');
    Collector = require('@self/_VoltageClasses/Collector');
    Holder = require('@self/_VoltageClasses/Holder');
};

local _UniqueIDLog = {};

--->>>Preset
local Constructor = {};

local Voltage = {};
Voltage.__index = Voltage;

--->>>Constructor
function Constructor.new()
end;

--->>>Voltage
function Voltage:__Calculate__(basePlate: Instance, class: string, model: Instance)
end;

function Voltage:Insert(basePlate: Instance, class: string, model: Instance)
    class = _VoltClasses[tostring(class)];
    if not class then return; end;
    local newInsert = class.new(basePlate, model);
    repeat newInsert['UniqueID'] = HTTP:GenerateGUID(false); until not _UniqueIDLog[newInsert['UniqueID']];
    _UniqueIDLog[newInsert['UniqueID']] = true;
    self:__Calculate__();
    return true;
end;

return Constructor;