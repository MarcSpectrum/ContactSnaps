local ProgressHandler = {};

local REP = game:GetService('ReplicatedStorage');

local StagesVisual = REP:WaitForChild('StagesVisual')
local subRegionsProgress = REP:WaitForChild('subRegionsProgress')
local ControllerSFX = require('../Controllers/SFX')

local MainStageLevels = {
    [0] = StagesVisual:WaitForChild('Stage0');
    [1] = StagesVisual:WaitForChild('Stage1');
    [2] = StagesVisual:WaitForChild('Stage2');
    [3] = StagesVisual:WaitForChild('Stage3');
    [4] = StagesVisual:WaitForChild('Stage4');
    [5] = StagesVisual:WaitForChild('Stage5');
};
local MainStage_Loaded = {}

local subRegionKeys = {
    ['A'] = subRegionsProgress:WaitForChild('Factory_A');
    ['B'] = subRegionsProgress:WaitForChild('Factory_B');
    ['C'] = subRegionsProgress:WaitForChild('Factory_C');
    ['D'] = subRegionsProgress:WaitForChild('Factory_D');
    ['E'] = subRegionsProgress:WaitForChild('Factory_E');
};
local subRegion_Loaded = {}
local subRegion_LoadedLength = 0


function ProgressHandler:subRegionUpdate(key: string)
    key = tostring(key)
    if subRegion_Loaded[key] then return end;
    if not subRegionKeys[key] then return end;
    subRegion_Loaded[key] = true;
    MainStage_Loaded[key] = subRegionKeys[key]:Clone()
    MainStage_Loaded[key].Parent = workspace
    subRegion_LoadedLength += 1
    MainStageLevels[subRegion_LoadedLength].Parent = workspace
    ControllerSFX:Play('Finished');
    if subRegion_LoadedLength >= 5 then REP.GameStats.BadgeRequest.OnServerEvent:FireServer(); end;
end;

function ProgressHandler:__Init__()
end;

function ProgressHandler:__Start__()
    MainStageLevels[subRegion_LoadedLength].Parent = workspace
end;

return ProgressHandler;