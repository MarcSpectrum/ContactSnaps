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
-->Link Object on Tile with Node-Unit in Grid
function Constructor.new(size: number, originPosition: Vector3): GridClass
    -->>ParametersAuhentication
    size = type(size) == 'number' and size > 0 and size or 1;
    originPosition = typeof(originPosition) == 'Vector3' and originPosition or Vector3.zero;
    -->>Setup
    local this = setmetatable({}, Class);
    this._Canvas = {};
    -->>CanvasDrawing
    local expansionScale = (_DrawingScale);
    local expansionHalfScale = (expansionScale/2);
    -->Tempo
    local _baseTile = Instance.new('Part');
    _baseTile.Size = Vector3.new(expansionScale,.5,expansionScale);
    _baseTile.Anchored = true;
    local _baseTileContainer = Instance.new('Model');
    _baseTileContainer.Parent = workspace;
    -->Tempo
    for row = -size,size,1 do
        for col = -size,size,1 do
            local thisCoordinate = Coordinate.new(row, col);
            local thisOriginPosition = (originPosition + Vector3.new(expansionScale*row,-3,expansionScale*col));
            -->Tempo
            local _Tile101 = _baseTile:Clone();
            _Tile101.Name = tostring(thisCoordinate);
            _Tile101.Position = thisOriginPosition;
            _Tile101.Parent = _baseTileContainer;
            -->Tempo
            local thisTile = Tile.new();
            this._Canvas[tostring(thisTile)] = thisTile;
        end;
    end;
    -->Tempo
    _baseTileContainer.PrimaryPart = _baseTileContainer['0:0']
    _baseTileContainer:PivotTo(CFrame.new(originPosition));
    -->Tempo
    return this;
end;

function Constructor.Is(this: any): boolean
end;

--->>> ClassMethods
function Class:__Clear__()
end;

function Class:Pick(key: string)
end;

function Class:Raycast()
end;

function Class:Destroy()
end;

return Constructor;