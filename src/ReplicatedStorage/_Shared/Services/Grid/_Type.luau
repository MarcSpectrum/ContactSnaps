local _TypeCoordinate = require('../../Customs/Coordinate/_Type');

export type Constructor = {
    new: (...any) -> any;
    is: (...any) -> any;
}

export type Grid = {
    Utilities: {[string]: Constructor};
    Active: boolean;
    _Faces: {};
    _Canvas: {[string]: Tile};
    _eMesh: EditableMesh;
    _Mesh: MeshPart;
    _Highlight_eMesh: EditableMesh;
    _Highlight_Mesh: MeshPart;
    _Highlight: Highlight;
    Draw: (template: Grid_Template) -> Grid_Blueprint;
    Pick: (key: string) -> Tile|nil;
    Raycast: (viewport: Vector3|Vector2) -> Tile|nil;
    Highlight: (list: {string}) -> boolean;
};

export type Grid_Template = {
    Size: number;
    Position: Vector3;
    Areas: {[string]: BasePart};
    Configs: {[string]: {[string]: any}};
};

export type Grid_Blueprint = {
};

export type Tile = {
    Active: boolean;
    Key: string;
    CFrame: CFrame;
    Coordinate: _TypeCoordinate._T;
    Corners: {};
    Polygons: {};
};

return {};