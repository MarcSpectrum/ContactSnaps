local _PathFinding = {};

local Grid = require('../../Grid');

local _Type = require('../../Grid/_Type');

function _PathFinding.new(origin: _Type.Tile)
    local _fld = {[origin['Key']] = {Index = 0;Invrt = {};Outvrt = {};};};
	local _t1,_t2 = {origin},{[origin['Key']] = true};
	local _n,_t = 0,{};
    while #_t1 > 0 do
		for _,orgn in _t1 do
			_fld[orgn['Key']] = _fld[orgn['Key']] or {Index = _n;Invrt = {};Outvrt = {};}
            local orgnCoord = orgn.Coordinate;
			local _f = {
                Grid:Pick(orgnCoord.Row+1 .. ':' .. orgnCoord.Col);
                Grid:Pick(orgnCoord.Row-1 .. ':' .. orgnCoord.Col);
                Grid:Pick(orgnCoord.Row .. ':' .. orgnCoord.Col+1);
                Grid:Pick(orgnCoord.Row .. ':' .. orgnCoord.Col-1);
            };
			for _,v in _f do
				if v['Key'] == orgn['Key'] then continue end
				if _fld[v['Key']] then 
					table.insert(_fld[orgn['Key']].Invrt, v) 
				else
					table.insert(_fld[orgn['Key']].Outvrt, v)
				end
				if _t2[v['Key']] then continue end
				_t2[v['Key']] = true
				table.insert(_t, v);
			end;
		end;
		_t1, _t = _t, {}
		_n += 1
		if _n % 10 == 0 then task.wait() end
	end;
    return _fld, _n;
end;

function _PathFinding.track(pathField: {}, alpha: _Type.Tile)
    local t = pathField[alpha['Key']];
	if typeof(t) ~= 'table' then warn('Trace - Origin Unfound') ; return false end
	for _,v in t.Invrt do return v end
	return false;
end;

--->>> GGG

local function getNeighbors(tile)
    local c = tile.Coordinate
    return {
        Grid:Pick((c.Row+1)..":"..c.Col),
        Grid:Pick((c.Row-1)..":"..c.Col),
        Grid:Pick(c.Row..":"..(c.Col+1)),
        Grid:Pick(c.Row..":"..(c.Col-1)),
    }
end

function _PathFinding.find(alpha: _Type.Tile, omega: _Type.Tile)
    if alpha.Key == omega.Key then
        return { alpha }
    end

    local queue = { alpha }
    local visited = { [alpha.Key] = true }
    local cameFrom = {}

    local head = 1
    while queue[head] do
        local current = queue[head]
        head += 1

        for _, neighbor in getNeighbors(current) do
            if neighbor and not visited[neighbor.Key] then
                visited[neighbor.Key] = true
                cameFrom[neighbor.Key] = current

                if neighbor.Key == omega.Key then
                    -- reconstruct path
                    local path = { omega }
                    local node = current
                    while node do
                        table.insert(path, 1, node)
                        node = cameFrom[node.Key]
                    end
                    return path
                end

                table.insert(queue, neighbor)
            end
        end

        if head % 50 == 0 then task.wait() end
    end

    return false -- no path
end

--->>> GGG

return _PathFinding;