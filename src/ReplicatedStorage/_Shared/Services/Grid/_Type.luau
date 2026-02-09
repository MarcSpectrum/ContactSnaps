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
    __CreateBlueprint__: () -> Grid_Blueprint;
    __ReadBlueprint__: (blueprint: Grid_Blueprint) -> boolean;
    Draw: (template: Grid_Template) -> Grid_Blueprint;
    Load: (blueprint: Grid_Blueprint) -> boolean;
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