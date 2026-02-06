local _type = require('@self/_Type') ;

local freeRunnerThread = nil ;

local function acquireRunnerThreadAndCallEventHandler(fn, ...)
	local acquiredRunnerThread = freeRunnerThread ;
	freeRunnerThread = nil ;
	fn(...) ;
	freeRunnerThread = acquiredRunnerThread ;
end

local function runEventHandlerInFreeThread()
	while true do
		acquireRunnerThreadAndCallEventHandler(coroutine.yield()) ;
	end ;
end

local Connection = {} ;
Connection.__index = Connection ;
Connection.__newindex = function() 
	print('error - this table just like locked container'); 
    return ;
end ;

function Connection.new(signal: _type._T, fn: () -> any) : _type._Connection
    local self = setmetatable({
        _connected = true,
        _signal = signal,
        _fn = fn,
        _next = false,
    }, Connection) ;
	return self ;
end

function Connection:Disconnect() : boolean
	self._connected = false ;
	if self._signal._handlerListHead == self then
		self._signal._handlerListHead = self._next ;
	else
		local prev = self._signal._handlerListHead ;
		while prev and prev._next ~= self do
			prev = prev._next ;
		end ;
		if prev then
			prev._next = self._next ;
		end ;
	end ;
    return true ;
end

local Signal = {} ;
Signal.__index = Signal ;

function Signal.new() : _type._T
    local self = setmetatable({
        _handlerListHead = false,
    }
    , Signal) ;
	return self ;
end

function Signal:Connect(fn: () -> any) : _type._Connection
	local connection = Connection.new(self, fn) ;
	if self._handlerListHead then
		connection._next = self._handlerListHead ;
		self._handlerListHead = connection ;
	else
		self._handlerListHead = connection ;
	end ;
	return connection ;
end

function Signal:DisconnectAll() : boolean
	self._handlerListHead = false ;
    return true ;
end

function Signal:Fire(...) : boolean
	local item = self._handlerListHead ;
	while item do
		if item._connected then
			if not freeRunnerThread then
				freeRunnerThread = coroutine.create(runEventHandlerInFreeThread) ;
				coroutine.resume(freeRunnerThread) ;
			end ;
			task.spawn(freeRunnerThread, item._fn, ...) ;
		end ;
		item = item._next ;
	end ;
    return true ;
end

function Signal:Wait() : thread
	local waitingCoroutine = coroutine.running() ;
	local cn ;
	cn = self:Connect(function(...)
		cn:Disconnect() ;
		task.spawn(waitingCoroutine, ...) ;
	end) ;
	return coroutine.yield() ;
end

function Signal:Once(fn) : _type._Connection
	local cn ;
	cn = self:Connect(function(...)
		if cn._connected then
			cn:Disconnect() ;
		end ;
		fn(...) ;
	end)
	return cn ;
end

return Signal