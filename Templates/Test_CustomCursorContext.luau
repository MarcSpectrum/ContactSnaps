local _Disabled = false ;
if _Disabled == true then return {}; end ;

--[[ Execution ]]--
local module = {};

function module:__Init__()
end ;

function module:__Start__()
    --[[
    local Actions = require('../Controllers/Actions');
    local Grid = require('../../_Shared/Services/Grid');
    local Grid_PathFinding = require('../../_Shared/Services/Grid/_Utils/_PathFinding');
    local alphaPoint, omegaPoint = nil,nil;
    local vectorChangedFunc = function(viewport: UDim2)
        local ray = Grid:Raycast(viewport);
        if not ray then return; end;
    end ;
    local executeFunc = function(viewport: UDim2)
        local ray = Grid:Raycast(viewport);
        if not ray then return; end;
        if not alphaPoint then
            alphaPoint = ray;
            Grid:Highlight({ray['Key']});
        elseif not omegaPoint then
            omegaPoint = ray;
            Grid:Highlight({ray['Key']});
            local path = Grid_PathFinding.find(alphaPoint, omegaPoint);
            local tiles = {};
            for i,v in ipairs(path) do tiles[i] = v['Key']; end;
            Grid:Highlight(tiles);
            alphaPoint = nil;
            omegaPoint = nil;
        end;
    end ;
    local connectionSet = {
        {['Key'] = '__ValueChanged';['Func'] = vectorChangedFunc;} ;
        {['Key'] = '__Executed';['Func'] = executeFunc;} ;
    } ;
    
    game:GetService('UserInputService').JumpRequest:Connect(function(...)
        Actions:Bind('CustomCursor', connectionSet) ;
    end);
    ]]
end ;

return module ;