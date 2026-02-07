--->>> Types
export type GridTileConstructor = {
    new: () -> GridTileClass;
    is: (this: any) -> boolean;
};

export type GridTileClass = {
};

--->>> Presets
local Constructor = {}:: GridTileConstructor;

local Class = {}:: GridTileClass;
Class.__index = Class;

--->>> ConstructorMethods
function Constructor.new(): GridTileClass
    local this = setmetatable({}, Class);
    return this;
end;

function Constructor.Is(this: any): boolean
end;

--->>> ClassMethods

return Constructor;