--->>>Execution
local module = {} ;

local Voltage = require('../Controllers/Voltage');

--[[
local VoltModel = workspace.Terrain:WaitForChild('VoltTest'):WaitForChild('VoltModel');
game:GetService('ContentProvider'):PreloadAsync({VoltModel});
local VOLT = Voltage.new();
for _,v in VoltModel['Generator']:GetChildren() do VOLT:Insert(v, 'Generator'); end;
for _,v in VoltModel['Connector']:GetChildren() do VOLT:Insert(v, 'Connector'); end;
--for _,v in VoltModel['Holder']:GetChildren() do VOLT:Insert(v, 'Holder'); end;
--for _,v in VoltModel['Collector']:GetChildren() do VOLT:Insert(v, 'Collector'); end;
for _,v in VoltModel['FixDirector']:GetChildren() do VOLT:Insert(v, 'FixDirector'); end;
for _,v in VoltModel['FlexDirector']:GetChildren() do VOLT:Insert(v, 'FlexDirector'); end;
VOLT:__Calculate__()
]]

function module:__Init__()
end;

function module:__Start__()
end;

return module ;