local module = {} ;

local _type_LinkedList = require('../LinkedList/_Type');

export type _T = {
    new: () -> _Pool ;
    is: (self: _Pool) -> boolean ;
} ;

export type _Pool = {
    Key: string ;
    _Activated: _type_LinkedList._T ;
    _Inactivated: _type_LinkedList._T ;
    _RecycleBin: _type_LinkedList._T ;
    __Include__: (Value: any) -> _PoolLink ;
} ;

export type _PoolLink = {
    ID: string ;
    Value: any ;
    _Pool: _Pool;
    _PoolLink: _type_LinkedList._Link|nil;
    __MoveTo__: (TargetList: _type_LinkedList._T) -> boolean;
    __Exclude__:() -> boolean ;
    __Activate__: () -> boolean ;
    __Inactivate__: () -> boolean ;
} ;

return module ;