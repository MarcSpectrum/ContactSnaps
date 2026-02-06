local module = {} ;

export type _T = {
    _handlerListHead: _Connection?,
    Connect: (fn: () -> any) -> _Connection,
    DisconnectAll: () -> boolean,
    Fire: (any) -> boolean,
    Wait: () -> thread,
    Once: (fn: () -> any) -> _Connection,
} ;


export type _Connection = {
    _connected: boolean?,
	_signal: _T?,
	_fn: () -> any?,
	_next: boolean?,
    Disconnect: () -> boolean,
} ;

return module ;