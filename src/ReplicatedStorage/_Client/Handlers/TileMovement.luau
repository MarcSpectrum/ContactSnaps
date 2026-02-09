--[[
* Lock character to Tile [X]
* Pick tile to move [O]
* Tile PathFinding [X]
* Cross Region move [O]
* Map Environment Interactions [O]
]]
local module = {} ;

local PLAYER = game:GetService('Players');
local RUN = game:GetService('RunService');

local ply = PLAYER.LocalPlayer;
local plyCharacter = ply.Character or ply.CharacterAdded:Wait();
local plyHumanoid = plyCharacter:WaitForChild('Humanoid');
local plyAnimator = plyHumanoid:WaitForChild('Animator');

local Actions = require('../Controllers/Actions');
local Grid = require('../../_Shared/Services/Grid');
local Grid_PathFinding = require('../../_Shared/Services/Grid/_Utils/_PathFinding');

local _typeGrid = require('../../_Shared/Services/Grid/_Type');

local animMove = Instance.new('Animation');
animMove.AnimationId = 'rbxassetid://133470063614396';

module['CurrentTile'] = nil;

module['PathTracker'] = nil;
module['PathTracker_Anim'] = plyAnimator:LoadAnimation(animMove);

--->>> SelfMethods
function module:SnapsCharacter(tile)
    if Grid['Active'] ~= true then return; end;
    local Dest = tile or Grid:Pick(('0:0'));
    plyCharacter:PivotTo(Dest.CFrame + Vector3.new(0,2,0));
    module['CurrentTile'] = Dest;
end;

function module:TrackPath_Break()
    if self['PathTracker'] then self['PathTracker']:Disconnect(); self['PathTracker'] = nil; end;
    self:SnapsCharacter(self['CurrentTile']);
    self['PathTracker_Anim']:Stop()
end;

function module:TrackPath(path: {_typeGrid.Tile})
    self:TrackPath_Break();
    self.TrackerPath = path;
    self.TrackerPathLength = #self.TrackerPath;
    self.TrackerCounter = 0;
    self.TrackerIndex = 1;
    self.TrackerAlpha = self.TrackerPath[self.TrackerIndex].CFrame;
    self.TrackerOmega = self.TrackerPath[self.TrackerIndex+1].CFrame;
    self:SnapsCharacter(self.TrackerPath[self.TrackerIndex]);
    self['PathTracker'] = RUN.Heartbeat:Connect(function(deltaTime: number)
        deltaTime *= 3;
        if self.TrackerCounter >= 1 then
            self.TrackerCounter = 0;
            self.TrackerIndex += 1;
            self:SnapsCharacter(self.TrackerPath[self.TrackerIndex]);
            if self.TrackerIndex >= self.TrackerPathLength then self:TrackPath_Break(); return; end;
            self.TrackerAlpha = self.TrackerPath[self.TrackerIndex].CFrame;
            self.TrackerOmega = self.TrackerPath[self.TrackerIndex+1].CFrame;
        end;
        local characterCFrame = self.TrackerAlpha:Lerp(self.TrackerOmega, self.TrackerCounter) + Vector3.new(0,2,0);
        local targetCFrame = self.TrackerAlpha:Lerp(self.TrackerOmega, 2) + Vector3.new(0,2,0);
        plyCharacter:PivotTo(CFrame.lookAt(characterCFrame.Position, targetCFrame.Position));
        self.TrackerCounter = math.clamp(self.TrackerCounter + deltaTime, 0, 1);
    end);
    self['PathTracker_Anim']:Play()
end;

--->>> SystemMethods
function module:__Init__()
    local vectorChangedFunc = function(viewport: UDim2)
        local ray = Grid:Raycast(viewport);
        if not ray then return; end;
    end ;
    local executeFunc = function(viewport: UDim2)
        local ray = Grid:Raycast(viewport);
        if not ray then return; end;
        Grid:Highlight({ray['Key']}, Color3.fromRGB(201, 255, 135));
        local path = Grid_PathFinding.find(self['CurrentTile'], ray);
        self:TrackPath(path);
    end ;
    local connectionSet = {
        {['Key'] = '__ValueChanged';['Func'] = vectorChangedFunc;} ;
        {['Key'] = '__Executed';['Func'] = executeFunc;} ;
    } ;
    Actions:Bind('CustomCursor', connectionSet);
end;

function module:__Start__()
    self:SnapsCharacter()
end;

return module ;