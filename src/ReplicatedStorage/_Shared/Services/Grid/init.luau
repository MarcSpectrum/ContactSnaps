--->>> Variables
local ASSET = game:GetService('AssetService');
local RUN = game:GetService('RunService');

local Coordinate = require('../Customs/Coordinate');

local _IsServer = RUN:IsServer();

--->>> Utilities
local _Type = require('@self/_Type');

local _Utils_Tile = require('@self/_Utils/Tile');
local _Utils_Blueprint = require('@self/_Utils/Blueprint');
local _Utils_Template = require('@self/_Utils/Template');

local _DrawingScale = 5;
local _defaultRayLength = 300;

local _AreaParam = RaycastParams.new();
_AreaParam.FilterType = Enum.RaycastFilterType.Include;

local GridMeshSettings = {
    ['CanCollide'] = false ;
    ['CanTouch'] = false ;
    ['CastShadow'] = false ;
    ['EnableFluidForces'] = false ;
    ['CanQuery'] = true ;
    ['Anchored'] = true ;
    ['Locked'] = true ;
    ['Transparency'] = 1 ;
} ;

--->>> Setup
local Grid = {};

Grid['Active'] = false;

Grid['_Canvas'] = {};
Grid['_Faces'] = {};

Grid['Utilities'] = {
    Tile = _Utils_Tile;
    Blueprint = _Utils_Blueprint;
    Template = _Utils_Template
};

--->>> SecretMethods
function Grid:__Clear__(): boolean
    self['Active'] = false;
end;

function Grid:__LoadBlueprint__(): _Type.Grid_Blueprint
end;

function Grid:__ReadBlueprint__(blueprint: _Type.Grid_Blueprint)
    -->>ParametersAuhentication
    local gridSize = blueprint.Size;
    local gridPosition = blueprint.Position;
    -->>CanvasDrawing
    local expansionScale = (_DrawingScale);
    local expansionHalfScale = (expansionScale/2);
    local rayBoostVector = (Vector3.new(0,_defaultRayLength-100,0)) ;
    local rayDirection = -Vector3.new(0,_defaultRayLength,0) ;
    --_AreaParam.FilterDescendantsInstances = blueprint.
    -->Tempo
    local _baseTile = Instance.new('Part');
    _baseTile.Size = Vector3.new(expansionScale,.5,expansionScale);
    _baseTile.Anchored = true;
    local _baseTileContainer = Instance.new('Model');
    _baseTileContainer.Parent = workspace;
    -->Tempo
    for row = -gridSize,gridSize,1 do
        for col = -gridSize,gridSize,1 do
            local thisCoordinate = Coordinate.new(row, col);
            local thisOriginPosition = (gridPosition + Vector3.new(expansionScale*row,-3,expansionScale*col));
            local rayOrigin = (thisOriginPosition + rayBoostVector);
            local rayCasted = workspace:Raycast(rayOrigin, rayDirection, _AreaParam) ;
            regionDetected = (rayCasted and rayCasted.Instance.Parent.Name) ;
            -->Tempo
            local _Tile101 = _baseTile:Clone();
            _Tile101.Name = tostring(thisCoordinate);
            _Tile101.Position = thisOriginPosition;
            _Tile101.Parent = _baseTileContainer;
            -->Tempo
            local thisTile = _Utils_Tile.new();
            self._Canvas[tostring(thisTile)] = thisTile;
        end;
    end;
    -->Tempo
    _baseTileContainer.PrimaryPart = _baseTileContainer['0:0']
    _baseTileContainer:PivotTo(CFrame.new(gridPosition));
    -->Tempo
end;

function Grid:__ReadTemplate__(template: _Type.Grid_Template)
    -->>ParametersAuhentication
    local gridSize = template.Size;
    local gridPosition = template.Position;
    -->>CanvasDrawing
    self._eMesh = ASSET:CreateEditableMesh() ;
    local expansionScale = (_DrawingScale);
    local expansionHalfScale = (expansionScale/2);
    local rayBoostVector = (Vector3.new(0,_defaultRayLength-100,0)) ;
    local rayDirection = -Vector3.new(0,_defaultRayLength,0) ;
    _AreaParam.FilterDescendantsInstances = {template.Areas}
    for row = -gridSize,gridSize,1 do
        for col = -gridSize,gridSize,1 do
            local thisCoordinate = Coordinate.new(row, col);
            local thisOriginPosition = (gridPosition + Vector3.new(expansionScale*row,-3,expansionScale*col));
            -->>Raycast
            local rayOrigin = (thisOriginPosition + rayBoostVector);
            local rayCasted = workspace:Raycast(rayOrigin, rayDirection, _AreaParam);
            regionDetected = (rayCasted and rayCasted.Instance.Parent.Name);
            -->>Cornors
            local cfrm = CFrame.new(thisOriginPosition) ;
            local vctrI, vctrII, vctrIII = cfrm.Position, (cfrm.LookVector*expansionHalfScale), (cfrm.RightVector*expansionHalfScale);
            local thisCorners = {
				vctrI + vctrII + vctrIII;
				vctrI + vctrII - vctrIII;
				vctrI - vctrII - vctrIII;
				vctrI - vctrII + vctrIII;
			};
            local vrtxs = {};
            for i,v in thisCorners do vrtxs[i] = self._eMesh:AddVertex(v); end;
            local thisPolygons = table.create(2);
            thisPolygons[1] = self._eMesh:AddTriangle(vrtxs[1], vrtxs[2], vrtxs[3]);
            thisPolygons[2] = self._eMesh:AddTriangle(vrtxs[3], vrtxs[4], vrtxs[1]);
            for _,v in thisPolygons do self._Faces[v] = tostring(thisCoordinate); end;
            local thisArea = template.Configs[regionDetected] or template.Configs.Default;
            local thisConfigs = {
                ['CFrame'] = cfrm;
                ['Key'] = tostring(thisCoordinate);
                ['Coordinate'] = thisCoordinate;
                ['Corners'] = thisCorners;
                ['Polygons'] = thisPolygons ;
            };
            local thisTile = _Utils_Tile.new();
            for i,v in thisConfigs do thisTile[i] = v; end;
            for i,v in thisArea do thisTile[i] = v; end;
            self._Canvas[thisTile.Key] = thisTile;
        end;
    end;

    -->>eMeshVisualize
    self._Mesh = ASSET:CreateMeshPartAsync(Content.fromObject(self._eMesh)) ;
	for i,v in GridMeshSettings do self._Mesh[i] = v; end;
    self._Mesh:PivotTo(CFrame.new(gridPosition));
	self._Mesh.Name = 'GridMesh' ;
	self._Mesh.Parent = workspace.Terrain ;
end;

--->>> GenerationalMethods
function Grid:Draw(template: _Type.Grid_Template): _Type.Grid_Blueprint
    self:__ReadTemplate__(template);
    self['Active'] = true;
end;

function Grid:Load(blueprint: _Type.Grid_Blueprint): boolean
    self['Active'] = true;
end;

--->>> ActionMethods
function Grid:Pick(key: string): _Type.Tile
end;

function Grid:Raycast(): _Type.Tile
end;

--->>> Finalize
return Grid;