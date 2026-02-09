local _DefaultConstructor = {};

local HTTP = game:GetService('HttpService');

local _UniqueIDLog = {};

function _DefaultConstructor.Construct(self, parameters)
    self['basePlate'] = parameters[1];
    self['Voltage'] = parameters[2];
    self['_Charged'] = false;
    self['_Solid'] = false;
    self['_VoltColor'] = Color3.fromHSV(0, 0, 0);
    local UniqueID;
    repeat UniqueID = HTTP:GenerateGUID(false); until not _UniqueIDLog[UniqueID];
    _UniqueIDLog[UniqueID] = true;
    self['UniqueID'] = UniqueID;
    self['basePlate'].Name = self['UniqueID'];
end;

return _DefaultConstructor