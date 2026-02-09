local PLAYER = game:GetService('Players');

local ply = PLAYER.LocalPlayer;
local plyCharacter = ply.Character or ply.CharacterAdded:Wait();
local plyHumanoid = plyCharacter:WaitForChild('Humanoid');

local protoTool = Instance.new('Tool');
protoTool.CanBeDropped = false;
protoTool.ManualActivationOnly = false;
protoTool.RequiresHandle = false;

local _Container = {};

local Item = {}
Item.__index = Item;

function Item.new(key: string)
    local this = setmetatable({}, Item);
    this['ID'] = game:GetService('HttpService'):GenerateGUID(false);
    this['Key'] = tostring(key);
    this['_Tool'] = protoTool:Clone();
    this['_Tool'].Name = this['Key'];
    this['_Tool'].Parent = plyCharacter;
    this['_Tool'].Enabled = false;
    _Container[this['ID']] = this;
    return this;
end;

function Item:Destroy()
     _Container[self['ID']] = nil;
    self['_Tool']:Destroy();
    table.clear(self);
    setmetatable(self, nil);
end;

local ItemHandlers = {};

function ItemHandlers:Insert(key: string)
    Item.new(key);
    plyHumanoid:UnequipTools();
end;

function ItemHandlers:Search(key: string)
    key = tostring(key);
    for i,v in _Container do
        if v['Key'] == key then return v; end;
    end;
    return;
end;

function ItemHandlers:Clear()
    for i,v in _Container do v:Destroy(); end;
end;

return ItemHandlers;