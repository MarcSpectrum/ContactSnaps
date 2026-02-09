--->>>Execution
local module = {} ;

local Voltage = require('../Controllers/Voltage');

local VoltModel = workspace.Terrain:WaitForChild('VoltTest'):WaitForChild('VoltModel');
game:GetService('ContentProvider'):PreloadAsync({VoltModel});

local VOLT = Voltage.new();

for _,v in VoltModel['Generator']:GetChildren() do VOLT:Insert(v, 'Generator'); end;
for _,v in VoltModel['Connector']:GetChildren() do VOLT:Insert(v, 'Connector'); end;

function module:__Init__()
end;

function module:__Start__()
end;

return module ;