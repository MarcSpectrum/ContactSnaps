--| Types |--
local _type = require('@self/_Type') ;

--| Link |--
local Link = {} ;
Link.__index = Link ;
Link.__type = 'Link' ;
--Link.__newindex = function() print('error - this table just like locked container'); return end

function Link.new(value: any, list: _type._T): _type._Link
	local self = setmetatable({}, Link) ;
	self._Value = value ;
	self._List = list ;
	return self ;
end

function Link:Destroy()
	setmetatable(self, nil) ;
	table.clear(self);
    return true ;
end

function Link:Remove()
	local prev = self._Prev ;
	local next = self._Next ;

	if prev then 
		prev._Next = next 
	end ;
	if next then 
		next._Prev = prev 
	end ;

	local list = self._List ;
	if list then
		if list._Head == self then 
			list._Head = next 
		end ;
		if list._Tail == self then 
			list._Tail = prev 
		end ;
		list._Length -= 1 ;
	end ;

	self:Destroy() ;
end

--| LinkedList |--
local LinkedList = {} ;
LinkedList.__index = LinkedList ;
LinkedList.__type = 'LinkedList' ;
--LinkedList.__newindex = function() print('error - this table just like locked container'); return end

function LinkedList.new(): _type._T
	local self = setmetatable({}, LinkedList) ;
	self._Head = nil ;
	self._Tail = nil ;
	self._Length = 0 ;
	return self ;
end

function LinkedList:InsertFront(value: any): _type._Link
	local node = Link.new(value, self) ;
	node._Next = self._Head ;

	if self._Head then
		self._Head._Prev = node ;
	else
		self._Tail = node ;
	end

	self._Head = node ;
	self._Length += 1 ;
	return node ;
end

function LinkedList:InsertBack(value: any): _type._Link
	local node = Link.new(value, self) ;
	node._Prev = self._Tail ;

	if self._Tail then
		self._Tail._Next = node ;
	else
		self._Head = node ;
	end

	self._Tail = node ;
	self._Length += 1 ;
	return node ;
end

function LinkedList:PickFront(): _type._Link|nil
	if self._Length <= 0 then return; end;
	return self['_Head'];
end;

function LinkedList:PickBack(): _type._Link|nil
	if self._Length <= 0 then return; end;
	return self['_Tail'];
end;

function LinkedList:Iterate()
	local node = self._Head ;
	local n = 0 ;
	return function()
		if node then
			local val = node._Value ;
			node = node._Next ;
			n += 1 ;
			return n, val ;
		end
        return ;
	end ;
end

function LinkedList:Index()
	for _,v in self:Iterate() do 
		print(v) ; 
	end ;
end

function LinkedList:Cleanup()
	local node = self._Head ;
	while node do
		local next = node._Next ;
		node:Destroy() ;
		node = next ;
	end
	self._Head = nil ;
	self._Tail = nil ;
	self._Length = 0 ;
end

return LinkedList