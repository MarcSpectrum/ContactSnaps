local Signal = require('../../_Shared/Customs/Signal')
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
    this['_Powered'] = {};
    this['Finished'] = false;
    this.__Finished = Signal.new();
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

function Voltage:Flood(origin, reset)
    if reset == true then 
        for _,v in origin['_PoweredUnits'] or {} do
            v.This:__OffPowered__()
            self['_Powered'][v.ID] = nil
        end
        --table.clear(self['_Powered']); 
        table.clear(origin['_PoweredUnits']); 
    end;
    local queue = {origin}
    local color = origin._VoltColor
    origin['_PoweredUnits'] = {}
    self._Powered[origin.UniqueID] = {
        Color = color,
        Source = origin,
        This = origin;
        ID = origin.UniqueID;
    }
    table.insert(origin['_PoweredUnits'],self._Powered[origin.UniqueID])

    origin['_GoalReached'] = false; ---!!!
    while #queue > 0 do
        local current = table.remove(queue, 1)

        -- refresh connections dynamically
        if current.__Refresh__ then
            current:__Refresh__()
        end

        local nexts = current.Connections or current.Childrens or {}

        for _,nextNode in nexts do
            if nextNode._Solid then continue end
            if self._Powered[nextNode.UniqueID] then continue end

            self._Powered[nextNode.UniqueID] = {
                Color = color,
                Source = origin,
                This = nextNode;
                ID = nextNode.UniqueID
            }
            table.insert(origin['_PoweredUnits'], self._Powered[nextNode.UniqueID])

            -- visual feedback
            if nextNode.__OnPowered__ then
                nextNode:__OnPowered__(color)
            end

            if nextNode['MainConnected'] == true then
                origin['_GoalReached'] = true;
            end;

            table.insert(queue, nextNode)
        end
    end

    local checkProgress = true;
    for _,v in self['_Libarary'][readOrder['Generator']] do
        checkProgress = v._GoalReached
        if checkProgress == false then break; end;
        if not v._GoalReached then checkProgress = false; break; end;
    end;
    if checkProgress == true then
        self.__Finished:Fire()
    end;

    return origin['_GoalReached'];
end

return Constructor;