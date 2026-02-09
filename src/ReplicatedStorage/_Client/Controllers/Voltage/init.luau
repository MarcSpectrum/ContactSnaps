local _Type = require('@self/_Type');
local _VoltClasses = {
    Connector = require('@self/_VoltageClasses/Connector');
    Director = require('@self/_VoltageClasses/Director');
    Generator = require('@self/_VoltageClasses/Generator');
    Collector = require('@self/_VoltageClasses/Collector');
    Holder = require('@self/_VoltageClasses/Holder');
};

local Constructor = {};

local Voltage = {};
Voltage.__index = Voltage;

function Constructor.new()
end;

function Voltage:Register(object: Instance, class: string)
end;

return Constructor;