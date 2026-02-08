local _Disabled = false ;
if _Disabled == true then return {}; end ;

--[[ Execution ]]--
local module = {};

function module:__Init__()
end ;

function module:__Start__()
    local Actions = require('../Controllers/Actions');
    local Grid = require('../../_Shared/Services/Grid');
    local vectorChangedFunc = function(viewport: UDim2)
        local ray = Grid:Raycast(viewport);
        if not ray then return; end;
    end ;
    local executeFunc = function(viewport: UDim2)
        local ray = Grid:Raycast(viewport);
        if not ray then return; end;
        Grid:Highlight(ray['Key']);
    end ;
    local connectionSet = {
        {['Key'] = '__ValueChanged';['Func'] = vectorChangedFunc;} ;
        {['Key'] = '__Executed';['Func'] = executeFunc;} ;
    } ;
    game:GetService('UserInputService').JumpRequest:Connect(function(...)
        Actions:Bind('CustomCursor', connectionSet) ;
    end);
end ;

return module ;