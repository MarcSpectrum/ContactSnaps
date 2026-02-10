local ContentProv = game:GetService('ContentProvider') ;
local REP = game:GetService('ReplicatedStorage') ;
local ServerStorage = game:GetService('ServerStorage') ;

local _GameStats = REP:WaitForChild('GameStats') ;
local _GameStats_ServerLoaded = _GameStats:WaitForChild('ServerLoaded') ;

local _Shared = REP:WaitForChild('_Shared') ;
local _Server = ServerStorage:WaitForChild('_Server') ;

ContentProv:PreloadAsync({_GameStats, _Shared, _Server}) ;

for _,v in _Shared:GetDescendants() do
    if not v:IsA('ModuleScript') then continue ; end ;
    require(v) ;
end ;
for _,v in _Server:GetDescendants() do
    if not v:IsA('ModuleScript') then continue ; end ;
    require(v) ;
end ;

for _,v in _Server.Handlers:GetChildren() do v = require(v); if type(v.Init) == 'function' then v:Init(); end; end ;
for _,v in _Server.Handlers:GetChildren() do v = require(v); if type(v.Start) == 'function' then task.defer(v.Start,v); end; end ;

for _,v in _Server.Systems:GetChildren() do v = require(v); if type(v.Init) == 'function' then v:Init(); end; end ;
for _,v in _Server.Systems:GetChildren() do v = require(v); if type(v.Start) == 'function' then task.defer(v.Start,v); end; end ;

local BadgeService = game:GetService('BadgeService')
REP.GameStats.BadgeRequest.OnServerEvent:Connect(function(ply: Player, ...)
    BadgeService:AwardBadgeAsync(ply.UserId, 4419041860776233)
end)

_GameStats_ServerLoaded.Value = true ;