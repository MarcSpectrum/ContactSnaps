--[[ Variables ]]--
local _Type = require('@self/_Type') ;
local _Contexts: {[string]: _Type._Context} = {} ;

local _bindedContext = nil ;
local _Debouce = false ;

--[[ ContextsLoading ]]--
local contextsModule = script:WaitForChild('_Contexts') ;
for _,v in contextsModule:GetChildren() do _Contexts[v.Name] = require(v); end ;

--[[ Self ]]--
local module = {} :: _Type._T ;

--[[ MainOperations ]]--
-->> Need Default Event for each module to connect in this operation
-->> and disconnect after :Disable()?
function module:Bind(key: string, connections: {[number]: {['Key']: string,['Func']: () -> any}}) : (_Type._Context|false)
    if _Debouce == true then return false; end ;
    _Debouce = true ;
    key = tostring(key) ;
    local action = _Contexts[key] ;
    if not action then _Debouce = false; return false; end ;
    if _bindedContext then
        _bindedContext:Disable() ;
        if _bindedContext['ContextKey'] == key then 
            _bindedContext = nil ; 
            _Debouce = false ; 
            return false ; 
        end ;
        _bindedContext = nil ;
    end ;
    _bindedContext = action ;
    connections = type(connections) == 'table' and connections or {} ;
    for _,set in connections do _bindedContext[set.Key]:Connect(set.Func); end ;
    _bindedContext:Enable() ;
    _Debouce = false ;
    return _bindedContext ;
end ;

--[[ Initialization ]]--
function module:Init()
end ;

function module:Start()
end ;

return module ;