--->>> Variables
local ASSET = game:GetService('AssetService');
local RUN = game:GetService('RunService');

local Coordinate = require('../Customs/Coordinate');

local _IsServer = RUN:IsServer();

local _Camera = workspace.CurrentCamera ;

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
    Template = _Utils_Template;
};

--->>> SecretMethods
function Grid:__Clear__(): boolean
    if not _IsServer then
        if self._eMesh then self._eMesh:Destroy(); self._eMesh = nil; end;
        if self._Mesh then self._Mesh:Destroy(); self._Mesh = nil; end;
        if self._Highlight_eMesh then self._Highlight_eMesh:Destroy(); self._Highlight_eMesh = nil; end;
        if self._Highlight_Mesh then self._Highlight_Mesh:Destroy(); self._Highlight_Mesh = nil; end;
        table.clear(self._Faces);
    end;
    table.clear(self._Canvas);
    self['Active'] = false;
end;

function Grid:__ReadTemplate__(template: _Type.Grid_Template)
    -->>ParametersAuhentication
    local gridSize = template.Size;
    local gridPosition = template.Position;
    -->>CanvasDrawing
    self._eMesh = ASSET:CreateEditableMesh();
    local expansionScale = (_DrawingScale);
    local expansionHalfScale = (expansionScale/2);
    local rayBoostVector = (Vector3.new(0,_defaultRayLength-100,0)) ;
    local rayDirection = -Vector3.new(0,_defaultRayLength,0) ;
    _AreaParam.FilterDescendantsInstances = {template.Areas};
    local regionDetected = '';
    for row = -gridSize,gridSize,1 do
        for col = -gridSize,gridSize,1 do
            local thisCoordinate = Coordinate.new(row, col);
            local thisOriginPosition = (gridPosition + Vector3.new(expansionScale*row,0,expansionScale*col));
            -->>Raycast
            local rayOrigin = (thisOriginPosition + rayBoostVector);
            local rayCasted = workspace:Raycast(rayOrigin, rayDirection, _AreaParam);
            regionDetected = (rayCasted and rayCasted.Instance.Parent.Name);
            -->>Cornors
            local cfrm = CFrame.new(thisOriginPosition) ;
            local thisCorners;
            local thisPolygons;
            if not _IsServer then
                local vctrI, vctrII, vctrIII = cfrm.Position, (cfrm.LookVector*expansionHalfScale), (cfrm.RightVector*expansionHalfScale);
                thisCorners = {
                    vctrI + vctrII + vctrIII;
                    vctrI + vctrII - vctrIII;
                    vctrI - vctrII - vctrIII;
                    vctrI - vctrII + vctrIII;
                };
                local vrtxs = {};
                for i,v in thisCorners do vrtxs[i] = self._eMesh:AddVertex(v); end;
                thisPolygons = table.create(2);
                thisPolygons[1] = self._eMesh:AddTriangle(vrtxs[1], vrtxs[2], vrtxs[3]);
                thisPolygons[2] = self._eMesh:AddTriangle(vrtxs[3], vrtxs[4], vrtxs[1]);
                for _,v in thisPolygons do self._Faces[v] = tostring(thisCoordinate); end;
            end;
            -->>Configs
            local thisArea = template.Configs[regionDetected] or template.Configs.Default;
            local thisConfigs = {};
            thisConfigs['CFrame'] = cfrm;
            thisConfigs['Key'] = tostring(thisCoordinate);
            thisConfigs['Coordinate'] = thisCoordinate;
            if not _IsServer then
                thisConfigs['Corners'] = thisCorners;
                thisConfigs['Polygons'] = thisPolygons;
            end;
            local thisTile = _Utils_Tile.new();
            for i,v in thisConfigs do thisTile[i] = v; end;
            for i,v in thisArea do thisTile[i] = v; end;
            self._Canvas[thisTile.Key] = thisTile;
        end;
    end;

    -->>eMeshVisualize
    if not _IsServer then
        self._Mesh = ASSET:CreateMeshPartAsync(Content.fromObject(self._eMesh));
        for i,v in GridMeshSettings do self._Mesh[i] = v; end;
        self._Mesh:PivotTo(CFrame.new(gridPosition));
        self._Mesh.Name = 'GridMesh';
        self._Mesh.Parent = workspace.Terrain;
    end;
end;

--->>> GenerationalMethods
function Grid:Draw(template: _Type.Grid_Template)
    self:__Clear__();
    self:__ReadTemplate__(template);
    self['Active'] = true;
    return true;
end;

--->>> ActionMethods
function Grid:Pick(key: string): _Type.Tile
    return self['_Canvas'][tostring(key)];
end;

function Grid:Raycast(viewport: Vector3|Vector2): _Type.Tile
    local ray = _Camera:ViewportPointToRay(viewport.X, viewport.Y);
    local direction = (ray.Direction * _defaultRayLength);
    local cast = self._eMesh:RaycastLocal(ray.Origin, direction);
    local node = self._Faces[cast];
    node = node and self:Pick(node);
    return node;
end;

function Grid:Highlight(list: {string}, fillColor: Color3)
    if not self._Highlight_eMesh then self._Highlight_eMesh = ASSET:CreateEditableMesh(); end;
    for _,v in self._Highlight_eMesh:GetFaces() do self._Highlight_eMesh:RemoveFace(v); end;
    self._Highlight_eMesh:RemoveUnused();
    for _,key in list do
        local node = self:Pick(key);
        if not node then continue; end;
        local Corners = node['Corners'];
        local vrtxs = {};
        for i,v in Corners do vrtxs[i] = self._Highlight_eMesh:AddVertex(v); end;
        self._Highlight_eMesh:AddTriangle(vrtxs[1], vrtxs[2], vrtxs[3]);
        self._Highlight_eMesh:AddTriangle(vrtxs[3], vrtxs[4], vrtxs[1]);
    end;
    if not self._Highlight_Mesh then 
        self._Highlight_Mesh = ASSET:CreateMeshPartAsync(Content.fromObject(self._Highlight_eMesh));
        for i,v in GridMeshSettings do self._Highlight_Mesh[i] = v; end;
        self._Highlight_Mesh.Transparency = 0;
        self._Highlight_Mesh.Name = 'GridMesh';
        self._Highlight_Mesh.Parent = workspace.Terrain;
        self._Highlight = Instance.new('Highlight');
        self._Highlight.Parent = self._Highlight_Mesh;
    end;
    self._Highlight.FillColor = typeof(fillColor) == 'Color3' and fillColor or Color3.fromRGB(255, 167, 135)
    return true;
end;

--->>> Finalize
return Grid;