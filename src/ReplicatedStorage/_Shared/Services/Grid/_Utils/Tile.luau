--->>> Utilities
local _Type = require('../_Type');

--->>> Presets
local Constructor = {}:: _Type.Constructor;

local Class = {}:: _Type.Tile;
Class.__index = Class;

--->>> ConstructorMethods
function Constructor.new():  _Type.Tile
    local this = setmetatable({}, Class);
    return this;
end;

function Constructor.Is(this: any): boolean
end;

--->>> ClassMethods

return Constructor;