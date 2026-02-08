--[[ Execution ]]--
local module = {} ;

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
    local template_MainRegion = Grid.Utilities['Template'].new(unpack(MainRegion_extracted));
    RegionBlueprints['Main'] = Grid:Draw(template_MainRegion);
end;

function module:__Start__()
end;

return module ;