--[[ Execution ]]--
local module = {} ;

local PLAYER = game:GetService('Players');
local StarterGUI = game:GetService("StarterGui")

game:GetService('ContentProvider'):PreloadAsync({workspace.Terrain});

local ply = PLAYER.LocalPlayer;

function module:__Init__()
end;

function module:__Start__()
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom;
    local CameraStyles = require('../Controllers/CameraStyles');
    CameraStyles.EnableIsometricCamera();

    local Controls = require(ply.PlayerScripts.PlayerModule):GetControls();
    Controls:Disable();

    repeat
        local success = pcall(function() 
            StarterGUI:SetCore('ResetButtonCallback', false);
        end);
        task.wait(1);
    until success;
end;

return module ;