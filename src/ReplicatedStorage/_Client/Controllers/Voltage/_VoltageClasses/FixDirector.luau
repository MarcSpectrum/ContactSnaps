--->>>OOP
local Constructor = {} ;

local Class = {
    Type = 'FixDirector';
} ;
Class.__index = Class

local _DefaultConstructor = require('./_DefaultConstructor');

--->>>ConstructorMethod
function Constructor.new(...)
    local this = setmetatable({}, Class);
    _DefaultConstructor.Construct(this, {...});
    this['Connections'] = {};
    return this;
end ;

--->>>ClassMethods
function Class:__Refresh__()
    local rayParam = RaycastParams.new()
    rayParam.FilterType = Enum.RaycastFilterType.Include;
    rayParam.FilterDescendantsInstances = self['basePlate'].Parent.Parent:GetChildren();
    local headOrigin = self['basePlate'].HeadDirection.WorldPosition + Vector3.new(0,20,0)
    local rayDirection = Vector3.new(0,-100,0);
    local raycasted = {
        workspace:Raycast(headOrigin,rayDirection,rayParam);
    };
    table.clear(self['Connections']);
    for _,v in raycasted do
        v = v.Instance.Name;
        local content = self.Voltage._Container[v]
        if not content then continue; end;
        if content['UniqueID'] == self['UniqueID'] then continue; end;
        if content._Solid == true then continue; end;
        table.insert(self['Connections'], content);
    end;
end;

function Class:__Interact__()
    self.Voltage:__Calculate__()
end;

return Constructor ;