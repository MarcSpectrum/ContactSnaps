local module = {} ;

export type _T = {
    _Head: _Link,
	_Tail: _Link,
	_Length: number,
	InsertFront: (self: _T, value: any) -> _Link,
	InsertBack: (self: _T, value: any) -> _Link,
	PickFront: (self: _T, value: any) -> _Link|nil,
	PickBack: (self: _T, value: any) -> _Link|nil,
	Iterate: (self: _T) -> () -> any,
    index: (self: _T) -> (),
	Cleanup: (self: _T) -> (),
} ;

export type _Link = {
    _Value: any,
	_Next: _Link,
	_Prev: _Link,
	_List: _T,
	Remove: (self: _Link) -> (),
	Destroy: (self: _Link) -> boolean,
} ;

return module ;