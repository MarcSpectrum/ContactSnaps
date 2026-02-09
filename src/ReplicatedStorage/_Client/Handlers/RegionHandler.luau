--[[ Execution ]]--
local module = {} ;

module['currentRegion'] = nil;

local Grid = require('../../_Shared/Services/Grid')

local MainRegion_workspace = workspace.Terrain:WaitForChild('MainRegion');
local MainRegion_extracted = {
    MainRegion_workspace._Size;
    MainRegion_workspace._Position;
    MainRegion_workspace._Areas;
    MainRegion_workspace._Configs;
};

local RegionBlueprints = {};

function module:__Init__()
    module['currentRegion'] = 'Main'
    RegionBlueprints['Main'] = Grid.Utilities['Template'].new(unpack(MainRegion_extracted));
    Grid:Draw(RegionBlueprints['Main']);
end;

function module:__Start__()
end;

return module ;