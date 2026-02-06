--// Variables
local HTTP = game:GetService('HttpService');
local HttpService = game:GetService("HttpService")

local LinkedList = require('./LinkedList');

--// Contents
local _Type = require('@self/_Type') ;

local ObjectKey_Pool = 'Custom-ObjectPool';
local ObjectID_Logs = {} ;

--// Prelude-setup Main
local ObjectPool_Class: _Type._T = {} ;

local ObjectPool_Object = {} ;
ObjectPool_Object.__index = ObjectPool_Object ;

ObjectPool_Construction = function(this: _Type._Pool)
    this['Key'] = ObjectKey_Pool;
    this['_Activated'] = LinkedList.new();
    this['_Inactivated'] = LinkedList.new();
    this['_RecycleBin'] = LinkedList.new();
end ;

--// Prelude-setup Sub
local PoolLink_Class = {} ;

local PoolLink_Object = {} ;
PoolLink_Object.__index = PoolLink_Object ;

PoolLink_Construction = function(this: _Type._PoolLink, Pool: _Type._Pool)
    local ID;
    repeat ID = HTTP:GenerateGUID(false) until not ObjectID_Logs[ID];
    ObjectID_Logs[ID] = true;
    this['ID'] = ID;
    this['_Pool'] = Pool;
end;

--// Class Methods : Pool
function ObjectPool_Class.new(): _Type._Pool
    local this = {};
    ObjectPool_Construction(this);
    setmetatable(this, ObjectPool_Object);
    return this;
end;

function ObjectPool_Class.is(self: any) : boolean
    if type(self) ~= 'table' then return false; end;
    if self['ObjectKey'] ~= ObjectKey_Pool then return false; end;
    return true;
end;

--// Object Methods : Pool
function ObjectPool_Object:__Include__(Value: any) : _Type._PoolLink
    local recycleLink = self['_RecycleBin']:PickBack();
    local poolLink;
    if recycleLink then
        poolLink = recycleLink._Value;
    else
        poolLink = PoolLink_Class.new(self);
    end;
    poolLink['Value'] = Value;
    poolLink:__Activate__();
    return poolLink;
end;

--// Class Methods : PoolLink
function PoolLink_Class.new(Pool: _Type._Pool): _Type._PoolLink
    local this = {};
    PoolLink_Construction(this, Pool);
    setmetatable(this, PoolLink_Object);
    return this;
end;

--// Object Methods : PoolLink
function PoolLink_Object:__MoveTo__(TargetList) : boolean
    if self['_PoolLink'] then
        self['_PoolLink']:Remove();
    end;
    self['_PoolLink'] = TargetList:InsertFront(self);
    return true;
end;

function PoolLink_Object:__Exclude__() : boolean
    self:__MoveTo__(self['_Pool']._RecycleBin);
    self['Value'] = nil;
    return true;
end;

function PoolLink_Object:__Activate__() : boolean
    self:__MoveTo__(self['_Pool']._Activated);
    return true;
end;

function PoolLink_Object:__Inactivate__() : boolean
    self:__MoveTo__(self['_Pool']._Inactivated);
    return true;
end;

return ObjectPool_Class;