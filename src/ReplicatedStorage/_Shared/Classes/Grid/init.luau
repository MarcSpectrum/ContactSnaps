--->>> Utilities
local ASSET = game:GetService('AssetService');
local RUN = game:GetService('RunService');

local Coordinate = require('../Customs/Coordinate');

local Tile = require('@self/_Utils/Tile');

--->>> Variables
local _IsServer = RUN:IsServer();

local _DrawingScale = 5;
local _defaultRayLength = 300;

--->>> Types
export type GridConstructor = {
    new: () -> GridClass;
    is: (this: any) -> boolean;
};

export type GridClass = {
    --//CanvasAttributes
    _Mesh: MeshPart;
    _eMesh: EditableMesh;
    _Canvas: {[string]: Tile.GridTileClass};
};

--->>> Presets
local Constructor = {}:: GridConstructor;

local Class = {}:: GridClass;
Class.__index = Class;

--->>> ConstructorMethods
function Constructor.new(size: number, originPosition: Vector3): GridClass
    -->>ParametersAuhentication
    size = type(size) == 'number' and size > 0 and size or 1;
    originPosition = typeof(originPosition) == 'Vector3' and originPosition or Vector3.zero;
    -->>Setup
    local this = setmetatable({}, Class);
    -->>CanvasDrawing
    local drawScale = _DrawingScale;
    local drawHalfScale = (drawScale/2);
    local originBoostValue = _defaultRayLength;
    local originBoostVector = (Vector3.new(0,originBoostValue,0));
    local rayDirection = -originBoostVector;
    for row = -size,size,1 do
        for col = -size,size,1 do
        end;
    end;
    return this;
end;

function Constructor.Is(this: any): boolean
end;

--->>> ClassMethods

return Constructor;