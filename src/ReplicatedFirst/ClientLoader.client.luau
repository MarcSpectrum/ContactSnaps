if not game:IsLoaded() then game.Loaded:Wait(); end ;

local ply = game:GetService('Players').LocalPlayer ;
local _plyChar = ply.Character or ply.CharacterAdded:Wait() ;

local ContentProv = game:GetService('ContentProvider') ;
local REP = game:GetService('ReplicatedStorage') ;

local _GameStats = REP:WaitForChild('GameStats') ;
local _GameStats_ClientLoaded = _GameStats:WaitForChild('ClientLoaded') ;
local _GameStats_ServerLoaded = _GameStats:WaitForChild('ServerLoaded') ;

while (_GameStats_ServerLoaded.Value ~= true) do task.wait(); end ;

local _Shared = REP:WaitForChild('_Shared') ;
local _Client = REP:WaitForChild('_Client') ;

ContentProv:PreloadAsync({_GameStats, _Shared, _Client}) ;

for _,v in _Shared:GetDescendants() do
    if not v:IsA('ModuleScript') then continue; end ;
    require(v) ;
end ;
for _,v in _Client:GetDescendants() do
    if not v:IsA('ModuleScript') then continue; end ;
    require(v);
end ;

for _,v in _Client.Handlers:GetChildren() do v = require(v); if type(v.__Init__) == 'function' then v:__Init__(); end; end ;
for _,v in _Client.Handlers:GetChildren() do v = require(v); if type(v.__Start__) == 'function' then task.defer(v.__Start__,v); end; end ;

_GameStats_ClientLoaded.Value = true ;