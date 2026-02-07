local Coordinate = {} ;
Coordinate.__index = Coordinate ;
Coordinate.__type = 'Coordinate' ;

local _type = require('@self/_Type') ;

Coordinate.__newindex = function() warn('Error - This Table Is Locked'); return; end ;

function Coordinate.new(row: number, col: number) : _type._T
    local self = setmetatable({}, Coordinate) ;
    rawset(self, 'Row', typeof(row) == 'number' and row or 0) ;
    rawset(self, 'Col', typeof(col) == 'number' and col or 0) ;
    rawset(self, 'Key', (self.Row .. ':' .. self.Col)) ;
    rawset(self, 'Magnitude', (self.Row + self.Col)) ;
    return self ;
end ;

function Coordinate:IsA(v: string)
	return (self.__type == v) ;
end ;

function Coordinate.__tostring(self: _type._T): string
    return self.Key ;
end ;

function Coordinate.__unm(self: _type._T) : _type._T
	return Coordinate.new(self.Row ~= 0 and -self.Row or 0, self.Col ~= 0 and -self.Col or 0) ;
end ;

function Coordinate.__add(self: _type._T, other: _type._T): _type._T
    return Coordinate.new(self.Row + other.Row, self.Col + other.Col) ;
end ;

function Coordinate.__sub(self: _type._T, other: _type._T): _type._T
    return Coordinate.new(self.Row - other.Row, self.Col - other.Col) ;
end ;

function Coordinate.__eq(self: _type._T, other: _type._T): boolean
    return self.Row == other.Row and self.Col == other.Col ;
end ;

function Coordinate.__call(self: _type._T, key: string): any
    key = tostring(key) ;
    if key == 'Unit' then
        return Coordinate.new(self.Row ~= 0 and math.sign(self.Row) or 0, self.Col ~= 0 and math.sign(self.Col) or 0) ;
    elseif key == 'Magnitude' then
        return self.Magnitude ;
    end ;
    return ;
end ;

return Coordinate