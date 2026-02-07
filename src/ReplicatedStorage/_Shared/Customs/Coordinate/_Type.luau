local module = {} ;

export type _T = {
    Row: number ;
    Col: number ;
    Magnitude: number ;
    Key: string ;
    new: (row: number, col: number) -> _T ;
    IsA: (self: _T, v: string) -> boolean ;
    __tostring: (self: _T) -> string ;
    __unm: (self: _T) -> _T ;
    __add: (self: _T, other: _T) -> _T ;
    __sub: (self: _T, other: _T) -> _T ;
    __eq: (self: _T, other: _T) -> boolean ;
    __call: (self: _T, key: string) -> _T? ;
} ;

return module ;