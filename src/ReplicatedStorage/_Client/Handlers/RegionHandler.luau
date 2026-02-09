--[[ Execution ]]--
local module = {} ;

local Signal = require('../../_Shared/Customs/Signal');

module.Active = false;

module.__Activated = Signal.new();

module['currentRegion'] = nil;

local Grid = require('../../_Shared/Services/Grid');

local _RegionInteractions = {};

_RegionInteractions['Main'] = {
    Factory_Main = function()
    end;
    Factory_A = function()
        module:TravelTo('RegionA');
    end;
    Factory_B = function()
        module:TravelTo('RegionB');
    end;
    Factory_C = function()
        module:TravelTo('RegionC');
    end;
    Factory_D = function()
        module:TravelTo('RegionD');
    end;
    Factory_E = function()
        module:TravelTo('RegionE');
    end;
};

_RegionInteractions['I'] = {
    BackToMain = function() module:TravelTo('Main'); end;
    Factory_Main = function()
    end;
};

_RegionInteractions['II'] = {
    BackToMain = function() module:TravelTo('Main'); end;
    Factory_Main = function()
    end;
};

_RegionInteractions['III'] = {
    BackToMain = function() module:TravelTo('Main'); end;
    Factory_Main = function()
    end;
};

_RegionInteractions['IV'] = {
    BackToMain = function() module:TravelTo('Main'); end;
    Factory_Main = function()
    end;
};

_RegionInteractions['V'] = {
    BackToMain = function() module:TravelTo('Main'); end;
    Factory_Main = function()
    end;
};

local RegionBlueprints = {};

local function LoadBlueprint(key: string, workspaceModel: Instance, interactionsKey: string)
    local extracted = {
        workspaceModel._Size;
        workspaceModel._Position;
        workspaceModel._Areas;
        workspaceModel._Configs;
    };
    RegionBlueprints[key] = {
        ['Grid'] = Grid.Utilities['Template'].new(unpack(extracted));
        ['Interactions'] = workspaceModel._InteractionEnvironments;
        ['Interactions_Func'] = _RegionInteractions[interactionsKey];
    };
end;
LoadBlueprint('Main', workspace.Terrain:WaitForChild('MainRegion'), 'Main');
LoadBlueprint('RegionA', workspace.Terrain:WaitForChild('RegionA'), 'I');
LoadBlueprint('RegionB', workspace.Terrain:WaitForChild('RegionB'), 'II');
LoadBlueprint('RegionE', workspace.Terrain:WaitForChild('RegionE'), 'III');
LoadBlueprint('RegionC', workspace.Terrain:WaitForChild('RegionC'), 'IV');
LoadBlueprint('RegionD', workspace.Terrain:WaitForChild('RegionD'), 'V');

function module:TravelTo(regionKey: string)
    local blueprint = RegionBlueprints[regionKey];
    if not blueprint then return end
    Grid:Draw(blueprint['Grid']);
    self['currentRegion'] = blueprint;
    self.Active = true;
    self.__Activated:Fire();
end;

function module:__Init__()
end;

function module:__Start__()
    --self:TravelTo('Main');

    --->>> Tempo For Voltage
    _RegionInteractions['VoltTest'] = {
        BackToMain = function() module:TravelTo('Main'); end;
        Factory_Main = function()
        end;
    };
    LoadBlueprint('VoltTest', workspace.Terrain:WaitForChild('VoltTest'), 'VoltTest');
    self:TravelTo('VoltTest');
end;

return module ;