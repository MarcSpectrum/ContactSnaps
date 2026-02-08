--[[ Execution ]]--
local module = {} ;

local Grid = require('../../_Shared/Classes/Grid');

local workspace_MainRegion = workspace.Terrain:WaitForChild('MainRegion');

function module:__Init__()
    local GridA = Grid.new(workspace_MainRegion['Size'].Value, workspace_MainRegion['OriginPosition'].CFrame.Position);
end;

function module:__Start__()
end;

return module ;