--[[
* Lock character to Tile [O]
* Pick tile to move [O]
* Tile PathFinding [X]
* Cross Region move [O]
]]
local module = {} ;

local Actions = require('../Controllers/Actions');
local Grid = require('../../_Shared/Services/Grid');
local Grid_PathFinding = require('../../_Shared/Services/Grid/_Utils/_PathFinding');

function module:__Init__()
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
            Grid:Highlight(tiles, Color3.fromRGB(201, 255, 135));
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
end;

function module:__Start__()
end;

return module ;