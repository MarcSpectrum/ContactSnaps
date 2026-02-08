local module = {} ;

local type_Signal = require('../../../_Shared/Customs/Signal/_Type') ;

export type _T = {
    _bindedContext: (nil|_Context) ;
    Bind: (key: string, connections: {[number]: {['Key']: string,['Func']: () -> any}}) -> (_Context|false) ;
} ;

export type _Context = {
    ContextKey: string ;
    __ValueChanged: type_Signal._T ;
    __Executed: type_Signal._T ;
    Enable: () -> boolean ;
    Disable: () -> boolean ;
} ;

return module ;