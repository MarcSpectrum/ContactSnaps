--[[
* Lock character to Tile [X]
* Pick tile to move [X]
* Tile PathFinding [X]
* Cross Region move [X]
* Map Environment Interactions [X]
]]
local module = {} ;

local PLAYER = game:GetService('Players');
local RUN = game:GetService('RunService');

local ply = PLAYER.LocalPlayer;
local plyCharacter = ply.Character or ply.CharacterAdded:Wait();
local plyHumanoid = plyCharacter:WaitForChild('Humanoid');
local plyAnimator = plyHumanoid:WaitForChild('Animator');
local playCamera = workspace.CurrentCamera;

local Actions = require('../Controllers/Actions');
local Grid = require('../../_Shared/Services/Grid');
local Grid_PathFinding = require('../../_Shared/Services/Grid/_Utils/_PathFinding');

local RegionHandler = require('./RegionHandler');
local RegionParam = RaycastParams.new();
RegionParam.FilterType = Enum.RaycastFilterType.Include;

local _typeGrid = require('../../_Shared/Services/Grid/_Type');

local animMove = Instance.new('Animation');
animMove.AnimationId = 'rbxassetid://133470063614396';

module['CurrentTile'] = nil;
module['LockedTile'] = nil;

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

local _LockedInteraction = nil;
local _HighlightInteraction = Instance.new('Highlight');
function module:UnLockInteraction()
    _HighlightInteraction.Parent = nil;
    _LockedInteraction = nil;
end;
function module:LockInteraction(object: Instance, fillColor: Color3)
    if object == _LockedInteraction then return; end;
    self:UnLockInteraction();
    if not object then return; end;
    _HighlightInteraction.FillColor = typeof(fillColor) == 'Color3' and fillColor or Color3.fromRGB(135, 203, 255)
    _HighlightInteraction.Parent = object;
    _LockedInteraction = object.Name;
end;

local _LockedInteraction_Volt = nil;
local _HighlightInteraction_Volt = Instance.new('Highlight');
function module:UnLockInteraction_Volt()
    _HighlightInteraction_Volt.Parent = nil;
    _LockedInteraction_Volt = nil;
end;
function module:LockInteraction_Volt(object: Instance, fillColor: Color3)
    if object == _LockedInteraction_Volt then return; end;
    self:UnLockInteraction();
    if not object then return; end;
    _HighlightInteraction_Volt.FillColor = typeof(fillColor) == 'Color3' and fillColor or Color3.fromRGB(173, 135, 255)
    _HighlightInteraction_Volt.Parent = object;
    _LockedInteraction_Volt = object.Name;
end;

--->>> SystemMethods
function module:__Init__()
    local _GridDebounce = false;
    
    local vectorChangedFunc = function(viewport: UDim2)
        if RegionHandler.Active ~= true then return; end;
        if _GridDebounce == true or _LockedInteraction or _LockedInteraction_Volt then return; end;
        local ray = Grid:Raycast(viewport);
        if not ray then return; end;
        if self['LockedTile'] == ray['Key'] then return; end;
        Grid:Highlight({ray['Key']}, Color3.fromRGB(255, 163, 135));
    end;

    local executeFunc = function(viewport: UDim2)
        if RegionHandler.Active ~= true then return; end;
        if _GridDebounce == true or _LockedInteraction or _LockedInteraction_Volt then return; end;
        local ray = Grid:Raycast(viewport);
        if not ray then return; end;
        _GridDebounce = true;
        Grid:Highlight({ray['Key']}, Color3.fromRGB(201, 255, 135));
        local path = Grid_PathFinding.find(self['CurrentTile'], ray);
        if not path or self['CurrentTile'].Key == ray.Key then _GridDebounce = false; return; end;
        self:TrackPath(path);
        self['LockedTile'] = ray['Key'];
        task.delay(.5, function() _GridDebounce = false; end);
    end;

    local vectorChangedFunc_Interactions = function(viewport: UDim2)
        if RegionHandler.Active ~= true then return; end;
        local ray = playCamera:ViewportPointToRay(viewport.X, viewport.Y);
        local direction = (ray.Direction * 300);
        RegionParam.FilterDescendantsInstances = {RegionHandler['currentRegion']['Interactions']};
        local cast = workspace:Raycast(ray.Origin, direction, RegionParam);
        self:LockInteraction(cast and cast.Instance.Parent or nil);
    end;

    local executeFunc_Interactions = function(viewport: UDim2)
        if RegionHandler.Active ~= true then return; end;
        if not _LockedInteraction then return; end;
        if RegionHandler.currentRegion.Interactions_Func[tostring(_LockedInteraction)] then
            RegionHandler.currentRegion.Interactions_Func[tostring(_LockedInteraction)]();
        end;
        self:UnLockInteraction()
    end;

    local vectorChangedFunc_VoltInteractions = function(viewport: UDim2)
        if RegionHandler.Active ~= true then return; end;
        local ray = playCamera:ViewportPointToRay(viewport.X, viewport.Y);
        local direction = (ray.Direction * 300);
        RegionParam.FilterDescendantsInstances = {RegionHandler['currentRegion']['_Volt']};
        local cast = workspace:Raycast(ray.Origin, direction, RegionParam);
        self:LockInteraction_Volt(cast and cast.Instance or nil);
    end;

    local executeFunc_VoltInteractions = function(viewport: UDim2)
        if RegionHandler.Active ~= true then return; end;
        if not _LockedInteraction_Volt then return; end;
        local picking = RegionHandler.currentRegion['Voltage']:Get(_LockedInteraction_Volt);
        if picking then picking:__Interact__(); end;
        self:UnLockInteraction_Volt()
    end;
    local connectionSet = {
        {['Key'] = '__ValueChanged';['Func'] = vectorChangedFunc;} ;
        {['Key'] = '__Executed';['Func'] = executeFunc;} ;
        {['Key'] = '__ValueChanged';['Func'] = vectorChangedFunc_Interactions;} ;
        {['Key'] = '__Executed';['Func'] = executeFunc_Interactions;} ;
        {['Key'] = '__ValueChanged';['Func'] = vectorChangedFunc_VoltInteractions;} ;
        {['Key'] = '__Executed';['Func'] = executeFunc_VoltInteractions;} ;
    };
    Actions:Bind('CustomCursor', connectionSet);
end;

function module:__Start__()
    self:SnapsCharacter()
end;

RegionHandler.__Activated:Connect(function() module:TrackPath_Break(); module:SnapsCharacter() end)

return module ;